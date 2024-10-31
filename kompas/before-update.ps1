#
# Проверка хоста на готовность (ручного) обновления
#

$me = Split-Path $PSCommandPath -Parent
$src = Join-Path $me candidates.txt
$hosts = Get-Content $src | Sort-Object

foreach ($who in $hosts) {
  Write-Output "Testing: $who"

  $online = Test-Connection $who -Quiet -Count 1

  if (!$online) {
    Write-Output "Status: offline"
    continue
  }

  $ver = Invoke-Command -ComputerName $who -ScriptBlock {
    Get-ItemPropertyValue HKLM:\SOFTWARE\ASCON\KOMPAS-3D\21 -Name ProductVersion }

  Write-Output "Kompas version: $ver"

  query user "/server:$who"

  [array]$run = Get-CimInstance -ComputerName $who -ClassName Win32_Process -Filter "Name Like 'kompas%' Or Name Like 'msiexec%'"
  Write-Output "Running process(es): $($run.count)"
  $run
  Write-Output ""

  if ($run.count -gt 0 -or !($ver.StartsWith('21.0.0.'))) {
    continue
  }

  Write-Output "Installing..."
  psexec -s "\\$who" msiexec /update \\service\Soft\kompasspatch\KOMPAS-3D_v21.0.26_x64.msp /quiet
}
