$who = 'uxm00281'

Invoke-Command -ComputerName $who -ScriptBlock {
  Stop-Service IPSUpdater
  Remove-Item HKLM:\SOFTWARE\Intermech -Force -Recurse
}
