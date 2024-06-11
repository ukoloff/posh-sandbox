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

readDay((Get-Date).AddDays(-1))
