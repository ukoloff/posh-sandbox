#
# Force restart remote computer
#

$who = 'Win10-3'

Invoke-Command -ComputerName $who -ScriptBlock {
  $now = Get-Date
  $at = Get-Date "$(Get-Date $now -UFormat %Y-%m-%d) 01:23:00"
  if ($now -ge $at) {
    $at = $at.AddDays(1)
  }
  $hours = 5
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument "-c Restart-Computer -Force"
  $Trigger = New-ScheduledTaskTrigger -Once -At $at
  $Trigger.RandomDelay = "PT$($hours)H"
  $Settings = New-ScheduledTaskSettingsSet -DeleteExpiredTaskAfter 00:01:00
  $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
  $Task.Triggers[0].EndBoundary = $at.AddHours($hours + 1).ToString('s')
  Register-ScheduledTask -TaskName "updateKompas" -TaskPath uxm -InputObject $Task -User "System" -Force | Out-Null
}
