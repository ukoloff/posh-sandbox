
$uDNs = @(
  'OU=ОГК,OU=Техническая дирекция,OU=Дирекция,OU=Users,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com',
  'OU=ОГТ,OU=Техническая дирекция,OU=Дирекция,OU=Users,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'
)

$cDN = 'OU=Computers,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'

$map = @{}

Get-ADComputer -SearchBase $cDN -SearchScope OneLevel -LDAPFilter '(managedBy=*)' -Properties managedBy | % {
  $map[$_.ManagedBy] = $_.Name
}

foreach ($dn in $uDNs) {
  Get-ADUser -SearchBase $dn -LDAPFilter '(!userAccountControl:1.2.840.113556.1.4.803:=2)' -Properties displayName| % {
    echo "$($_.sAMAccountName) $($_.Name) $($_.displayName) $($map[$_.DistinguishedName])"
  }
}
