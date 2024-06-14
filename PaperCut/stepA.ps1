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

if ($all) {
  $data = readAllDays
}
else {
  $data = readDays($days)
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
