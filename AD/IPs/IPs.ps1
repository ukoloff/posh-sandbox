#
# Get IP for Domain Computers
#
$OUs = @(
  'OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'
  'OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com'
)

$OUs |
ForEach-Object { Get-ADComputer -Filter * -SearchBase $_ } |
Out-GridView
