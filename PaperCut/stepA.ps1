param(
  [int]$days = 2,
  [switch]$all
)
$root = "\\omzglobal.com\uxm\Exchange\PrintStat\Logs"
$src = Join-Path $root Daily
$dst = Join-Path $root Aggregate

if (!(Test-Path $dst -PathType Container)) {
  mkdir $dst -Force | Out-Null
}

function readDay([datetime]$date = [datetime]::Now) {
  $fname = $src + "\PrintLog-" + $date.ToString("dd-MM-yyyy") + ".csv"
  $grep = "^" + $date.ToString("yyyy-MM-dd") + "\s"
  if (!(Test-Path $fname -PathType Leaf)) {
    return @()
  }
  [System.IO.File]::ReadAllLines($fname) | Select-String -Pattern $grep
}

function readDays($days) {
  $today = [datetime]::Now
  $lines = @()
  foreach ($i in 1..$days) {
    $lines += readDay($today.AddDays(1 - $i))
  }
  $lines
}

function readAllDays() {
  $lines = @()
  $csvs = Get-ChildItem $src -Filter 'PrintLog-*.csv'
  foreach ($f in $csvs) {
    if ($f -match "-(?<d>\d{2})-(?<m>\d{2})-(?<y>\d{4}).") {
      [datetime]$d = Get-Date -Day $Matches.d -Month $Matches.m -Year $Matches.y
      $lines += readDay($d)
    }
  }
  $lines
}

# $all = $true
if ($all) {
  $data = readAllDays
}
else {
  $data = readDays($days)
}
