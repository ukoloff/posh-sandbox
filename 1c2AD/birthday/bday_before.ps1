#
# Уведомления перед днём рождения
#
Import-Module ActiveDirectory
$adBase = 'OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'

$then = (Get-Date).AddDays(4).ToString("dd.MM")
$filter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(extensionAttribute1=$then.*)(mail=*))"
[array]$Users = Get-ADUser -SearchBase $adBase -LDAPFilter $filter -Properties manager
$Users

$u = 'P.Vazhenin'
$u = 's.ukolov'

function getManager($adUser) {
  $adUser = Get-ADUser $adUser -Properties Manager
  $manager = $adUser.Manager
  if ($manager) {
    return @($manager)
  }
  $mgrFilter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(mail=*)(directReports=*))"
  $dn = $adUser.DistinguishedName
  while (1) {
    $ou = 'OU=' + ($dn -split ',OU=', 2)[1]
    if (!$ou.EndsWith($adBase)) { break }
    [array]$list = Get-ADUser -SearchBase $ou -LDAPFilter $mgrFilter -SearchScope OneLevel
    if ($list) {
      [array]$managers = $list | ForEach-Object { $_.DistinguishedName }
      return $managers
    }
    $dn = $ou
  }
  return @()
}

function listManagers() {
  [array]$users = Get-ADUser -SearchBase $adBase -LDAPFilter "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(extensionAttribute1=*)(mail=*))"
  foreach ($u in $users) {
    $ms = getManager($u)
    if ($ms.count -eq 1) { continue }
    Write-Output "$($u.SamAccountName): $($ms.ForEach({ (Get-ADUser $_).SamAccountName }) -join ', ')"
  }
}

# getManager($u) | Out-GridView
listManagers
