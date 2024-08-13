$src = "\\omzglobal.com\uxm\Exchange\PrintStat\Logs\Daily"

$csvs = Get-ChildItem $src -Filter 'PrintLog-*.csv'
Write-Output "Files: $($csvs.Count)"
$start = Get-Date
$lines = @()
foreach ($z in $csvs) {
  $lines += [System.IO.File]::ReadAllLines($z.FullName)
}
$stop = Get-Date
Write-Output "Lines: $($lines.Count)"
Write-Output "Time: $(($stop-$start).TotalSeconds)"
