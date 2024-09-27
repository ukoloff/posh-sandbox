#
# Запускается на шлюзе
#
# srvrds-ekbh3.omzglobal.com
#

$log = 'Microsoft-Windows-TerminalServices-Gateway/Operational'

$L302 = Get-WinEvent -FilterHashTable @{LogName=$log;ID='302'}
$L303 = Get-WinEvent -FilterHashTable @{LogName=$log;ID='303'}

$e2 = $L302[0]
$e3 = $L303[0]

$x2 = ([xml]$e2.ToXml()).Event
$x3 = ([xml]$e3.ToXml()).Event

$x2.UserData.EventInfo
$x3.UserData.EventInfo
