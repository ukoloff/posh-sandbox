#
# Настройка VPN @Уралхиммаш
#
param([switch]$elevated)

function isAdmin {
  $user = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if (!(isAdmin)) {
  if (!$elevated) {
    # Run elevated
    $self = @('-noprofile', '-noexit', '-file', $PSCommandPath, '-elevated')
    Start-Process powershell -Verb RunAs -ArgumentList $self
  }
  exit
}

$crt = @"
-----BEGIN CERTIFICATE-----
MIIBvDCCAWKgAwIBAgIUJYGeuYqtuYrRYCji+q0kgdwYmdwwCgYIKoZIzj0EAwIw
LTEXMBUGA1UEBRMOMjAyMzAzMjQxNDEwMTQxEjAQBgNVBAMMCUlkZWNvIFVUTTAe
Fw0yMzAzMjMxNDEwMTRaFw0zMzAzMjExNDEwMTRaMC0xFzAVBgNVBAUTDjIwMjMw
MzI0MTQxMDE0MRIwEAYDVQQDDAlJZGVjbyBVVE0wWTATBgcqhkjOPQIBBggqhkjO
PQMBBwNCAAQM8105PHGsEsdFG2RIiB84QfP5XuE688sznhKAmSrGsn99IAJBIy+N
Xf9k/iex7RtAtTX1L2ZjdN5A7nm7IuCno2AwXjAdBgNVHQ4EFgQUFHd0hAps4nit
YSJObt3lTJLsQYcwDwYDVR0TAQH/BAUwAwEB/zALBgNVHQ8EBAMCAYYwHwYDVR0j
BBgwFoAUFHd0hAps4nitYSJObt3lTJLsQYcwCgYIKoZIzj0EAwIDSAAwRQIgbWDB
808Jx5amkrL6iDVgpsn6wQlW3UmdBlGC/w3fTIoCIQCvw883p118hGDBrM/yiMvI
QWQ2VGVVIXdglwQT7ynYKg==
-----END CERTIFICATE-----
"@.Trim()

$t = New-TemporaryFile
Set-Content $t $crt
Import-Certificate -FilePath $t.FullName -CertStoreLocation Cert:\LocalMachine\Root
Remove-Item $t

$vpn = @{
  Name                 = "uxm"
  ServerAddress        = "utm.ekb.ru"
  DnsSuffix            = "omzglobal.com"
  TunnelType           = "IKEv2"
  EncryptionLevel      = "Required"
  AuthenticationMethod = "EAP"
  Force                = $true
  SplitTunneling       = $true
  RememberCredential   = $true
  # AllUserConnection    = $true
  PassThru             = $true
}

Add-VpnConnection @vpn
