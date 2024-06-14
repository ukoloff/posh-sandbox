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
  [System.IO.File]::ReadAllLines($fname) | Where-Object { $_ | Select-String -Pattern $grep -Quiet }
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
$data = $data | Sort-Object

$months = $data | Group-Object -Property { $_.substring(0, 7) }
foreach ($m in $months) {
  $y, $mo = $m.Name -split '\D+'
  $d = Get-Date -Year $y -Month $mo -Day 1
  $fname = $dst + "\" + $d.ToString("yyyy-MM") + ".csv"
  $grep = "^" + $d.ToString("yyyy-MM") + '-\d{2}\s'
  $prev = [System.IO.File]::ReadAllLines($fname) | Where-Object { $_ | Select-String -Pattern $grep -Quiet }
  $prev = ($prev + $m.Group) | Sort-Object -Unique
  [System.IO.File]::WriteAllLines($fname, $prev)
}

$fname = $dst + "\all.csv"
[System.IO.File]::WriteAllLines($fname, $data)

