
$uDNs = @(
  'OU=ОГК,OU=Техническая дирекция,OU=Дирекция,OU=Users,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com',
  'OU=ОГТ,OU=Техническая дирекция,OU=Дирекция,OU=Users,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'
)

$cDN = 'OU=Computers,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'

$map = @{}

Get-ADComputer -SearchBase $cDN -SearchScope OneLevel -LDAPFilter '(managedBy=*)' -Properties managedBy | % {
  $map[$_.ManagedBy] = $_.Name
}

$users = @()

foreach ($dn in $uDNs) {
  $users += Get-ADUser -SearchBase $dn -LDAPFilter '(!userAccountControl:1.2.840.113556.1.4.803:=2)' -Properties displayName, canonicalName | % {
    [PSCustomObject]@{
      id   = $_.sAMAccountName;
      fio  = $_.Name;
      name = $_.displayName;
      dept = ($_.CanonicalName -split '/')[-2];
      host = $map[$_.DistinguishedName];
    }
  }
}

$users | Sort-Object id | Export-Excel
