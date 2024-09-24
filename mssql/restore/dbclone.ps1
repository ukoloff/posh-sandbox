#
# Восстановление клонов БД MS SQL
#
$Server = "SRVSQL-1C"
$Src = "\\$Server\e$\"
$Dst = "\\$Server\g$\"

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
        $files = Invoke-SqlQuery 'restore filelistonly from disk = @file' -Parameters @{file = $bak.FullName }
        $row | Add-Member -NotePropertyName Files -NotePropertyValue $files
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

function timeStamp() {
  Get-Date -UFormat '%Y-%m-%d %T'
}

function restoreDB($db) {
  $params = $DBs[$db]
  if (!$params -or $params.skip) { return }
  $db2 = $params['dst']
  if (!$db2) {
    $db2 = $db + '2'
  }
  $folder = "$Dst$db2"
  $null = New-Item $folder -Force -ItemType Directory
  $Log = @{
    LiteralPath = "$folder/restore.log"
    Append      = $true
  }
  "[$(timeStamp)] Restoring [$db] to [$db2]" | Out-File @Log
  [array]$baks = getBackups("$Src$db")
  foreach ($bak in $baks) {
    "[$(timeStamp)] Restoring [$($bak.FullName)] from $($bak.BackupStartDate)" | Out-File @Log
  }
  "[$(timeStamp)] Done!" | Out-File @Log
}

Open-SQLConnection -Server $Server
foreach ($db in $DBs.Keys) {
  restoreDB($db)
}
Close-SqlConnection
