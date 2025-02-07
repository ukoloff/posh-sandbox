param([switch]$Elevated)
$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
if (!$currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))  {
  if (!$elevated) {
    Start-Process `
            powershell.exe `
            -Verb RunAs `
            -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ( $myinvocation.MyCommand.Definition ))
  }
  exit
}
Enable-NetFirewallRule -Group "@FirewallAPI.dll,-28502"
Add-VpnConnection `
    -Force `
    -Name "Ideco NGFW IKEv2 VPN to utm.ekb.ru" `
    -TunnelType IKEv2 `
    -ServerAddress utm.ekb.ru `
     -AuthenticationMethod EAP -DnsSuffix "omzglobal.com"  `
    -EncryptionLevel "Required" `
    -SplitTunneling $False `
    -RememberCredential
