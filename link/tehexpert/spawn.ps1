#
# How to run Powershell scripts?
#
$dir = Split-Path $PSCommandPath -Parent
$script = Join-Path $dir texexpert-lnk.ps1

$c = Get-Content $script
$c | powershell -c -
