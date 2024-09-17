#
# Quick restore
#
Import-Module SqlServer

$Server = "SRVSQL-1C"
$DB = 'stas2'
$Backup = 'e:\stas\Stas_20240916_164915.bak'

$reData = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("stas", "j:\stas\stas2.mdf")
$reLog = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile("stas_log", "j:\stas\stas2_log.ldf")
$re = @($reData,$reLog)

Restore-SqlDatabase -ServerInstance $Server -Database $DB -BackupFile $Backup -ReplaceDatabase -RelocateFile $re
