#
# Восстановление клонов БД MS SQL
#
param(
  [switch]$install,
  [switch]$remove
)

$Server = "SRVSQL-1C"

$Src = "E:\"
$Dst = "G:\"

$DBs = @{
  stas     = @{
    skip = $true
    dst  = 'stas2'
  }
  OP_WORK  = @{
    # skip = $true
    dst = 'OP_TEST2'
  }
  ERP_WORK = @{
    # skip = $true
    dst = 'ERP_WORK_TEST'
  }
  ZUP_20   = @{
    # skip = $true
    dst = 'ZUP_20_TEST'
  }
}

if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir
  $Trigger = New-ScheduledTaskTrigger -Daily -At 7:40 -RandomDelay 00:05:00
  $Task = New-ScheduledTask -Action $Action -Trigger $Trigger
  Register-ScheduledTask -TaskName $me -TaskPath uxm -InputObject $Task -User "System" -Force
  exit
}

if ($remove) {
  $me = Split-Path $PSCommandPath -Leaf
  Unregister-ScheduledTask -TaskName $me -TaskPath '\uxm\' -Confirm:$false
  exit
}

function localizePath($path) {
  "\\$Server\" + ($path -replace ':', '$')
}

function LocalizePaths() {
  if ($env:COMPUTERNAME.ToLower() -eq $Server.ToLower()) { return }
  $global:Src = localizePath($Src)
  $global:Dst = localizePath($Dst)
}

LocalizePaths

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

function buildReloc($path, $files) {
  $exts = @{
    D = 'mdf'
    L = 'ldf'
    X = 'xdf'
  }
  $counts = @{}
  $files.ForEach({
      $result = $path
      $t = $_.Type
      if (!$exts[$t]) { $t = 'X' }
      if ($counts[$t]) {
        $result += "." + $counts[$t]
      }
      else {
        $counts[$t] = 0
      }
      $counts[$t]++
      $result += '.' + $exts[$t]
      # New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($_.LogicalName, $result)
      [object]@{
        LogicalFileName  = $_.LogicalName
        PhysicalFileName = $result
      }
    })
}

function restoreDB($db) {
  $params = $DBs[$db]
  if (!$params -or $params.skip) { return }
  $db2 = $params['dst']
  if (!$db2) {
    $db2 = $db + '_2'
  }
  $folder = "$Dst$db2"
  $null = New-Item $folder -Force -ItemType Directory
  $Log = @{
    LiteralPath = "$folder/restore.log"
    Append      = $true
  }
  "[$(timeStamp)] Restoring [$db] to [$db2]" | Out-File @Log
  [array]$baks = getBackups("$Src$db")
  $N = 0
  foreach ($bak in $baks) {
    $N++
    "[$(timeStamp)] $N. Restoring [$($bak.FullName)] from $($bak.BackupStartDate)" | Out-File @Log
    $params = @{
      ServerInstance = $Server
      Database       = $db2
      BackupFile     = $bak.FullName
    }

    if ($N -eq 1) {
      $params['RelocateFile'] = buildReloc "$folder/$db" $bak.Files
      $params['ReplaceDatabase'] = $True
      if ($N -lt $baks.count) {
        $params['NoRecovery'] = $true
      }
    }

    Restore-SqlDatabase @params
  }
  "[$(timeStamp)] Done!" | Out-File @Log
}

Open-SQLConnection -Server $Server
foreach ($db in $DBs.Keys) {
  restoreDB($db)
}
Close-SqlConnection
