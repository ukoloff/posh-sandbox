#
# Stop Expire! for service accounts
#
$OU = 'OU=ekb.ru,OU=Service,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'

Get-ADUser -SearchBase $OU -Filter * |
Out-GridView
