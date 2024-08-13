#
# https://devblogs.microsoft.com/scripting/grabbing-excel-xlsx-values-with-powershell/
#
# Install-module PSExcel
#
$dir = Split-Path $PSCommandPath -Parent
$xlsx = Join-Path $dir 'структура.xlsx'
$data = Import-XLSX $xlsx
