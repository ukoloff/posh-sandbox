#
# Перенос журналов резервного копирования с одного SQL-сервера на другой
#

$src = "SRVSQL-1C"
$dst = "SRVSQL-1Ctests"

$tables = -split "backupfile backupfilegroup backupset backupmediafamily backupmediaset"

Open-SQLConnection -ConnectionName xa -Server $src -Database msdb
Open-SQLConnection -ConnectionName xz -Server $dst -Database msdb

foreach ($t in $tables) {
  Invoke-SqlUpdate -ConnectionName xz "Delete From $t"
}

[array]::Reverse($tables)
foreach ($t in $tables) {
  Invoke-SqlBulkCopy -SourceConnectionName xa -DestinationConnectionName xz -SourceTable $t -DestinationTable $t
}

Close-SqlConnection xa
Close-SqlConnection xz
