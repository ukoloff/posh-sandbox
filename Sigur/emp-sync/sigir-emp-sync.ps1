#
# Update Sigur persons
#

$Server = 'srvskud-ekbh1-d'
$src = "\\omzglobal.com\uxm\Exchange\employee_changes.csv"

$cred = Get-StoredCredential -Target 'mysql:SKUD'

Open-MySqlConnection -Server $Server -Port 3305 -Database  tc-db-main -Credential $cred

$Users = Import-Csv  $src -Delimiter ";" -Encoding UTF8

$Found = 0
foreach ($user in $Users) {
  $n = Invoke-SqlScalar @"
    Select Count(*)
    From personal
    Where
      NAME = @name
      And
      EXTID is NULL
"@ -Parameters @{name = $user.displayName.Trim() }
  if ($n -eq 1) {
    $Found++
    continue
  }
  Write-Output "$($user.displayName)`t$($user.employeeID)`t$n"
}
Write-Output "Found: $Found"
