#
# Update Sigur persons
#

$Server = 'srvskud-ekbh1-d'
$src = "\\omzglobal.com\uxm\Exchange\employee_changes.csv"

$cred = Get-StoredCredential -Target 'mysql:SKUD'

Open-MySqlConnection -Server $Server -Port 3305 -Database  tc-db-main -Credential $cred

$Users = Import-Csv  $src -Delimiter ";" -Encoding UTF8

function findField($name) {
  $id = Invoke-SqlScalar @"
    select
      PARAM_IDX
    from
      sideparamtypes
    where
      TABLE_ID = 0
      and NAME = @name
      and `TYPE` = 'STRING'
      and READONLY
"@ -Parameters @{name = $name }
  if ($id) { return $id }
  Write-Error "Parameter<string,readonly> not found: $name"
  exit
}

$idDept = findField 'Отдел'
$idDeptNo = findField '№ Отдела'

function getUsers($user, $adAttr, $dbAttr) {
  Invoke-SqlQuery @"
    Select ID
    From personal
    Where
      $dbAttr = @$adAttr
      And
      EXTID is NULL
    Limit 2
"@ -ParamObject $user -WarningAction Ignore
}

function syncUser($user, $id) {
}

$Found = 0
$NotFound = 0
foreach ($user in $Users) {
  foreach ($p in $user.PSObject.Properties) {
    $p.Value = $p.Value.Trim()
  }
  if ($user.company -ne 'УЗХМ') { continue }
  [array]$x = getUsers $user displayName NAME
  $n = $x.Count
  if ($n -eq 1) {
    $Found++
    syncUser $user $x[0].ID
    continue
  }
  [array]$x = getUsers $user employeeID TABID
  $t = $x.Count
  if ($t -eq 1) {
    $Found++
    syncUser $user $x[0].ID
    continue
  }
  $NotFound++
  Write-Output "$n`t$t`t$($user.employeeID)`t$($user.displayName)"
}
Write-Output "Found: $Found"
Write-Output "Not found: $NotFound"
