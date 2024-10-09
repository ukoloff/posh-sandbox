#
# Восстановление клонов БД MS SQL
#
param(
  [switch]$install,
  [switch]$remove
)

$Server = "SRVSQL-1C"

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
  if ($env:COMPUTERNAME.ToLower() -ne $Server.ToLower()) {
    $path = "\\$Server\" + ($path -replace ':', '$')
  }
  $path
}

function getBackups($DB) {
  [array]$baks = Invoke-SqlQuery -WarningAction SilentlyContinue @"
    Select
      *
    From
      msdb..backupset S
      Join msdb..backupmediafamily M
        on S.media_set_id = M.media_set_id
    Where
    database_name = @DB
    And type in ('I', 'D')
    Order By
      backup_start_date Desc
"@ -Parameters @{DB = $DB }
  $diffs = @{}
  foreach ($bak in $baks) {
    switch ($bak.type) {
      'D' {
        # Full DB backup
        $files = Invoke-SqlQuery @"
          Select
            *
          From
            msdb..backupfile
          Where
            backup_set_id =  @id
"@  -Parameters @{id = $bak.backup_set_id }
        $bak | Add-Member -NotePropertyName Files -NotePropertyValue $files
        $result = @($bak)
        if ($diffs[$bak.backup_set_uuid]) {
          $result += @($diffs[$bak.backup_set_uuid])
        }
        return $result
      }
      'I' {
        # Incremental DB backup
        if (!$diffs[$bak.differential_base_guid]) {
          $diffs[$bak.differential_base_guid] = $bak
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
      $t = $_.file_type
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
        LogicalFileName  = $_.logical_name
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

  $folder = localizePath "$Dst$db2"
  $null = New-Item $folder -Force -ItemType Directory
  $Log = @{
    LiteralPath = "$folder/restore.log"
    Append      = $true
  }
  "[$(timeStamp)] Restoring [$db] to [$db2]" | Out-File @Log

  [array]$baks = getBackups($db)
  $N = 0
  foreach ($bak in $baks) {
    $N++
    "[$(timeStamp)] $N. Restoring [$($bak.physical_device_name)] from $($bak.backup_start_date)" | Out-File @Log
    $params = @{
      ServerInstance = $Server
      Database       = $db2
      BackupFile     = $bak.physical_device_name
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
