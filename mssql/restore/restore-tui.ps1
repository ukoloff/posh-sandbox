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

Open-SQLConnection -ConnectionName src -Server $src -Database msdb
Open-SQLConnection -ConnectionName dst -Server $dst -Database msdb

listBackups | ft

Close-SqlConnection -ConnectionName src
Close-SqlConnection -ConnectionName dst
