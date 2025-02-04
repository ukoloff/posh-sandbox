#
# Рассылка серии приветственных писем новому сотруднику
#
$newEmployees = '\\omzglobal.com\uxm\Exchange\employee_mail.csv'

$db = Join-Path (Split-Path $PSCommandPath -Parent) .db
$db = New-Item $db -Force -ItemType Directory
$db = Join-Path $db welcome.sq3
Open-SQLiteConnection $db
if ((Get-Item $db).Length -eq 0) {
  $sql = Get-Content -Raw (Join-Path (Split-Path $PSCommandPath -Parent) ddl.sql)
  Invoke-SqlUpdate $sql
}

foreach ($user in Import-Csv $newEmployees -Delimiter ';' -Encoding UTF8) {
  $user.sAMAccountName
}

Close-SqlConnection
