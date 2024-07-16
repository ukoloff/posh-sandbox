$log = 'Microsoft-Windows-TerminalServices-Gateway/Operational'

$e = Get-WinEvent -FilterHashTable @{
  LogName   = $log;
  ID        = 303;
} -MaxEvents 1
$x = [xml]$e.ToXml()
$i = $x.Event.UserData.EventInfo
$row = @{
  rec_id    = $e.RecordId;
  start     = $e.TimeCreated.AddSeconds(-[int]$i.SessionDuration)
  end =  $e.TimeCreated;
  duration  = [int]$i.SessionDuration;
  guid   = $e.ActivityId;
  ip    = $i.IpAddress;
  user  = $i.Username;
  host  = $i.Resource;
  proto = $i.ConnectionProtocol;
  inb   = [int]$i.BytesReceived;
  outb  = [int]$i.BytesTransfered;
}
