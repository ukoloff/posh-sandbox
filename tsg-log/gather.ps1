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
