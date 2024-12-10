#
# Найти руководителей во всех подразделениях
#
Import-Module ActiveDirectory
$adBase = 'OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'

$mgrFilter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(mail=*)(directReports=*))"

[array]$OUs = Get-ADOrganizationalUnit -SearchBase $adBase -LDAPFilter '(name=*)'
foreach($ou in $OUs) {
  [array]$list = Get-ADUser -SearchBase $ou.DistinguishedName -LDAPFilter $mgrFilter -SearchScope OneLevel
  if ($list) {
    Write-Output $ou.DistinguishedName
    Write-Output ($list.ForEach({' + ' + $_.SamAccountName}) -join "`n")

  }
}
