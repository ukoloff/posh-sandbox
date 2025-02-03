#
# Рассылка серии приветственных писем новому сотруднику
#
$newEmployees = '\\omzglobal.com\uxm\Exchange\employee_mail.csv'

foreach ($user in Import-Csv $newEmployees -Delimiter ';' -Encoding UTF8) {
  $user
}
