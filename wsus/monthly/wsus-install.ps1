#
# Установка обновлений Windows без перезагрузки
#
$d = Get-Date
if ([int]$d.DayOfWeek -ne 6 -or [Math]::Truncate(($d.Day + 6) / 7) -ne 3) {
  # НЕ 3-я суббота
  exit
}
