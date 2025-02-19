#
# Patch OCS Client config
#

function timeStamp() {
  "[$(Get-Date -UFormat '%Y-%m-%d %T %Z')]`t"
}

function sysInfo {
  "$(timeStamp)Host:`t$($env:COMPUTERNAME)"
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

  "$(timeStamp)Patching:`t$ini"
  Set-Content -LiteralPath $ini -Value $textOCS -Force

  $svc = "OCS Inventory Service"
  "$(timeStamp)Restarting:`t$svc"
  Restart-Service -Name $svc -Force

  "$(timeStamp)That's all folks!"
}

patchOCS
