#
# How to run Powershell scripts?
#
$dir = Split-Path $PSCommandPath -Parent
$script = Join-Path $dir 7z-assoc.ps1

$c = Get-Content $script
$c | powershell -c -
