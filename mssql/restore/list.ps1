#
# Find latest backup(s)
#
$Server = "SRVSQL-1C"
$Folder = '\\srvsql-1c\e$\'
$DBs = @('stas', 'OP_WORK', 'ERP_WORK', 'ZUP_20')

function getBackups($folder) {
  $baks = Get-ChildItem $folder -File |
  Sort-Object CreationTime -Descending |
  ForEach-Object {
    $row = Invoke-SqlQuery 'restore headeronly from disk = @file' -Parameters @{file = $_.FullName }
    $row | Add-Member -NotePropertyName FullName -NotePropertyValue $_.FullName
    $row
  }
  $found = @()
  [array]$full = $baks | Where-Object {
    $_.BackupType -eq 1 }
  if ($full) {
    $full = $full[0]
    $found = @($full)
    [array]$inc = $baks | Where-Object {
      $_.BackupType -eq 5 -and
      $_.DifferentialBaseGUID -eq $full.BackupSetGUID }
    if ($inc) {
      $found += ($inc[0])
    }
  }
  $found
}


$baks = Get-ChildItem $Folder -File |
Sort-Object CreationTime -Descending |
ForEach-Object {
  $row = Invoke-SqlQuery 'restore headeronly from disk = @file' -Parameters @{file = $_.FullName }
  $row | Add-Member -NotePropertyName FullName -NotePropertyValue $_.FullName
  $row
}
$found = @()
[array]$full = $baks | Where-Object { $_.BackupType -eq 1 }
if ($full) {
  $full = $full[0]
  $found = @($full)
  [array]$inc = $baks | Where-Object { $_.BackupType -eq 5 -and $_.DifferentialBaseGUID -eq $full.BackupSetGUID }
  if ($inc) {
    $found += ($inc[0])
  }
}

Open-SQLConnection -Server $Server
foreach ($db in $DBs) {
  getBackups("$Folder/$db") | Format-Table -Property FullName, BackupType, BackupStartDate
}
Close-SqlConnection
