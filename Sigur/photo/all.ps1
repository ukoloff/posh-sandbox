# https://winitpro.ru/index.php/2016/04/19/vypolnenie-mysql-zaprosov-iz-powershell/
#
# Install-Module -Name SimplySql
#

# Store Credentials:
# ------------------
# $cred = Get-Credential
# New-StoredCredential -Target mysql:SKUD -Credentials $cred -Persist LocalMachine
$cred = Get-StoredCredential -Target 'mysql:SKUD'

$sql = Open-MySqlConnection -ConnectionName default -Server srvskud-ekbh1 -Port 3305 -Database  tc-db-main -Credential $cred

$data = Invoke-SqlQuery @"
Select
  P.ID,
  HIRES_RASTER,
  NAME, TABID
From
  photo As X
  Join personal P On P.ID = X.ID
"@

$src = Split-Path ($MyInvocation.MyCommand.Source) -Parent
$dst = Join-Path $src 'jpeg'

foreach ($z in $data) {
  $fname = Join-Path $dst ($z.NAME + ' [' + ($z.TABID -replace '\W+', '-') + '].jpg')
  [System.Io.File]::WriteAllBytes($fname, $z.HIRES_RASTER)
}
