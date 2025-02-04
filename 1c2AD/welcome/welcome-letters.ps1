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
"@ -Parameters @{u = $user.sAMAccountName }
}

if ($isNew) {
  $n = Invoke-SqlUpdate @"
    Update users
    Set ztime = CURRENT_TIMESTAMP
"@
}

[array]$users = Invoke-SqlQuery @"
  Select
    id, user,
    (select max(stage) from sent where sent."user" = users.id) as stage
  From users
  Where
    ztime is Null
"@ -WarningAction Ignore

foreach ($user in $users) {
  $u = Get-ADUser $user.user -Properties mail, middleName
  if (!$u.Enabled -or !$u.mail) {
    continue
  }
  if ($user.stage -eq [System.DBNull]::Value) {
    # Первое письмо посылаем тут же
    $stage = 1
  }
  else {
    # Последующие письма на следующий день
    $ok = Invoke-SqlScalar @"
      Select
        date(ctime) < date(CURRENT_TIMESTAMP)
      From sent
      Where sent."user" = @id
      Order by stage Desc
      Limit 1
"@ -Parameters @{id = $user.id }
    if (!$ok) {
      continue
    }
    $stage = $user.stage + 1
  }
  $body = Join-Path (Split-Path $PSCommandPath -Parent) "body\$stage.txt"
  if (!(Test-Path $body -PathType Leaf)) {
    $n = Invoke-SqlUpdate @"
      Update users
      Set ztime = CURRENT_TIMESTAMP
      Where id = @id
"@ -Parameters @{id = $user.id }
    continue
  }
  $n = Invoke-SqlUpdate @"
    Insert Into
      sent(user, stage)
    Values(@id, @stage)
"@ -Parameters @{id = $user.id; stage = $stage }
}

Close-SqlConnection
