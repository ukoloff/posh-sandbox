#
# Import Remote Desktop Gateway logs into PostgreSQL
#
param(
  [switch]$install,
  [switch]$remove
)

if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir
  $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Hours 1) -RandomDelay 00:05:00
  $Task = New-ScheduledTask -Action $Action -Trigger $Trigger
  Register-ScheduledTask -TaskName $me -TaskPath uxm -InputObject $Task -User "System" -Force
  exit
}

if ($remove) {
  $me = Split-Path $PSCommandPath -Leaf
  Unregister-ScheduledTask -TaskName $me -TaskPath '\uxm\' -Confirm:$false
  exit
}

$startAt = Get-Date

$log = 'Microsoft-Windows-TerminalServices-Gateway/Operational'

# Store Credentials:
# ------------------
# $cred = Get-Credential
# # Install-Module -Name CredentialManager
# New-StoredCredential -Target pqsql:TSG -Credentials $cred -Persist LocalMachine
$cred = Get-StoredCredential -Target pqsql:TSG  # Fallback to Kerberos if not found
Open-PostGreConnection -Server 'pg.ekb.ru' -Database uxm -Credential $cred

$logID = Invoke-SqlScalar @"
  Insert Into tsg_log("domain", "user", "host")
  Values(@domain, @user, @host)
  Returning id
"@ -Parameters @{domain = $env:USERDOMAIN; user = $env:USERNAME; host = $env:COMPUTERNAME }

$Filter = @{
  LogName = $log;
  ID      = 303;
}
$row = Invoke-SqlQuery 'Select max("end") as fence, count(*) as n from tsg'
if ($row.n) {
  $Filter['StartTime'] = $row.fence.ToLocalTime().AddSeconds(-108)
}

Start-SqlTransaction

$Total = 0
$Already = 0
$Found = 0
$txTime = Get-Date
$lastPing = ''

Get-WinEvent -FilterHashTable $Filter -Oldest |
ForEach-Object {
  $Found++
  $x = [xml]$_.ToXml()
  $i = $x.Event.UserData.EventInfo
  $row = @{
    rec_id   = $_.RecordId;
    # start    = $_.TimeCreated.AddSeconds( - [int]$i.SessionDuration)
    end      = $_.TimeCreated;
    guid     = $_.ActivityId.Guid;
    duration = [int]$i.SessionDuration;
    ip       = $i.IpAddress;
    user     = $i.Username;
    host     = $i.Resource;
    proto    = $i.ConnectionProtocol
    inb      = [long]$i.BytesReceived;
    outb     = [long]$i.BytesTransfered;
  }
  if ($row['guid'] -eq $null) {
    $row['guid'] = '-'
  }
  if (!$sqlFound) {
    $sqlFound = @"
      Select Count(*)
      From tsg
      Where $($row.Keys.ForEach({ "`"$_`" = @$_"}) -join ' And ')
"@
  }
  $n = Invoke-SqlScalar $sqlFound -Parameters $row
  if ($n -eq 0) {
    $row['log_id'] = $logID
    $row['start'] = $row['end'].AddSeconds(-$row['duration'])
    if (!$sqlAdd) {
      $sqlAdd = @"
        Insert Into tsg($($row.Keys.ForEach({"`"$_`""}) -join ", "))
        Values ($($row.Keys.ForEach({"@$_"}) -join ", "))
"@
    }
    Invoke-SqlScalar $sqlAdd -Parameters $row
    $Total++
    $now = $row['end'].ToString('d')
    if ($now -ne $lastPing) {
      $lastPing = $now
      Write-Host -NoNewline "`r$now"
    }
    $now = Get-Date
    if (($now - $txTime).TotalSeconds -ge 27) {
      Write-Host "`rCommit $($Total - $Already) records"
      $Already = $Total
      Complete-SqlTransaction
      Start-SqlTransaction
      $txTime = Get-Date
    }
  }
}

Write-Host "`rCommit $($Total - $Already) records"
Complete-SqlTransaction
Close-SqlConnection

Write-Host @"
Records found:`t$Found
Records added:`t$Total
Time elapsed:`t$((Get-Date) - $startAt)
"@
