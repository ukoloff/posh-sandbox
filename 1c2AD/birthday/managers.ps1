#
# Построить связные компоненты подчинения менеджеров
#
Import-Module ActiveDirectory
$adBase = 'OU=uxm,OU=MS,DC=omzglobal,DC=com'

# List all managers exept the Top
$mgrFilter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(mail=*)(directReports=*)(Manager=*))"

$ms = Get-ADUser -SearchBase $adBase -LDAPFilter $mgrFilter -Properties Manager

$idx = @{}
$ms.ForEach({
    $idx[$_.DistinguishedName] = $_
    $_ | Add-Member -Force -NotePropertyName xch -NotePropertyValue @()
  })

$root = [object]@{xch = @() }

$ms.ForEach({
    $up = $root
    if ($_.DistinguishedName -ne $_.Manager) {
      $up = $idx[$_.Manager]
      if (!$up) { $up = $root }
    }
    $up.xch += @($_)
  })

echo $root.xch
