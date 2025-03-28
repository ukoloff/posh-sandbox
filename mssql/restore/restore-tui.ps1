#
# Восстановить БД из бэкапа на другом сервере
# Текстовый интерактивный интерфейс
#
$src = "SRVSQL-1C"
$dst = "SRVSQL-1Ctests"
$dstFolder = "D:\"

function localizeSrcPath($path) {
  if ($env:COMPUTERNAME.ToLower() -ne $src.ToLower()) {
    $path = "\\$src\" + ($path -replace '^e:', 'Backup$')
  }
  $path
}

function localizeDstPath($path) {
  if ($env:COMPUTERNAME.ToLower() -ne $dst.ToLower()) {
    $drive = [regex]::Escape($dstFolder[0])
    $path = "\\$dst\" + ($path -replace "^$($drive):", 'DB$')
  }
  $path
}

function mssqlConnect($server) {
  $b = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
  $b.Server = $server
  $b.Database = 'msdb'
  $b['Integrated Security'] = $true

  $conn = New-Object System.Data.SqlClient.SqlConnection $b.ConnectionString
  $conn.Open()
  $conn
}

$dbSrc = mssqlConnect($src)
$dbDst = mssqlConnect($dst)

function listBackups {
  $cmd = $dbSrc.CreateCommand()
  $cmd.CommandText = @"
    SELECT
      ROW_NUMBER() over(order by database_name) as [№],
      database_name as [БД],
      min(backup_start_date) as [Первый],
      count(*) as [Кол-во],
      max(backup_start_date) as [Последний]
    FROM
      backupset
    group by
      database_name
"@
  $r = $cmd.ExecuteReader()
  $t = New-Object System.Data.DataTable
  $t.Load($r)
  $r.Close()
  $t
}

function selectBD {
  Write-Host "Имеющиеся резервные копии на сервере: $src"
  $backups = listBackups
  $backups | Format-Table | Out-String | Write-Host
  while ($true) {
    $n = Read-Host "Выберите номер БД для восстановления"
    $n = $n.Trim()
    if ($n -eq '') {
      exit
    }
    if ($n -notmatch '^\d+$') {
      Write-Warning "Требуется число!"
      continue
    }
    $n = [int]$n
    if ($n -lt 1 -or $n -gt $backups.count) {
      Write-Warning "Введите число от 1 до $($backups.count)"
      continue
    }
    return $backups[$n - 1].БД
  }
}

# Find latest backup file(s)
function findFiles($db) {
  $cmd = $dbSrc.CreateCommand()
  $cmd.CommandText = @"
    with latest as(
        select
            top 1 *
        from
            backupset
        where
            database_name = @db
        order by
            backup_start_date Desc
    ),
    chain as(
        select
            1 as generation,
            *
        from
            latest
        union all
        select
            1 + Parent.generation,
            Child.*
        from
            chain as Parent
            join backupset as Child on Parent.differential_base_guid = Child.backup_set_uuid
    ),
    files as(
        select
            chain.*,
            Files.physical_device_name,
            Files.media_count
        from
            chain
            join backupmediafamily as Files on chain.media_set_id = Files.media_set_id
    )
    select
        backup_set_id,
        backup_start_date,
        physical_device_name,
        type,
        media_count
    from
        files
    Order By
        generation Desc
"@
  $cmd.Parameters.Add('@db', [System.Data.SqlDbType]::Variant).Value = $db
  $r = $cmd.ExecuteReader()
  $t = New-Object System.Data.DataTable
  $t.Load($r)
  $r.Close()
  , $t
}

function validateFiles($files) {
  if ($files.Rows.Count -lt 1) {
    return 'Файлов резервных копий не найдено'
  }
  if ($files.Rows[0].type -ne 'D') {
    return 'Не найдено полной резервной копии'
  }
  $null = $files.Columns.Add('path')
  foreach ($row in $files.Rows) {
    $path = localizeSrcPath $row.physical_device_name
    if (!(Test-Path $path -PathType Leaf)) {
      return "Файл не найден: $path"
    }
    $row.path = $path
  }
  return
}

function commonPrefix($a, $b) {
  $l = (@($a.Length, $b.Length) | Measure-Object -Minimum).Minimum
  foreach ($i in 1..$l) {
    $ac = $a[$i - 1]
    if ($null -eq $ac) {
      return $i - 1
    }
    $bc = $b[$i - 1]
    if ($null -eq $bc) {
      return $i - 1
    }
    if ($ac -ne $bc) {
      return $i - 1
    }
  }
  return $i
}

function dbExists($db) {
  $cmd = $dbDst.CreateCommand()
  $cmd.CommandText = "Select DB_ID(@db)"
  $cmd.Parameters.Add('@db', [System.Data.SqlDbType]::NVarChar).Value = $db
  $cmd.ExecuteScalar() -isnot [System.DBNull]
}

function newDB() {
  while ($true) {
    $n = Read-Host "Введите имя для новой базы данных"
    $n = $n.Trim()
    if ($n -ne '' -and (dbExists $n)) {
      Write-Warning "Такая БД уже существует"
      continue
    }
    return $n
  }
}

function selectBDtoo ($dbA) {
  $cmd = $dbDst.CreateCommand()
  $cmd.CommandText = @"
    Select
        name
    From
        sys.databases
    Where
        len(owner_sid) > 1
"@
  $r = $cmd.ExecuteReader()
  $t = New-Object System.Data.DataTable
  $t.Load($r)
  $r.Close()
  $null = $t.Columns.Add('prefix')
  $null = $t.Columns.Add('no')
  foreach ($r in $t.Rows) {
    $r.prefix = commonPrefix $r.name $dbA
  }

  $rows = $t.Rows |
  Sort-Object -Property @{Expression = "prefix"; Descending = $true }, @{Expression = "name" }
  $NN = 0
  foreach ($row in $rows) {
    $row.no = ++$NN
  }
  $rows += [PSCustomObject]@{
    no   = 0
    name = 'Создать новую БД'
  }
  $rows | Format-Table -Property @{Name = "№"; Expression = "no" }, @{Name = "БД"; Expression = "name" } |
  Out-String | Write-Host
  while ($true) {
    $n = Read-Host "Выберите в какую БД восстановить резервную копию"
    $n = $n.Trim()
    if ($n -eq '') {
      exit
    }
    if ($n -notmatch '^\d+$') {
      Write-Warning "Требуется число!"
      continue
    }
    $n = [int]$n
    if ($n -ge $rows.Count) {
      Write-Warning "Введите число от 0 до $($rows.Count - 1)"
      continue
    }
    if ($n) {
      return $rows[$n - 1].name
    }
    $n = newDB
    if ($n -ne '') {
      return $n
    }
  }
}

function finalConfirm {
  while ($true) {
    $r = Get-Random -Minimum 1 -Maximum 9
    $n = Read-Host "Введите $r для начала восстановления из резервной копии"
    $n = $n.Trim()
    if ($n -eq '') {
      exit
    }
    if ($n -eq [string]$r) {
      return
    }
  }
}

function Run {
  $dbA = selectBD
  "Выбрана резервная копия mssql://$src/$dbA"

  $files = findFiles $dbA
  $files | Format-Table @{Name = 'Дата';
    Expression                 = "backup_start_date"
  }, @{Name    = "Файл резервной копии";
    Expression = "physical_device_name"
  } | Out-String | Write-Host

  $err = validateFiles $files
  if ($err) {
    Write-Warning $err
    exit
  }

  $dbZ = selectBDtoo $dbA

  "БД mssql://$src/$dbA будет восстановлена в mssql://$dst/$dbZ"
  finalConfirm
}

Run
