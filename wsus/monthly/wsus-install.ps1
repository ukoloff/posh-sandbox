#
# Установка обновлений Windows без перезагрузки
#
$d = Get-Date
if ([int]$d.DayOfWeek -ne 6 -or [Math]::Truncate(($d.Day + 6) / 7) -ne 3) {
  # НЕ 3-я суббота
  # exit
}

$dir = Split-Path $PSCommandPath -Parent
$log = Join-Path $dir Logs
$log = Join-Path $log $d.ToString("yyyy-MM-dd")
$log = New-Item $log -Force -ItemType Directory
$log = Join-Path $log "$($env:COMPUTERNAME)-$($d.ToString("HH-mm-ss_fff")).log"

& {
  echo "Hello, world!"
} > $log 2>&1
