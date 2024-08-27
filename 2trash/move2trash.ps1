#
# Удаление файлов старше ... дней в Корзину
#
param( # Для самостоятельной установки запуска по расписанию
  [switch]$install,
  [switch]$remove
)

$days = 180
$folder = 'c:\temp\x'

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

$d = Get-Date
$d = $d.AddDays(-$days)

Get-ChildItem -Path $folder -File |
Where-Object { $_.LastAccessTime -le $d } |
ForEach-Object { move2trash($_.FullName) }
