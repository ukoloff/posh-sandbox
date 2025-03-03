#
# Stop Expire! for service accounts
#
$OU = 'OU=ekb.ru,OU=Service,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'

Get-ADUser -SearchBase $OU -Filter * |
Set-ADUser -Replace @{pwdLastSet = 0 } -PassThru |
Set-ADUser -Replace @{pwdLastSet = -1 } -PassThru |
Get-ADUser -Properties pwdLastSet, PasswordLastSet
