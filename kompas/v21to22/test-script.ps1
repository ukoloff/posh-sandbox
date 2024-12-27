#
# Test script
#
$logs = '\\omzglobal.com\uxm\Distribute\kompas\KOMPAS-3D_v22_x64\Logs\test'

$Log = Join-Path $logs "$($env:COMPUTERNAME).log"

"Running $(Get-Date -UFormat '%Y-%m-%d %T %Z')" >> $Log
