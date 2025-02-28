#
# Get IP for Domain Computers
#
[System.Collections.Generic.HashSet[string]]$IPs = @(
  'OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'
  'OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com'
) |
ForEach-Object { Get-ADComputer -Filter * -SearchBase $_ } |
Select-Object -ExpandProperty DNSHostName |
Where-Object { $_ } |
ForEach-Object { Resolve-DNSName $_ -Type A -ErrorAction SilentlyContinue } |
Select-Object -ExpandProperty IPAddress

function ptrReq($IP) {
  try {
    (Resolve-DnsName $IP -Type PTR -ErrorAction SilentlyContinue).NameHost -join ' '
  }
  catch {
    $null
  }
}

$ARP = Invoke-WebRequest https://nc.ekb.ru/omz/service/arp/
(ConvertFrom-Json $ARP.Content).ip |
Where-Object { !$IPs.Contains($_) } |
Sort-Object |
ForEach-Object { [PSCustomObject]@{
    ip   = $_
    host = ptrReq $_
  } } |
Export-Excel
