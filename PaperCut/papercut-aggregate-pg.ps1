#
# Try access to PostgreSQL
#
param(
  [int]$days = 2,
  [switch]$all,
  [switch]$quiet
)

$root = "\\omzglobal.com\uxm\Exchange\PrintStat\Logs"
$src = Join-Path $root Daily
$dst = Join-Path $root Aggregate

$Header = 'time,user,pages,copies,printer,document,client,paper,language,height,width,duplex,grayscale,size'

$debug = !$quiet

# Install-Module -Name SimplySql

# Store Credentials:
# ------------------
# $cred = Get-Credential
# # Install-Module -Name CredentialManager
# New-StoredCredential -Target pqsql:UXM -Credentials $cred -Persist LocalMachine
$cred = Get-StoredCredential -Target pqsql:UXM  # Try Kerberos if not found

Open-PostGreConnection -Server 'pg.ekb.ru' -Database uxm -Credential $cred

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
  Start-SqlTransaction
  $lineID = Invoke-SqlScalar @"
    Insert Into papercut_log(session_id, day)
      Values (@s, @d)
      Returning id
"@ -Parameters @{s=$session; d=$date}

  $total = 0
  $added = 0

  readDay($date) |
  ConvertFrom-Csv -Header $fields |
  ForEach-Object {
    $total++
    $_.Time = Get-Date $_.Time
    $_.Pages = [int]$_.Pages
    $_.Copies = [int]$_.Copies
    $n = Invoke-SqlScalar $sqlIf -ParamObject $_
    if ($n -eq 0) {
      Invoke-SqlScalar $sqlAdd -ParamObject $_
      $added++
    }
  }

  Invoke-SqlScalar @"
    Update papercut_log
    Set
      duration = Extract(Epoch FROM (clock_timestamp() - ctime)),
      total = @total,
      added = @added
    Where id=@id
"@ -Parameters @{id=$lineID; total=$total; added=$added}

  Complete-SqlTransaction
}

function processDays($days) {
  $today = [datetime]::Now
  foreach ($i in 1..$days) {
    processDay($today.AddDays($i - $days))
  }
}

function processAllDays() {
  $csvs = Get-ChildItem $src -Filter 'PrintLog-*.csv'
  $days = @()
  foreach ($f in $csvs) {
    if ($f -match "-(?<d>\d{2})-(?<m>\d{2})-(?<y>\d{4}).") {
      [datetime]$d = Get-Date -Day $Matches.d -Month $Matches.m -Year $Matches.y
      $days += @($d)
    }
  }
  $days = $days | Sort-Object
  $days.forEach({ processDay($_) })
}

$session = Invoke-SqlScalar @"
  Insert Into papercut_log(session_id)
    Values(NULL)
    Returning id
"@

if ($all) {
  processAllDays
}
else {
  processDays($days)
}

Invoke-SqlScalar @"
  update papercut_log as L
    set
      duration = Extract(Epoch FROM (clock_timestamp() - L. ctime)),
      total = (select sum(C.total) from papercut_log as C where C.session_id = L.id),
      added = (select sum(C.added) from papercut_log as C where C.session_id = L.id)
    where
      L.id=@id
"@ -Parameters @{id=$session}

Close-SqlConnection
