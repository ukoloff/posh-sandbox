#
# Построить связные компоненты подчинения менеджеров
#
Import-Module ActiveDirectory
$adBase = 'OU=uxm,OU=MS,DC=omzglobal,DC=com'

# List all managers exept the Top
$mgrFilter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(mail=*)(directReports=*)(Manager=*))"

$ms = Get-ADUser -SearchBase $adBase -LDAPFilter $mgrFilter
$ms | Out-GridView
