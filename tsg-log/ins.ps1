$log = 'Microsoft-Windows-TerminalServices-Gateway/Operational'

Open-PostGreConnection -Server 'pg.ekb.ru' -Database uxm -Credential $cred
$end = Invoke-SqlScalar 'Select max("end") from tsg' -Parameters $row

$Filter = @{
  LogName = $log;
  ID      = 303;
}
if($end) {
  $Filter['StartTime'] = $end.ToLocalTime().AddSeconds(-108)
}

$Filter
exit

$e = Get-WinEvent -FilterHashTable @{
  LogName = $log;
  ID      = 303;
} -MaxEvents 1
$x = [xml]$e.ToXml()
$i = $x.Event.UserData.EventInfo
$row = @{
  rec_id   = $e.RecordId;
  start    = $e.TimeCreated.AddSeconds( - [int]$i.SessionDuration)
  end      = $e.TimeCreated;
  duration = [int]$i.SessionDuration;
  guid     = $e.ActivityId;
  ip       = $i.IpAddress;
  user     = $i.Username;
  host     = $i.Resource;
  proto    = $i.ConnectionProtocol
  inb      = [int]$i.BytesReceived;
  outb     = [int]$i.BytesTransfered;
}

$sqlAdd = @"
  Insert Into tsg($($row.Keys.ForEach({"`"$_`""}) -join ", "))
  Values ($($row.Keys.ForEach({"@$_"}) -join ", "))
"@

Invoke-SqlScalar $sqlAdd -Parameters $row
Close-SqlConnection
