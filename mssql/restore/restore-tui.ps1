#
# Восстановить БД из бэкапа на другом сервере
# Текстовый интерактивный интерфейс
#
$src = "SRVSQL-1C"
$dst = "SRVSQL-1Ctests"
$dstFolder = "D:\"

function listBackups {
  Invoke-SqlQuery @"
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
"@ -ConnectionName src
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
  selectBD
}

Open-SQLConnection -ConnectionName src -Server $src -Database msdb
Open-SQLConnection -ConnectionName dst -Server $dst -Database msdb

Run

Close-SqlConnection -ConnectionName src
Close-SqlConnection -ConnectionName dst
