
$d = Get-Date
$d = $d.AddMinutes(-1)

Get-ChildItem -LiteralPath $env:TEMP -Filter 1c_*.lock |
Where-Object { $_.CreationTime -le $d } |
Remove-Item
