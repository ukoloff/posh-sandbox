#
# Восстановить БД из бэкапа на другом сервере
# Текстовый интерактивный интерфейс
#
$src = "SRVSQL-1C"
$dst = "SRVSQL-1Ctests"
$dstFolder = "D:\"

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
  $t |
  Select-Object @{Name = 'Дата';
    Expression         = "backup_start_date"
  }, @{Name    = "Файл резервной копии";
    Expression = "physical_device_name"
  }
}

function Run {
  $dbA = selectBD
  "Выбрана резервная копия mssql://$src/$dbA"
  findFiles $dbA
}

Run
