#
# Patch Zabbix Agent2 config to replace IP with DNS
#
$Logs = '\\service\Soft\Scripts\Logs\Zabbix2'

$ini = 'C:\Program Files\Zabbix Agent 2\zabbix_agent2.conf'

function timeStamp() {
  "[$(Get-Date -UFormat '%Y-%m-%d %T %Z')]`t"
}

function sysInfo {
  "$(timeStamp)Host:`t$($env:COMPUTERNAME)"
  "$(timeStamp)IP:`t$(((Get-NetIPAddress -AddressFamily IPv4).IPAddress | ? { $_ -match "^10[.]|^192[.]168[.]"}) -join ' ')"
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

  if (!(Test-Path $ini -PathType Leaf)) {
    "$(timeStamp)Quit:`tZabbix Agent2 not found!"
    return
  }

  $txtIP = Get-Content -Raw $ini
  $txt2 = $txtIP.Replace('10.33.10.120', 'zbx.ekb.ru')
  if ($txtIP -eq $txt2) {
    "$(timeStamp)Quit:`tNothing to patch..."
    return
  }

  "$(timeStamp)Patching:`t$ini"
  Set-Content -LiteralPath $ini -Value $txt2 -Force

  "$(timeStamp)Restarting service..."
  Restart-Service "Zabbix Agent 2"

  "$(timeStamp)That's all folks!"
}

$null = New-Item $Logs -Force -ItemType Directory
$Logs = Join-Path $Logs "$($env:COMPUTERNAME).log"

patchZabbix2 >>$Logs 2>&1
