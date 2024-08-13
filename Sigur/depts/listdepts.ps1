#
# https://devblogs.microsoft.com/scripting/grabbing-excel-xlsx-values-with-powershell/
#
# Install-module PSExcel
#
$dir = Split-Path $PSCommandPath -Parent
$xlsx = Join-Path $dir 'структура.xlsx'
$data = Import-XLSX $xlsx

$cred = Get-StoredCredential -Target 'mysql:SKUD'

$sql = Open-MySqlConnection -Server srvskud-ekbh1 -Port 3305 -Database tc-db-main -Credential $cred

foreach ($row in $data) {
  $id = $row.Номер -replace '\D+', ''
  echo $id
}

Close-SqlConnection
