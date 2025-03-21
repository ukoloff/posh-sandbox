#
# Восстановить БД из бэкапа на другом сервере
# Текстовый интерактивный интерфейс
#
$src = "SRVSQL-1C"
$dst = "SRVSQL-1Ctests"
$dstFolder = "D:\"

function mssqlConnect($server) {
  $b = New-Object System.Data.OleDb.OleDbConnectionStringBuilder
  $b.Provider = 'sqloledb'
  $b.Add('Integrated Security', 'SSPI')
  $b.Add('Data Source', $server)
  $b.Add('Initial Catalog', 'msdb')
  # $c = New-Object System.Data.OleDb.OleDbConnection $b.ConnectionString
  $c = New-Object -ComObject ADODB.Connection
  $c.Open($b.ConnectionString)
  $c
}

$dbSrc = mssqlConnect($src)
$dbDst = mssqlConnect($dst)

function listBackups {
  $c = New-Object -ComObject ADODB.Command
  $c.ActiveConnection = $dbSrc
  $c.CommandText = @"
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
  $r = $c.Execute()
  $rows = while(!$r.EOF) {
    $row = [ordered]@{}
    foreach ($f in $r.Fields) {
      $row[$f.Name] = $f.Value
    }
    $r.MoveNext()
    $row
  }
  $rows
}

function selectBD {
  "Имеющиеся резервные копии на сервере: $src"
  $backups = listBackups
  $backups | ft
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
    return $backups[$n-1].БД
  }
}

function Run {
  $bd1 = selectBD
  "Выбрана резервная копия mssql://$src/$bd1"
}

Run
