#
# Run on TSG authorization
#
param(
  [switch]$install,
  [switch]$remove
)

$Filter = @{
  LogName = 'Microsoft-Windows-TerminalServices-Gateway/Operational';
  ID      = 300;
}


if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir

  # https://stackoverflow.com/a/67123362/6127481
  $CIMTriggerClass = Get-CimClass -ClassName MSFT_TaskEventTrigger -Namespace Root/Microsoft/Windows/TaskScheduler:MSFT_TaskEventTrigger
  $trigger = New-CimInstance -CimClass $CIMTriggerClass -ClientOnly
  $trigger.Subscription = @"
    <QueryList>
      <Query Id="0" Path="$($Filter['LogName'])">
        <Select Path="$($Filter['LogName'])">*[System[(EventID=$($Filter['ID']))]]</Select>
      </Query>
    </QueryList>
"@
  $trigger.Enabled = $True
  $Task = New-ScheduledTask -Action $Action -Trigger $trigger
  Register-ScheduledTask -TaskName $me -TaskPath uxm\tsg -InputObject $Task -User "System" -Force
  exit
}

if ($remove) {
  $me = Split-Path $PSCommandPath -Leaf
  Unregister-ScheduledTask -TaskName $me -TaskPath '\uxm\tsg\' -Confirm:$false
  exit
}

$log = "$PSCommandPath.log"

$ev = Get-WinEvent -FilterHashTable $Filter -MaxEvents 1
if (!$ev) { exit }

$x = ([xml]$ev.ToXml()).Event.UserData.EventInfo
$x = @{
  ip   = $x.IpAddress
  user = $x.Username
  host = $x.Resource
}

function readARP {
  $cred = Get-StoredCredential -Target pqsql:TSG  # Fallback to Kerberos if not found
  Open-PostGreConnection -Server pg.ekb.ru -Database uxm -Credential $cred
  Start-SqlTransaction

  $j = Invoke-WebRequest https://nc.ekb.ru/omz/service/arp -UseBasicParsing |
  Select-Object -ExpandProperty Content |
  ConvertFrom-Json
  $j | ForEach-Object {
    # https://stackoverflow.com/a/17267423/6127481
    $null = Invoke-SqlUpdate @"
      merge into arp using (values
        (@ip, @mac, clock_timestamp()))
        as vals (ip, mac, mtime)
        on arp.ip = vals.ip
    when matched then
    update
      set
        mac = vals.mac,
        mtime = vals.mtime
    when not matched then
      insert (ip, mac, mtime)
      values (vals.ip, vals.mac, vals.mtime)
"@ -ParamObject $_
  }
  Complete-SqlTransaction
  Close-SqlConnection
}

# "$(Get-Date) [$args]`t$(ConvertTo-Json $x)" >> $log

readARP
