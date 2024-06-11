$src = "\\omzglobal.com\uxm\Exchange\PrintStat\Logs\Daily"

function readDay($date = [datetime]::Now) {
  $fname = $src + "\PrintLog-" + $date.ToString("dd-MM-yyyy") + ".csv"
  $grep = "^" + $date.ToString("yyyy-MM-dd") + "\s"
  if (!(Test-Path $fname -PathType Leaf)) {
    return @()
  }
  [System.IO.File]::ReadAllLines($fname) | Select-String -Pattern $grep
}

readDay((Get-Date).AddDays(-1))
