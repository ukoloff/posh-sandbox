#
# Уведомления перед днём рождения
#
Import-Module ActiveDirectory
$adBase = 'OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'

$then = (Get-Date).AddDays(4).ToString("dd.MM")
$filter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(extensionAttribute1=$then.*)(mail=*))"
[array]$Users = Get-ADUser -SearchBase $adBase -LDAPFilter $filter -Properties mail, middleName
$Users
