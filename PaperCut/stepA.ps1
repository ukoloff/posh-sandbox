param(
  [int]$days = 2,
  [switch]$all,
  [switch]$debug
)

$root = "\\omzglobal.com\uxm\Exchange\PrintStat\Logs"
$src = Join-Path $root Daily
$dst = Join-Path $root Aggregate

$Template = 'Template.csv'
# $Template = 'Template_eng.csv'
$Template = Join-Path $root ("..\PSTools\" + $Template)
$header = @( [System.IO.File]::ReadAllLines($Template)[0])

if (!(Test-Path $dst -PathType Container)) {
  if ($debug) {
    Write-Host "Creating folder: $dst"
  }
  mkdir $dst -Force | Out-Null
}

function readDay([datetime]$date = [datetime]::Now) {
  $fname = $src + "\PrintLog-" + $date.ToString("dd-MM-yyyy") + ".csv"
  $grep = "^" + $date.ToString("yyyy-MM-dd") + "\s"
  if (!(Test-Path $fname -PathType Leaf)) {
    return @()
  }
  if ($debug) {
    Write-Host "Reading day: $fname"
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

  $prev = @()
  if (Test-Path $fname -PathType Leaf) {
    $grep = "^" + $d.ToString("yyyy-MM") + '-\d{2}\s'
    if ($debug) {
      Write-Host "Reading month: $fname"
    }
    $prev = [System.IO.File]::ReadAllLines($fname) | Where-Object { $_ | Select-String -Pattern $grep -Quiet }
  }
  $prev = ($prev + $m.Group) | Sort-Object -Unique
  if ($debug) {
    Write-Host "Writing month: $fname"
  }
[System.IO.File]::WriteAllLines($fname, $header + $prev)
}

$fname = $dst + "\all.csv"
$grep = '^\d{4}-\d{2}-\d{2}\s'
$prev = @()
if (Test-Path $fname -PathType Leaf) {
  if ($debug) {
    Write-Host "Reading: $fname"
  }
 $prev = [System.IO.File]::ReadAllLines($fname) | Where-Object { $_ | Select-String -Pattern $grep -Quiet }
}
$prev = ($prev + $data) | Sort-Object -Unique
if ($debug) {
  Write-Host "Writing: $fname"
}
[System.IO.File]::WriteAllLines($fname, $header + $prev)

if ($debug) {
  Write-Host "That's all folks!"
}

