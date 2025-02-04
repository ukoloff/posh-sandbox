#
# Рассылка серии приветственных писем новому сотруднику
#
$newEmployees = '\\omzglobal.com\uxm\Exchange\employee_mail.csv'

$newEmployees = Join-Path (Split-Path $PSCommandPath -Parent) test\users.csv

$db = Join-Path (Split-Path $PSCommandPath -Parent) .db
$db = New-Item $db -Force -ItemType Directory
$db = Join-Path $db welcome.sq3
Open-SQLiteConnection $db
$isNew = (Get-Item $db).Length -eq 0
if ($isNew) {
  $sql = Get-Content -Raw (Join-Path (Split-Path $PSCommandPath -Parent) ddl.sql)
  $n = Invoke-SqlUpdate $sql
}

foreach ($user in Import-Csv $newEmployees -Delimiter ';' -Encoding UTF8) {
  $n = Invoke-SqlUpdate @"
    Insert Or Ignore Into
      users(user)
    Values(@u)
"@ -Parameters @{u=$user.sAMAccountName}
}

if ($isNew) {
  $n = Invoke-SqlUpdate @"
    Update users
    Set ztime = CURRENT_TIMESTAMP
"@
}

[array]$users = Invoke-SqlQuery @"
  Select user
  From users
  Where
    ztime is Null
"@ -WarningAction Ignore

foreach ($user in $users) {
  $u = $user.user
  $u = Get-ADUser $u -Properties mail,middleName
  if (!$u.Enabled -or !$u.mail) {
    continue
  }
  $u
}

Close-SqlConnection
