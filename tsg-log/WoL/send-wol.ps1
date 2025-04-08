#
# Send Wake-on-LAN magic packet
#
$mac = '74-56-3C-87-B0-06'
$ip = '10.164.201.255'

# https://github.com/krzydoug/Tools/blob/master/Send-WakeOnLan.ps1

$macs = $MAC -split "[:-]" | ForEach-Object { [Byte] "0x$_" }
[Byte[]] $MagicPacket = (, 0xFF * 6) + ($macs * 16)

$udp = New-Object System.Net.Sockets.UdpClient
# https://learn.microsoft.com/en-us/dotnet/api/system.net.sockets.udpclient.client?view=net-9.0
$uSocket = $udp.Client
#  use the underlying socket to enable broadcast.
$uSocket.SetSocketOption([System.Net.Sockets.SocketOptionLevel]::Socket.value__,
  [System.Net.Sockets.SocketOptionName]::Broadcast.value__,
  $true)

$udp.Connect($ip, 7)
$null = $udp.Send($MagicPacket, $MagicPacket.Length)
$udp.Close()
