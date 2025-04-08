#
# Mirror repos to GitLab
#
Set-Location (Split-Path $PSCommandPath -Parent)
$root = git rev-parse --show-toplevel
$repos = Split-Path $root -Parent
$repos = Get-ChildItem -Path $repos -Directory
$repos
