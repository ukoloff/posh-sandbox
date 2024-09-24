#
# Уведомления перед днём рождения
#
Import-Module ActiveDirectory
$adBase = 'OU=uxm,OU=MS,DC=omzglobal,DC=com'

$then = (Get-Date).AddDays(4).ToString("dd.MM")
$filter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(extensionAttribute1=$then.*)(mail=*))"
[array]$Users = Get-ADUser -SearchBase $adBase -LDAPFilter $filter -Properties manager
# $Users

class Send2 {
  [Microsoft.ActiveDirectory.Management.ADUser] $u
  [object[]] $managers

  Send2($user) {
    $this.u = Get-ADUser $user -Properties Manager
    $this.managers = $this.getManagers()
  }

  [object[]] getManagers() {
    if ($this.u.Manager) {
      return @(Get-ADUser $this.u.Manager)
    }
    $mgrFilter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(mail=*)(directReports=*))"
    $dn = $this.u.DistinguishedName
    while (1) {
      $ou = 'OU=' + ($dn -split ',OU=', 2)[1]
      if (!$ou.EndsWith($global:adBase)) { break }
      [array]$list = Get-ADUser -SearchBase $ou -LDAPFilter $mgrFilter -SearchScope OneLevel
      if ($list) {
        return $list
      }
      $dn = $ou
    }
    return @()
  }
}

function listManagers() {
  [array]$users = Get-ADUser -SearchBase $adBase -LDAPFilter "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(extensionAttribute1=*)(mail=*))"
  foreach ($u in $users) {
    $ms = [Send2]::new($u).managers
    if ($ms.count -eq 1) { continue }
    Write-Output "$($u.SamAccountName): $($ms.ForEach({ (Get-ADUser $_).SamAccountName }) -join ', ')"
  }
}

# listManagers

$u = 'P.Vazhenin'
# $u = 's.ukolov'
# $u = 'lobza'
# $u = 'gretskaya'

$z = [Send2]::new($u)
$z.managers | Out-GridView
