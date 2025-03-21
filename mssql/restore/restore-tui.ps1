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
      database_name as [name],
      min(backup_start_date) as dateA,
      count(*) as [n],
      max(backup_start_date) as dateZ
    FROM
      backupset
    group by
      database_name
    order by
      1
"@ -ConnectionName src
}

Open-SQLConnection -ConnectionName src -Server $src -Database msdb
Open-SQLConnection -ConnectionName dst -Server $dst -Database msdb

listBackups

Close-SqlConnection -ConnectionName src
Close-SqlConnection -ConnectionName dst
