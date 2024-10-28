#
# Dump Credentials
#
$logs = '\\service\Soft\kompasspatch\cred.logs'

$Log = @{
  LiteralPath = Join-Path $logs "$($env:COMPUTERNAME).log"
  Append      = $true
}

cmdkey /list | Out-File @Log
