#
# Самописная синхронизация операторов из AD в Сигур
# Для целей авторизации (SSO)
#
$Server = 'srvskud-ekbh1-d'

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
    $ad.Path
  }
}

$cred = Get-StoredCredential -Target 'mysql:SKUD'
Open-MySqlConnection -Server $Server -Port 3305 -Database  tc-db-main -Credential $cred

listOperators

Close-SqlConnection

