#
# Find latest backup(s)
#
$Server = "SRVSQL-1C"
$Folder = '\\srvsql-1c\e$\'
$DBs = @('stas', 'OP_WORK', 'ERP_WORK', 'ZUP_20')

function getBackups($folder) {
  $diffs = @{}
  [array]$baks = Get-ChildItem $folder -File |
  Sort-Object CreationTime -Descending
  foreach($bak in $baks) {
    $row = Invoke-SqlQuery 'restore headeronly from disk = @file' -Parameters @{file = $bak.FullName }
    $row | Add-Member -NotePropertyName FullName -NotePropertyValue $bak.FullName
    switch ($row.BackupType) {
      1 {
        # Full DB backup
        $result = @($row)
        if ($diffs[$row.BackupSetGUID]) {
          $result += @($diffs[$row.BackupSetGUID])
        }
        return $result
      }
      5 {
        # Incremental DB backup
        if (!$diffs[$row.DifferentialBaseGUID]) {
          $diffs[$row.DifferentialBaseGUID] = $row
        }
        continue
      }
    }
  }
}

Open-SQLConnection -Server $Server
foreach ($db in $DBs) {
  getBackups("$Folder$db") | Format-Table -Property FullName, BackupType, BackupStartDate
}
Close-SqlConnection
