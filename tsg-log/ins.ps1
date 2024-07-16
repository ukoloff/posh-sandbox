$log = 'Microsoft-Windows-TerminalServices-Gateway/Operational'


# Store Credentials:
# ------------------
# $cred = Get-Credential
# # Install-Module -Name CredentialManager
# New-StoredCredential -Target pqsql:TSG -Credentials $cred -Persist LocalMachine
$cred = Get-StoredCredential -Target pqsql:TSG  # Try Kerberos if not found
Open-PostGreConnection -Server 'pg.ekb.ru' -Database uxm -Credential $cred

$logID = Invoke-SqlScalar 'Insert Into tsg_log(id) Values(Default) Returning id'

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
$txTime = Get-Date

Get-WinEvent -FilterHashTable $Filter -Oldest |
ForEach-Object {
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
  if (!$sqlFound) {
    $sqlFound = @"
      Select Count(*)
      From tsg
      Where $($row.Keys.ForEach({ "`"$_`" = @$_"}) -join ' And ')
"@
    echo $sqlFound
  }
  $n = Invoke-SqlScalar $sqlFound -Parameters $row
  if ($n -eq 0) {
    $row['log_id'] = $logID
    $row['start'] = $row['end'].AddSeconds($row['duration'])
    if (!$sqlAdd) {
      $sqlAdd = @"
        Insert Into tsg($($row.Keys.ForEach({"`"$_`""}) -join ", "))
        Values ($($row.Keys.ForEach({"@$_"}) -join ", "))
"@
    }
    Invoke-SqlScalar $sqlAdd -Parameters $row
    $Total++
    if ($Total % 1000 -eq 0) {
      [PSCustomObject]$row | Format-Table -HideTableHeaders  end, ip, user, host, duration
    }
    $now = Get-Date
    if (($now - $txTime).TotalSeconds -ge 27) {
      Write-Host "Commit $Total records"
      Complete-SqlTransaction
      Start-SqlTransaction
      $txTime = Get-Date
    }
  }
}

Complete-SqlTransaction
Close-SqlConnection
