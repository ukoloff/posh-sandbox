#
# Quick incremental restore
#
Import-Module SqlServer

$Server = "SRVSQL-1C"
$DB = 'stas2'
$Backup = 'e:\stas\20240917_105138.bak'

$reData = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("stas", "j:\stas\stas.mdf")
$reLog = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("stas_log", "j:\stas\stas_log.ldf")
$re = @($reData,$reLog)

Restore-SqlDatabase -ServerInstance $Server -Database $DB -BackupFile $Backup -ReplaceDatabase -RelocateFile $re
