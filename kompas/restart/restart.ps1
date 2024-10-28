#
# Force restart remote computer
#

$who = 'Win10-3'

Invoke-Command -ComputerName $who -ScriptBlock {
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument "-c Restart-Computer -Force"
  $Trigger = New-ScheduledTaskTrigger -Once -At 01:23
  $Trigger.RandomDelay = "PT5H"
  $Settings = New-ScheduledTaskSettingsSet -DeleteExpiredTaskAfter 00:01:00
  $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
  $Task.Triggers[0].EndBoundary = (Get-Date).AddMinutes(1).ToString('s')
  Register-ScheduledTask -TaskName "updateKompas" -TaskPath uxm -InputObject $Task -User "System" -Force | Out-Null
}
