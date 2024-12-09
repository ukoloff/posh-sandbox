#
# Remove stale 1C lock-file(s)
#
param( # Для самостоятельной установки запуска по расписанию
  [switch]$install,
  [switch]$remove
)

if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir
  $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1) -RandomDelay 00:12:00
  $Task = New-ScheduledTask -Action $Action -Trigger $Trigger
  Register-ScheduledTask -TaskName $me -TaskPath uxm -InputObject $Task -User "System" -Force
  exit
}

if ($remove) {
  $me = Split-Path $PSCommandPath -Leaf
  Unregister-ScheduledTask -TaskName $me -TaskPath '\uxm\' -Confirm:$false
  exit
}

$d = Get-Date
$d = $d.AddMinutes(-1)

Get-ChildItem -LiteralPath $env:TEMP -Filter 1c_*.lock |
Where-Object { $_.CreationTime -le $d } |
Remove-Item
