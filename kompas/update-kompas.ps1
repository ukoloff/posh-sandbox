#
# Обновление Компас-3D
#
$GUID = '{05AB476A-CCCF-456F-B37F-43DDD7AE5F72}'
$v = '21.0.0'
$dist = '\\service\Soft\kompasspatch\KOMPAS-3D_v21.0.26_x64.msp'

# Лог на компьютере пользователя
$Log = @{
  LiteralPath =  Join-Path $env:TEMP "$(Split-Path $PSCommandPath -Leaf).log"
  Append      = $true
}

# Центральный лог, возле дистрибутива
$CentralLog = @{
  LiteralPath = Join-Path (Join-Path (Split-Path $dist -Parent) Logs) "$($env:COMPUTERNAME).log"
  Append      = $true
}

function timeStamp() {
  Get-Date -UFormat '%Y-%m-%d %T %Z'
}

"Starting: $(timeStamp)" | Out-File @Log
"[$(timeStamp)] Starting..." | Out-File @CentralLog

[array]$kompas = Get-WmiObject -Class "Win32_Product" -Filter "IdentifyingNumber='$GUID'"
"Kompas version(s) found:" | Out-File @Log
$kompas | Format-List | Out-File @Log

$cnt = ($kompas | ForEach-Object { $_.Version.StartsWith("$v.")}).Count
"Version(s) to upgrade: $cnt" | Out-File @Log
"[$(timeStamp)] Version(s) to upgrade: $cnt" | Out-File @CentralLog

if (!$cnt) {
  "Exiting..." | Out-File @Log
  exit
}

"Installing: $dist" | Out-File @Log
"[$(timeStamp)] Installing: $dist" | Out-File @CentralLog

msiexec /update $dist /quiet

"Done: $(timeStamp)" | Out-File @Log
"[$(timeStamp)] Done" | Out-File @CentralLog
