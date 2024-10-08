﻿#
# Уведомления перед днём рождения
#
Import-Module ActiveDirectory
$adBase = 'OU=uxm,OU=MS,DC=omzglobal,DC=com'

$bday = (Get-Date).AddDays(3)
$then = $bday.ToString("dd.MM")
$filter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(extensionAttribute1=$then.*))"
[array]$Users = Get-ADUser -SearchBase $adBase -LDAPFilter $filter -Properties Manager
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
      return @(Get-ADUser $this.u.Manager -Properties Manager)
    }
    $mgrFilter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(mail=*)(directReports=*))"
    $dn = $this.u.DistinguishedName
    while (1) {
      $ou = 'OU=' + ($dn -split ',OU=', 2)[1]
      if (!$ou.EndsWith($global:adBase)) { break }
      [array]$list = Get-ADUser -SearchBase $ou -LDAPFilter $mgrFilter -SearchScope OneLevel -Properties Manager
      if ($list) {
        return $list
      }
      $dn = $ou
    }
    return @()
  }

  [object[]] topManagers() {
    $seen = @{}
    $result = @()
    foreach ($m in $this.managers) {
      if ($seen[$m.SamAccountName]) { continue }
      $seen[$m.SamAccountName] = 1
      while ($m.Manager) {
        $m = Get-ADUser $m.Manager -Properties Manager, mail
        if (!$m.Enabled -or !$m.mail -or !$m.Manager -or $seen[$m.SamAccountName]) { break }
        $seen[$m.SamAccountName] = 1
        $result += @($m)
      }
    }
    return $result
  }

  [object[]] getBcc() {
    $seen = @{}
    $result = @()
    $seen[$this.u.SamAccountName] = 1
    $mgrs = $this.managers + $this.topManagers()
    foreach ($m in $mgrs) {
      if ($seen[$m.SamAccountName]) { continue }
      $seen[$m.SamAccountName] = 1
      $result += $m
      $slaves = (Get-ADUser $m -Properties directReports).directReports
      if (!$slaves) { continue }
      foreach ($udn in $slaves) {
        $slave = Get-ADUser $udn -Properties mail
        if (!$slave.Enabled -or !$slave.mail -or $seen[$slave.SamAccountName]) { continue }
        $seen[$slave.SamAccountName] = 1
        $result += $slave
      }
    }
    return $result
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
$z.getBcc() | Out-GridView
