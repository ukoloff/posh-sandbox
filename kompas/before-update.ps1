#
# Проверка хоста на готовность (ручного) обновления
#

$who = 'uxm00743'
# $who = 'uxm00437'

Write-Output "Testing: $who"

$online = Test-Connection $who -Quiet -Count 1

if (!$online) {
  Write-Output "Status: offline"
  exit
}

$ver = Invoke-Command -ComputerName $who -ScriptBlock {
  Get-ItemPropertyValue HKLM:\SOFTWARE\ASCON\KOMPAS-3D\21 -Name ProductVersion }

Write-Output "Kompas version: $ver"

[array]$run = Get-CimInstance -ComputerName $who -ClassName Win32_Process -Filter "Name Like 'kompas%' Or Name Like 'msiexec%'"
Write-Output "Running process(es): $($run.count)"
$run
Write-Output ""

if ($run.count -gt 0 -or !($ver.StartsWith('21.0.0.'))) {
  Write-Output "Exiting"
  exit
}

Write-Output "Installing..."
psexec -s "\\$who" msiexec /update \\service\Soft\kompasspatch\KOMPAS-3D_v21.0.26_x64.msp /quiet
