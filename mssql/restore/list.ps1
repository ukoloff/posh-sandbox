#
# Find latest backup(s)
#
$Server = "SRVSQL-1C"
$Folder = '\\SRVSQL-1C\E$\stas'

Open-SQLConnection -Server $Server

# $backups = @()

$baks = Get-ChildItem $Folder -File |
Sort-Object CreationTime -Descending |
ForEach-Object {
  Invoke-SqlQuery 'restore headeronly from disk = @file' -Parameters @{file = $_.FullName }
}
$found = @()
$full = $baks | Where-Object { $_.BackupType -eq 1 }
if ($full) {
  $full = $full[0]
  $found = @($full)
  $inc = $baks | Where-Object { $_.BackupType -eq 5 -and $_.DifferentialBaseGUID -eq $full.BackupSetGUID}
  if ($inc) {
    $found += ($inc[0])
  }
}

Close-SqlConnection

echo $found
