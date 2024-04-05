# Load SQL Server cmdlets
Import-Module SqlServer
 
# Set variables
$ServerInstance = "SRVSQL-1C"
$DatabaseName = "conv"
$BackupDir = "C:\Users\s.ukolov\Documents\work\posh\bak"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupFile = "${BackupDir}\${DatabaseName}_${Timestamp}.bak"
 
 
# Backup the SQL Server database
Backup-SqlDatabase -ServerInstance $ServerInstance -Database $DatabaseName -BackupFile $BackupFile
Write-Host "Database backup completed successfully."
