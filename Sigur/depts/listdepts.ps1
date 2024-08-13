#
# https://devblogs.microsoft.com/scripting/grabbing-excel-xlsx-values-with-powershell/
#
# Install-module PSExcel
#
$dir = Split-Path $PSCommandPath -Parent
$xlsx = Join-Path $dir 'структура.xlsx'
$data = Import-XLSX $xlsx

$cred = Get-StoredCredential -Target 'mysql:SKUD'

Open-MySqlConnection -Server srvskud-ekbh1 -Port 3305 -Database tc-db-main -Credential $cred
$depts = Invoke-SqlQuery @"
  select
    ID,
    NAME,
    regexp_substr(NAME, '^[0-9]+') as kod
  from
    personal as Dpt
  where
    ` TYPE ` = 'DEP'
    and name rlike '^[0-9]+[[:space:]]'
    and STATUS = 'AVAILABLE'
"@
$deptIndex = @{}
foreach ($d in $depts) {
  $deptIndex[$d.kod] = $d.ID
}
$depts = @{}
foreach ($row in $data) {
  $id = $row.Номер -replace '\D+', ''
  if (!$deptIndex[$id]) { continue }
  $depts[$deptIndex[$id]] = 1
}
$deptIndex = 0
$depts = $depts.Keys | Sort-Object
Write-Output "($($depts -join ', '))"

Close-SqlConnection
