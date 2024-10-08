#
# Построить связные компоненты подчинения менеджеров
#
Import-Module ActiveDirectory
$adBase = 'OU=uxm,OU=MS,DC=omzglobal,DC=com'

# List all managers except the Top
$mgrFilter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(directReports=*)(Manager=*))"

$ms = Get-ADUser -SearchBase $adBase -LDAPFilter $mgrFilter -Properties Manager, CanonicalName, directReports, mail |
Sort-Object Name

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

function Tree($u = $root, $indent = 0) {
  foreach ($z in $u.xch) {
    Write-Output "$("`t" * $indent)$($z.SamAccountName)[$($z.directReports.count)]`t$($z.CanonicalName)`t<$($z.mail)>"
    if (!$z.xch.count) { continue }
    Tree $z ($indent + 1)
  }
}

Tree
