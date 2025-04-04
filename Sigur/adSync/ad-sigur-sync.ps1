#
# Самописная синхронизация операторов из AD в Сигур
# Для целей авторизации (SSO)
#
$Server = 'srvskud-ekbh1-d'
$group = "operators@$Server"  # Автоматическое назначение операторами

function splitDN($DN) {
  $m = [regex]::Match($DN, '(,dc=\w+)*$',
    [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
  @(
    $DN.Substring(0, $m.Index)
    $m.Value -replace ',dc=', '.' -replace '^[.]+', ''
  )
}

function dbNull($value) {
  if ($value -is [System.DBNull]) {
    return $null
  }
  return $value
}

function guessDomain($uid) {
  $q = Invoke-SqlScalar @"
    select
      DOMAIN_NAME
    from
      personal p
      join addomains d on p.AD_DOMAIN_ID = d.ID
    where
      p.id = @id
"@ -Parameters @{id = $uid }
  dbNull $q
}

function base64($s) {
  # https://gist.github.com/iAnatoly/254220f98f2627c484ab32b76c813756
  [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($s))
}

$folderCache = @{}

function findFolder($name) {
  if (!$name) {
    $name = '!domain.ad'
  }
  $nm = base64 $name
  if ($folderCache[$nm]) {
    return $folderCache[$nm]
  }
  $q = Invoke-SqlScalar @"
    select
      ID
    from
      personal p
    where
      name = @name
      and `TYPE` = 'DEP'
      and STATUS = 'AVAILABLE'
      and not exists(select * from personal q where q.ID = p.PARENT_ID )
    order by
      CREATEDTIME
    limit 1
"@ -Parameters @{name = $name }
  $q = dbNull $q
  if ($q) {
    # Found
    $folderCache[$nm] = $q
    return $q
  }
  # Create new
  $q = Invoke-SqlScalar @"
    insert into
          personal(NAME, TYPE, DESCRIPTION)
          values (@name, @type, @desq);
    -- returning id
    select
      LAST_INSERT_ID()
"@ -Parameters @{
    name = $name
    type = 'DEP'
    desq = "Автоматически созданное подразделение для пользователей,`nавторизующихся в домене $name"
  }
  $q = dbNull $q
  $folderCache[$nm] = $q
  return $q
}

function findSubFolder($name, $sub) {
  $nm = "$(base64 $name)/$(base64 $sub)"
  if ($folderCache[$nm]) {
    return $folderCache[$nm]
  }
  $parent = findFolder $name
  $q = Invoke-SqlScalar @"
    select
      ID
    from
      personal p
    where
      name = @name
      and PARENT_ID = @pid
      and `TYPE` = 'DEP'
      and STATUS = 'AVAILABLE'
    order by
      CREATEDTIME
    limit 1
"@ -Parameters @{name = $sub; pid = $parent }
  $q = dbNull $q
  if ($q) {
    # Found
    $folderCache[$nm] = $q
    return $q
  }
  # Create new
  $desq = switch ($sub) {
    '-' { "Пользователи Sigur,`nне найденные в домене $domain" }
    '#' { "Пользователи домена $domain,`nзаблокированные в Sigur" }
    '!' { "Пользователи Sigur,`nзаблокированные в домене $domain" }
    Default { "Какие-то пользователи из домена $domain" }
  }
  $q = Invoke-SqlScalar @"
    insert into
          personal(NAME, PARENT_ID, TYPE, DESCRIPTION)
          values (@name, @pid, @type, @desq);
    -- returning id
    select
      LAST_INSERT_ID()
"@ -Parameters @{
    name = $sub
    pid  = $parent
    type = 'DEP'
    desq = $desq
  }
  $q = dbNull $q
  $folderCache[$nm] = $q
  return $q
}

function get($attr) {
  if ($attr -ne $null) {
    return $attr[0]
  }
  $null
}

function listOperators {
  $q = Invoke-SqlQuery @"
    select
      ID as id,
      PARENT_ID as pid,
      NAME as name,
      EXTID as guid,
      USER_ENABLED and USER_T_SSPILOGIN as enabled
    from
      personal
    where
      EXTID is not null
      and type = 'EMP'
    order by NAME
"@
  foreach ($z in $q) {
    $ad = ([ADSISearcher]"(&(objectCategory=User)(objectGUID=$($z.guid -replace "(.{2})", '\$1')))").FindOne()
    if ($ad) {
      $ad = $ad.Properties
      $DN, $domain = splitDN $ad.distinguishedname[0]
      $subfolder = $null
      if (!$z.enabled) {
        $subfolder = '#'
      }
      elseif ($ad.useraccountcontrol[0] -band 2) {
        $subfolder = '!'
      }
    }
    else {
      $domain = guessDomain $z.id
      $subfolder = '-'
    }
    if ($subfolder) {
      $folder = findSubFolder $domain $subfolder
    }
    else {
      $folder = findFolder $domain
    }
    if ($z.pid -ne $folder) {
      # Move to (sub)folder
      "$subfolder`t$($z.name)"

      $null = Invoke-SqlUpdate @"
      Update
        personal
      Set
        PARENT_ID = @pid
      Where
        ID = @id
"@  -Parameters @{id = $z.id; pid = $folder }
    }
    if ($subfolder) { continue }
    $null = Invoke-SqlUpdate @"
      Update personal
      Set
        NAME = @name,
        DESCRIPTION = @desq,
        POS = NULL,
        TABID = @tabNo,
        -- AD_DOMAIN_ID
        AD_USER_DN = @dn,
        USER_LOGIN = @login,
        USER_PASSWORD = '-'
      Where
        ID = @id
"@ -Parameters @{
      id    = $z.id
      name  = $ad.samaccountname[0]
      tabNo = get($ad.employeeid)
      dn    = $DN
      login = $ad.cn[0]
      desq  = @"
Пользователь AD
---------------
domain:`t$domain
user:`t$($ad.samaccountname[0])
cn:`t$($ad.cn[0])
name:`t$($ad.displayname[0])
title:`t$(get($ad.title))
"@
    }
  }
}

function addOperators {
  $g = Get-ADGroup $group
  if (!$g) {
    Write-Warning "Группа не найдена: $g"
    exit
  }
  Get-ADGroupMember -Recursive $g |
  ForEach-Object {
    if ($_.objectClass -ne 'user') { continue }
    $user = $_ | Get-ADUser
    if (!$user.Enabled) { continue }
    "$(-join $_.ObjectGUID.ToByteArray().foreach({$_.toString('x2')})) $($user.SamAccountName)"
  }
  exit
}

$cred = Get-StoredCredential -Target 'mysql:SKUD'
Open-MySqlConnection -Server $Server -Port 3305 -Database  tc-db-main -Credential $cred
Start-SqlTransaction

addOperators
listOperators

Complete-SqlTransaction
Close-SqlConnection
