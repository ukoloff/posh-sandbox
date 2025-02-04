#
# Рассылка серии приветственных писем новому сотруднику
#
$newEmployees = '\\omzglobal.com\uxm\Exchange\employee_mail.csv'

$db = Split-Path $PSCommandPath -Parent
$db = Join-Path $db .db
$db = New-Item $db -Force -ItemType Directory
$db = Join-Path $db welcome.sq3
echo ""> $db

foreach ($user in Import-Csv $newEmployees -Delimiter ';' -Encoding UTF8) {
  $user.sAMAccountName
}
