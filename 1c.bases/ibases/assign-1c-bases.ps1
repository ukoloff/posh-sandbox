#
# Назначение баз 1С пользователю
#
$Groups = 'OU=1CBase,OU=Service,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'
$stopGroup = 'UZHM-1C не переписывать базы'
$null = $stopGroup  # ^ Не используется

$ini = "$($env:APPDATA)\1C\1CEStart\ibases.v8i"

# Получаем список групп 1С
function groups1C {
  $s = [ADSISearcher]"(objectClass=group)"
  $s.SearchRoot = [ADSI]"LDAP://$Groups"
  $null = $s.PropertiesToLoad.Add('info')
  $null = $s.PropertiesToLoad.Add('sAMAccountName')

  foreach ($g in $s.FindAll()) {
    $g = $g.Properties
    $info = $g.info
    if (!$info) { continue }
    $info = $info[0] -split "\r?\n|\r"
    $m = [regex]::Match($info[0], '^\s*\[(.*)\]\s*$')
    if (!$m.Success) { continue }
    [PSCustomObject]@{
      g     = $g.samaccountname[0]
      title = $m.Groups[1].Value.Trim()
      info  = $info | Select-Object -Skip 1
    }
  }
}

# Получаем список всех групп текущего пользователя
function myGroups {
  # https://www.secuinfra.com/en/techtalk/adsisearcher-resolve-groups-recursively/
  $me = [ADSISearcher]"(&(objectClass=user)(sAMAccountName=$($env:USERNAME)))"
  $me = $me.FindOne().Properties.distinguishedname
  $s = [ADSISearcher]"(&(objectClass=group)(member:1.2.840.113556.1.4.1941:=$me))"
  $null = $s.PropertiesToLoad.Add('sAMAccountName')
  $s.FindAll()
}

function myBases {
  $idx = @{}
  foreach ($g in $groups1C) {
    $idx[$g.g] = $g
  }
  myGroups |
  ForEach-Object {
    $g = $_.Properties.samaccountname[0]
    $g = $idx[$g]
    if ($g) { $g }
  } |
  Sort-Object title |
  ForEach-Object {
    @(
      ""
      "[$($_.title)]"
    ) + $_.info
  }
}

[array]$groups1C = groups1C
[array]$bases = myBases
$bases
