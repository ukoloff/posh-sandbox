#
# Try access to PostgreSQL
#
param(
  [int]$days = 2,
  [switch]$all,
  [switch]$debug
)

$root = "\\omzglobal.com\uxm\Exchange\PrintStat\Logs"
$src = Join-Path $root Daily
$dst = Join-Path $root Aggregate

$Header = 'Time,User,Pages,Copies,Printer,DocumentName,Client,PaperSize,Language,Height,Width,Duplex,Grayscale,Size'

# Install-Module -Name SimplySql

# Store Credentials:
# ------------------
# $cred = Get-Credential
# New-StoredCredential -Target pqsql:UXM -Credentials $cred -Persist LocalMachine
$cred = Get-StoredCredential -Target pqsql:UXM  # Try Kerberos if not found

Open-PostGreConnection -Server 'pg.ekb.ru' -Database uxm -Credential $null

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

$fields = $Header -split ','
$sqlIf = @"
  Select Count(*)
  From papercut
  Where $($fields.ForEach({ "`"$_`" = @$_"}) -join ' And ')
"@
$sqlAdd = @"
  Insert Into papercut($($fields.ForEach({"`"$_`""}) -join ", "))
  Values ($($fields.ForEach({"@$_"}) -join ", "))
"@

function processDay([datetime]$date = [datetime]::Now) {
  readDay($date) |
  ConvertFrom-Csv -Header $fields |
  ForEach-Object {
    $_.Time = Get-Date $_.Time
    $_.Pages = [int]$_.Pages
    $_.Copies = [int]$_.Copies
    $n = Invoke-SqlScalar $sqlIf -ParamObject $_
    if ($n -eq 0) {
      Invoke-SqlUpdate $sqlAdd -ParamObject $_ | Out-Null
    }
  }
}

function processDays($days) {
  $today = [datetime]::Now
  foreach ($i in 1..$days) {
    processDay($today.AddDays(1 - $i))
  }
}

function processAllDays() {
  $csvs = Get-ChildItem $src -Filter 'PrintLog-*.csv'
  foreach ($f in $csvs) {
    if ($f -match "-(?<d>\d{2})-(?<m>\d{2})-(?<y>\d{4}).") {
      [datetime]$d = Get-Date -Day $Matches.d -Month $Matches.m -Year $Matches.y
      processDay($d)
    }
  }
}

# $all = $true
if ($all) {
  processAllDays
}
else {
  processDays($days)
}
