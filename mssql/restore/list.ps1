#
# Find latest backup(s)
#
$Server = "SRVSQL-1C"
$Folder = '\\SRVSQL-1C\E$\stas'

Open-SQLConnection -Server $Server

# $backups = @()

Get-ChildItem $Folder -File |
Sort-Object CreationTime -Descending |
ForEach-Object {
  Invoke-SqlQuery 'restore headeronly from disk = @file' -Parameters @{file = $_.FullName }
} | Out-GridView

Close-SqlConnection
