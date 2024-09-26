#
# Уведомления перед днём рождения
# Поиск кластера начальников
#
Import-Module ActiveDirectory
$adBase = 'OU=uxm,OU=MS,DC=omzglobal,DC=com'

$bday = (Get-Date).AddDays(3)
$then = $bday.ToString("dd.MM")
$filtEn = '(!userAccountControl:1.2.840.113556.1.4.803:=2)'
$filter = "(&$filtEn(extensionAttribute1=$then.*))"
[array]$Users = Get-ADUser -SearchBase $adBase -LDAPFilter $filter -Properties Manager
$Users

function getManagers($u) {
  $u = Get-ADUser $u -Properties Manager
  if ($u.Manager -and $u.Enabled) {
    $m = Get-ADUser $u.Manager -Properties Manager
    if ($m.Enabled -and $m.Manager) {
      return @($m)
    }
  }

  $mgrFilter = "(&$filtEn(directReports=*)(Manager=*))"
  $dn = $u.DistinguishedName
  while (1) {
    $ou = ($dn -split ',OU=', 2)[1]
    if (!$ou) {
      return @()
    }
    $ou = 'OU=' + $ou
    [array]$list = Get-ADUser -SearchBase $ou -LDAPFilter $mgrFilter -SearchScope OneLevel -Properties Manager
    if ($list) {
      return $list
    }
    $dn = $ou
  }
}

function escalate([object]$u) {
  $seen = @{}
  while (1) {
    $seen[$u.SamAccountName] = 1
    $m = Get-ADUser $u.Manager -Properties Manager
    if ($seen[$m.SamAccountName] -or !$m.Enabled -or !$m.Manager) {
      return $u
    }
    $u = $m
  }
}

function descend($managers) {
  # [OutputType([System.Collections.ArrayList])]
  $seen = @{}
  [System.Collections.ArrayList]$result = @()
  [System.Collections.ArrayList]$q = $managers.ForEach({ Get-ADUser $_ -Properties directReports, mail })
  while ($q.Count) {
    $u = $q[0]
    $q.RemoveAt(0)
    if ($seen[$u.SamAccountName]) { continue }
    $seen[$u.SamAccountName] = 1
    $null = $result.Add($u)
    $q.AddRange($u.
      directReports.
      ForEach({ Get-ADUser $_ -Properties directReports, mail }).
      Where({ $_.Enabled }))
  }
  , $result
}

function buildPeers($u) {
  [array]$ms = getManagers $u
  $ms = $ms.ForEach({ escalate $_ })
  $rcpt = descend $ms
  $id = (Get-ADUser $u).SamAccountName
  , $rcpt.Where({ $_.SamAccountName -ne $id })
}

function getMails($u) {
  $peers = buildPeers $u
  ,$peers.ForEach({ $_.mail })
}

$Users.ForEach({
  $pz = getMails $_
  Write-Output "$($_.SamAccountName):`t$($pz -join ', ')"
})

# Тесты
<#
@(
  'P.Vazhenin'
  's.ukolov'
  'a.bystrov'
  'A.Shantarin'
  'lobza'
  'gretskaya'
  'e.ermakova'
  ).ForEach({
    $pz = getMails $_
    Write-Output "$($_):`t$($pz -join ', ')"
  })
#>
