#
# Перенос журналов резервного копирования с одного SQL-сервера на другой
#
param(
  [switch]$install,
  [switch]$remove
)

$src = "SRVSQL-1C"
$dst = "SRVSQL-1Ctests"

$tables = -split "backupfile backupfilegroup backupset backupmediafamily backupmediaset"
$rtables = -split "restorefilegroup restorefile restorehistory"

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

Open-SQLConnection -ConnectionName xa -Server $src -Database msdb
Open-SQLConnection -ConnectionName xz -Server $dst -Database msdb

Start-SqlTransaction -ConnectionName xz

Write-Output "Records deleted:"
$len = ($tables | ForEach-Object {$_.Length} | Measure-Object -Maximum).Maximum + 1
foreach ($t in $rtables) {
  $count = Invoke-SqlUpdate -ConnectionName xz "Delete From $t"
  Write-Output "  $($t.PadRight($len))$count"
}
foreach ($t in $tables) {
  $count = Invoke-SqlUpdate -ConnectionName xz "Delete From $t"
  Write-Output "  $($t.PadRight($len))$count"
}

Write-Output "Records copied:"
[array]::Reverse($tables)
foreach ($t in $tables) {
  $count = Invoke-SqlBulkCopy -SourceConnectionName xa -DestinationConnectionName xz -SourceTable $t -DestinationTable $t
  Write-Output "  $($t.PadRight($len))$count"
}

Write-Output "Backup paths patched:"
$t = 'backupmediafamily'
$count = Invoke-SqlUpdate -ConnectionName xz @"
  Update
    backupmediafamily
  Set
    physical_device_name = STUFF(physical_device_name, 1, 2, '\\srvSQL-1C\Backup$')
  Where
    physical_device_name LIKE 'e:\%'
"@
Write-Output "  $($t.PadRight($len))$count"

Complete-SqlTransaction -ConnectionName xz

Close-SqlConnection xa
Close-SqlConnection xz
