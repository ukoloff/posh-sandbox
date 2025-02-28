#
# Удаление файлов старше ... дней в Корзину
#
param( # Для самостоятельной установки запуска по расписанию
  [switch]$install,
  [switch]$remove
)

#
# Параметры
#
$days = [object]@{
  Remove = 7      # Удаление в самодельную корзину
  Zip    = 7      # Сжатие самодельной корзины
  Trash  = 7      # Удаление из самодельной корзины в стандартную
}

$paths = [object]@{
  Folder  = 'c:\temp\x'
  MyTrash = 'c:\temp\MyTrash'
}

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

Add-Type -AssemblyName Microsoft.VisualBasic
function move2trash($path) {
  # https://stackoverflow.com/a/33981651/6127481
  if (Test-Path -Path $path -PathType Container) {
    [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($path, 'OnlyErrorDialogs', 'SendToRecycleBin')
  }
  else {
    [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($path, 'OnlyErrorDialogs', 'SendToRecycleBin')
  }
}

#
# Создаём папки при необходимости
#
$src = New-Item $paths.Folder -Force -ItemType Directory
$srcFull = $src.FullName
$trash = New-Item $paths.MyTrash -Force -ItemType Directory

#
# Переносим в собственную корзину
#
$d = Get-Date
$timestamp = $d.ToString("yyyy-MM-dd_HH-mm-ss_fff")
$d = $d.AddDays(-$days.Remove)

Get-ChildItem -Path $src -File -Recurse |
Where-Object { $_.LastAccessTime -le $d } |
ForEach-Object {
  $rel = $_.FullName.Substring($srcFull.Length + 1)
  $dst = Join-Path $trash $timestamp
  $dst = Join-Path $dst $rel
  $null = New-Item (Split-Path $dst -Parent) -Force -ItemType Directory
  "Moving: $($_.FullName) to:`t$dst"
  # Move-Item $_.FullName $dst
  [System.IO.File]::Move($_.FullName, $dst)
}

#
# Архивируем старые папки
#
$d = (Get-Date).AddDays(-$days.Zip)
Get-ChildItem -Path $trash -Directory |
Where-Object { $_.CreationTime -le $d } |
ForEach-Object {
  $f = $_.FullName
  7z a -sdel "$f.zip" "$f\."
  Remove-Item $f
}

#
# Удаляем архивы
#
$d = (Get-Date).AddDays(-$days.Trash)
Get-ChildItem -Path $trash -File |
Where-Object { $_.CreationTime -le $d } |
ForEach-Object {
  move2trash($_.FullName)
}
