#
# Самописная синхронизация операторов из AD в Сигур
# Для целей авторизации (SSO)
#
$Server = 'srvskud-ekbh1-d'

function extractDomain($DN) {
  $dc = [regex]::Match($DN, '(,dc=\w+)*$',
    [System.Text.RegularExpressions.RegexOptions]::IgnoreCase).Value -replace ',dc=', '.'
  $dc = $dc -replace '^[.]+', ''
  $dc
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

$folderCache = @{}

function findFolder($name) {
  if (!$name) {
    $name = '!domain.ad'
  }
  if ($folderCache[$name]) {
    return $folderCache[$name]
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
    $folderCache[$name] = $q
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
  $folderCache[$name] = $q
  return $q
}

function listOperators {
  $q = Invoke-SqlQuery @"
    select
      ID as id,
      EXTID as guid,
      USER_ENABLED as oper,
      USER_T_SSPILOGIN as ad
    from
      personal
    where
      EXTID is not null
      and type = 'EMP'
"@
  foreach ($z in $q) {
    $ad = ([ADSISearcher]"(&(objectCategory=User)(objectGUID=$($z.guid -replace "(.{2})", '\$1')))").FindOne()
    if ($ad) {
      $domain = extractDomain $ad.Path
    }
    else {
      $domain = guessDomain $z.id
    }
    $folder = findFolder $domain
  }
}

$cred = Get-StoredCredential -Target 'mysql:SKUD'
Open-MySqlConnection -Server $Server -Port 3305 -Database  tc-db-main -Credential $cred

listOperators

Close-SqlConnection

