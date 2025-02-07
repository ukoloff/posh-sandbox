#
# Очистка папки \\kzkServ\Data\ZEX23\MESSER от старых файлов
#
param( # Для самостоятельной установки запуска по расписанию
  [switch]$install,
  [switch]$remove
)

$folder = 'e:\Data\ZEX23\MESSER'
$days = 14

#
# Самостоятельная установка / удаление в Планировщик заданий
#
if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir
  $Trigger = New-ScheduledTaskTrigger -At 04:00 -Daily -RandomDelay 01:00:00
  $Task = New-ScheduledTask -Action $Action -Trigger $Trigger
  Register-ScheduledTask -TaskName $me -TaskPath uxm -InputObject $Task -User "System" -Force
  exit
}

if ($remove) {
  $me = Split-Path $PSCommandPath -Leaf
  Unregister-ScheduledTask -TaskName $me -TaskPath '\uxm\' -Confirm:$false
  exit
}

if (!(Test-Path $folder -PathType Container)) {
  $folder = 'C:\temp\messer\trash'
}

$d = (Get-Date).AddDays(-$days)
Get-ChildItem -Path $folder -File |
Where-Object { $_.LastWriteTime -le $d } |
ForEach-Object {
  $dst = Join-Path "$folder.sav" $_.LastWriteTime.ToString("yyyy\\MM")
  $dst = New-Item $dst -Force -ItemType Directory
  Move-Item $_.FullName $dst.FullName -Force
}
