#
# Patch Zabbix Agent2 config to replace IP with DNS
#
$Logs = '\\service\Soft\Scripts\Logs\Zabbix2'

function timeStamp() {
  "[$(Get-Date -UFormat '%Y-%m-%d %T %Z')]`t"
}

function sysInfo {
  "$(timeStamp)Host:`t$($env:COMPUTERNAME)"
  "$(timeStamp)IP:`t$(-join ((Get-NetIPAddress -AddressFamily IPv4).IPAddress | ? { $_ -match "^10[.]|^192[.]168[.]"}))"
  @"
$(timeStamp)Users:`t$((
    Get-Process -IncludeUserName |
    Select-Object -ExpandProperty UserName -Unique |
    Where-Object {$_ -notmatch ' '} |
    Sort-Object) -join ' ')
"@
}

function patchZabbix2 {
  sysInfo
}

patchZabbix2
