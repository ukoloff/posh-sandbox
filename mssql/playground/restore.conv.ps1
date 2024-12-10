# Load SQL Server cmdlets
Import-Module SqlServer
 
# Set variables
$ServerInstance = "SRVSQL-1C"
$DatabaseName = "conv"
  
Restore-SqlDatabase -ServerInstance $ServerInstance -Database $DatabaseName -BackupFile "E:\Conv\conv_backup_2023_10_09_030006_0830244.bak" -ReplaceDatabase
Write-Host "Database restore completed successfully."