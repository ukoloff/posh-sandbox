#
# Quick incremental backup
#
Import-Module SqlServer

$Server = "SRVSQL-1C"
$DB = 'stas'
$Dst = 'e:\stas'

$f = "$Dst\$(Get-Date -uformat '%Y%m%d_%H%M%S').diff.bak"

Backup-SqlDatabase -ServerInstance $Server -Database $DB -BackupFile $f -Incremental
