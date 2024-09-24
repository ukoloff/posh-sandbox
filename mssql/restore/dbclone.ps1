#
# Восстановление клонов БД MS SQL
#
$Server = "SRVSQL-1C"
$Src = "\\$Server\e$\"
$Dst = 'G:\'

$DBs = @{
  stas     = @{
    logname = 'stas'
    dst     = 'stas2'
  }
  OP_WORK  = @{
    skip    = $true
    logname = 'OP_WORK'
    dst     = 'OP_TEST2'
  }
  ERP_WORK = @{
    skip    = $true
    logname = 'Jan11'
    dst     = 'ERP_WORK_TEST'
  }
  ZUP_20   = @{
    skip    = $true
    logname = 'ZUP3_WORK'
    dst     = 'ZUP_20_TEST'
  }
}

function getBackups($folder) {
  $diffs = @{}
  [array]$baks = Get-ChildItem $folder -File |
  Sort-Object CreationTime -Descending
  foreach ($bak in $baks) {
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

function restoreDB($db) {
  $params = $DBs[$db]
  if (!$params -or $params.skip) { return }
  echo $db
}

Open-SQLConnection -Server $Server
foreach ($db in $DBs.Keys) {
  restoreDB($db)
}
Close-SqlConnection
