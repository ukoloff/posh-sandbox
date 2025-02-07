$hosts = Get-Content (Join-Path (Split-Path $PSCommandPath -Parent) hosts.txt)

foreach ($who in $hosts) {

  if (!(Test-Connection $who -Quiet -Count 1)) {
    "Cannot connect to: $who"
    continue
  }
  Invoke-Command -ComputerName $who -ScriptBlock {
    Stop-Service IPSUpdater
    Remove-Item HKLM:\SOFTWARE\Intermech -Force -Recurse
    Remove-Item C:\IPS -Force -Recurse
    Remove-Item "C:\IPS Vault" -Force -Recurse
  }
}
