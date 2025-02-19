#
# Patch OCS Client config
#
$Logs = '\\service\Soft\Scripts\Logs'

$Log = Join-Path $Logs "$($env:COMPUTERNAME).log"

function timeStamp() {
  "[$(Get-Date -UFormat '%Y-%m-%d %T %Z')]`t"
}

function sysInfo {
  "$(timeStamp)Host:`t$($env:COMPUTERNAME)"
  "$(timeStamp)IP:`t$(-join ((Get-NetIPAddress -AddressFamily IPv4).IPAddress | ? { $_ -match "^10[.]"}))"
  @"
$(timeStamp)Users:`t$((
    Get-Process -IncludeUserName |
    Select-Object -ExpandProperty UserName -Unique |
    Where-Object {$_ -notmatch ' '} |
    Sort-Object) -join ' ')
"@
}

function patchOCS {
  sysInfo

  $ini = "$($env:ProgramData)\OCS Inventory NG\Agent\ocsinventory.ini"
  if (!(Test-Path $ini -PathType Leaf)) {
    "$(timeStamp)Quit:`tOCS client not found!"
    return
  }

  $txtIP = Get-Content -Raw $ini
  $txtOCS = $txtIP.Replace('10.33.10.72', 'ocs.ekb.ru')
  if ($txtIP -eq $txtOCS) {
    "$(timeStamp)Quit:`tNothing to patch..."
    return
  }

  $svc = "OCS Inventory Service"
  "$(timeStamp)Stopping:`t$svc"
  Stop-Service -Name $svc -Force

  "$(timeStamp)Patching:`t$ini"
  Set-Content -LiteralPath $ini -Value $txtOCS -Force

  "$(timeStamp)Starting:`t$svc"
  Start-Service -Name $svc

  "$(timeStamp)That's all folks!"
}

patchOCS >>$Log 2>&1
