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

# Тесты
@(
  'P.Vazhenin'
  's.ukolov'
  'a.bystrov'
  'A.Shantarin'
  'lobza'
  'gretskaya'
  'e.ermakova'
).ForEach({
    [array]$ms = getManagers($_)
    Write-Output "$($_):`t$($ms.ForEach({$_.SamAccountName}) -join ', ')"
  })
