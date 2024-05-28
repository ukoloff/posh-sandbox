#
# Запускается на шлюзе
#
# srvrds-ekbh3.omzglobal.com
#

$log = 'Microsoft-Windows-TerminalServices-Gateway/Operational'

Get-WinEvent -FilterHashTable @{
  LogName   = $log;
  ID        = 302, 303;
  StartTime = '2024-05-28 10:00:00'
} -MaxEvents 50 | % {
  $x = [xml]$_.ToXml()
  $i = $x.Event.UserData.EventInfo
  [PSCustomObject]@{
    id    = $_.RecordId;
    event = $_.Id;
    ctime = $_.TimeCreated;
    key   = $_.ActivityId;
    ip    = $i.IpAddress;
    user  = $i.Username;
    host  = $i.Resource;
    inb   = $i.BytesReceived;
    outb  = $i.BytesTransfered;
    time  = $i.SessionDuration;
  }
} | Out-GridView
