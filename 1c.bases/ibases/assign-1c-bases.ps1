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

# Список баз 1С, которые нужно подключить текущему пользователю
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

function iniPresent {
  Test-Path $ini -PathType Leaf
}

function backupBases {
  if (!(iniPresent)) { return }
  $dir = Join-Path (Split-Path $ini -Parent) backup
  $hash = Get-FileHash $ini -Algorithm SHA512
  $null = New-Item $dir -Force -ItemType Directory
  foreach ($f in (Get-ChildItem $dir -File)) {
    $h2 = Get-FileHash ($f.FullName) -Algorithm SHA512
    if ($h2.Hash -eq $hash.Hash) {
      return
    }
  }
  $bak = Join-Path $dir "$(Split-Path $ini -Leaf).$(Get-Date -UFormat '%Y-%m-%d_%H-%M-%S').bak"
  Copy-Item $ini $bak -Force
}

# Получить список баз, прописанных вручную
function getManualConfig {
  if (!(iniPresent)) {
    return @()
  }
  $auto = @{}
  $groups1C | ForEach-Object {
    $auto[$_.title] = 1
  }
  $out = $true
  [System.IO.File]::ReadAllLines($ini) |
  Where-Object {
    $m = [regex]::Match($_, '^\s*\[(.*)\]\s*$')
    if ($m.Success) {
      $out = !$auto[$m.Groups[1].Value]
    }
    $out
  }
}

[array]$groups1C = groups1C

if (($groups1C.Count -eq 0) -and !(iniPresent)) {
  "Настройка баз 1С не требуется"
  exit
}

backupBases
[array]$bases = myBases
[array]$old = getManualConfig
while ($old.Count -and $old[-1].Trim() -eq '') {
  $old = $old | Select-Object -SkipLast 1
}
$old + $space + $bases |
Out-File $ini -Encoding utf8 -Force

"That's all folks!"
