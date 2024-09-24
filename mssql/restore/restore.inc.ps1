#
# Quick restore
#
Import-Module SqlServer

$Server = "SRVSQL-1C"
$DB = 'stas2'
$Backup = 'e:\stas\20240917_105138.bak'
$BackupX = 'e:\stas\20240917_134027.diff.bak'

$reData = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("stas", "j:\stas\stasX.mdf")
$reLog = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("stas_log", "j:\stas\stasX_log.ldf")

$params1 = @{
  ServerInstance  = $Server
  Database        = $DB
  BackupFile      = $Backup
  ReplaceDatabase = $true
  RelocateFile    = @($reData, $reLog)
  NoRecovery      = $true
}
Restore-SqlDatabase @params1

$params2 = @{
  ServerInstance = $Server
  Database       = $DB
  BackupFile     = $BackupX
}
Restore-SqlDatabase @params2
