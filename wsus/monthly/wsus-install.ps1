#
# Установка обновлений Windows без перезагрузки
#
$d = Get-Date
if ([int]$d.DayOfWeek -ne 6 -or [Math]::Truncate(($d.Day + 6) / 7) -ne 3) {
  # НЕ 3-я суббота
  exit
}

$dir = Split-Path $PSCommandPath -Parent
$log = Join-Path $dir Logs
$log = Join-Path $log $d.ToString("yyyy-MM-dd")
$log = New-Item $log -Force -ItemType Directory
$log = Join-Path $log "$($env:COMPUTERNAME)-$($d.ToString("HH-mm-ss_fff")).log"

function installModule() {
  Expand-Archive -LiteralPath (Join-Path $dir PSWindowsUpdate.zip) -DestinationPath "$env:ProgramFiles\WindowsPowerShell\Modules" -Force
}

function importModule() {
  Import-Module PSWindowsUpdate -ErrorVariable $err
  if (!$err) { return }
  Write-Output "Installing module: PSWindowsUpdate"
  installModule
  Import-Module PSWindowsUpdate
}

& {
  importModule

  Write-Output "[Installing updates]"
  Install-WindowsUpdate -AcceptAll -IgnoreReboot

  Write-Output "[Reboot]"
  Get-WURebootStatus

  Write-Output "[History]"
  Get-WUHistory -MaxDate (Get-Date).AddDays(-1)

  Write-Output "[Settings]"
  Get-WUSettings

} > $log 2>&1
