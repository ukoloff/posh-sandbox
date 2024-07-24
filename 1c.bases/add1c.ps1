#
# Настройка баз 1С
#
param(
  [switch]$install,
  [switch]$remove
)

if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir
  $Trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME -RandomDelay 00:03:00
  $Task = New-ScheduledTask -Action $Action -Trigger $Trigger
  Register-ScheduledTask -TaskName $me -TaskPath uxm -InputObject $Task -Force
  exit
}

if ($remove) {
  $me = Split-Path $PSCommandPath -Leaf
  Unregister-ScheduledTask -TaskName $me -TaskPath '\uxm\' -Confirm:$false
  exit
}

$dst = Join-Path $env:APPDATA 1C\1CEStart
$src = Split-Path $PSCommandPath -Parent
$src = Join-Path $src ibases.v8i
Copy-Item $src $dst
