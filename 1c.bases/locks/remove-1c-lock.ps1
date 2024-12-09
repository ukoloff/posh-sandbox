
$d = Get-Date
$d = $d.AddMinutes(-1)

Get-ChildItem -LiteralPath $env:TEMP -Filter 1c_*.lock |
Where-Object { $_.LastAccessTime -le $d }
