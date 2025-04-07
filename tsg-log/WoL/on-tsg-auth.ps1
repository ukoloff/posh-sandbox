#
# Run on TSG authorization
#
param(
  [switch]$install,
  [switch]$remove
)

if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir

  # https://stackoverflow.com/a/67123362/6127481
  $CIMTriggerClass = Get-CimClass -ClassName MSFT_TaskEventTrigger -Namespace Root/Microsoft/Windows/TaskScheduler:MSFT_TaskEventTrigger
  $trigger = New-CimInstance -CimClass $CIMTriggerClass -ClientOnly
  $trigger.Subscription = @"
    <QueryList>
      <Query Id="0" Path="Microsoft-Windows-TerminalServices-Gateway/Operational">
        <Select Path="Microsoft-Windows-TerminalServices-Gateway/Operational">*[System[(EventID=300)]]</Select>
      </Query>
    </QueryList>
"@
  $trigger.Enabled = $True
  $Task = New-ScheduledTask -Action $Action -Trigger $trigger
  Register-ScheduledTask -TaskName $me -TaskPath uxm -InputObject $Task -User "System" -Force
  exit
}

if ($remove) {
  $me = Split-Path $PSCommandPath -Leaf
  Unregister-ScheduledTask -TaskName $me -TaskPath '\uxm\' -Confirm:$false
  exit
}

