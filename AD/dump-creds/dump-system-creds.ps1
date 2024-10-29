#
# Dump Credentials
#
$logs = '\\service\Soft\kompasspatch\cred.logs'

$Log = @{
  LiteralPath = Join-Path $logs "$($env:COMPUTERNAME).log"
  Append      = $true
}

"Clearing credentials..." | Out-File @Log
cmdkey /delete:imech
cmdkey /delete:service-old

cmdkey /list | Out-File @Log
