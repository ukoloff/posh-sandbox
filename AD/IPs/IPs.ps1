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
ForEach-Object { Resolve-DNSName $_ -Type A } |
Select-Object -ExpandProperty IPAddress

$IPs
