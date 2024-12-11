#
# Update Sigur persons
#

$Server = 'srvskud-ekbh1-d'
$src = "\\omzglobal.com\uxm\Exchange\employee_changes.csv"

$cred = Get-StoredCredential -Target 'mysql:SKUD'

Open-MySqlConnection -Server $Server -Port 3305 -Database  tc-db-main -Credential $cred

$Users = Import-Csv  $src -Delimiter ";" -Encoding UTF8

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
    continue
  }
  [array]$x = getUsers $user employeeID TABID
  $t = $x.Count
  if ($t -eq 1) {
    $Found++
    continue
  }
  $NotFound++
  Write-Output "$n`t$t`t$($user.employeeID)`t$($user.displayName)"
}
Write-Output "Found: $Found"
Write-Output "Not found: $NotFound"
