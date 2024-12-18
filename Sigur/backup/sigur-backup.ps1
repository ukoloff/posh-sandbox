#
# Sigur backup
#
param(
  [switch]$install,
  [switch]$remove
)

$src = 'c:\Program Files (x86)\SIGUR access management\server\autobackup'
$dst = '\\DATATRASH\Sigur$'

$Days = [PSCustomObject]@{
  zip  = 3
  move = 3
  drop = 42
}

if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir
  $Trigger = New-ScheduledTaskTrigger -Daily -At 1:27 -RandomDelay 00:42:00
  $Task = New-ScheduledTask -Action $Action -Trigger $Trigger
  Register-ScheduledTask -TaskName $me -TaskPath uxm -InputObject $Task -User "System" -Force
  exit
}

if ($remove) {
  $me = Split-Path $PSCommandPath -Leaf
  Unregister-ScheduledTask -TaskName $me -TaskPath '\uxm\' -Confirm:$false
  exit
}

$d = Get-Date
$d = $d.AddDays(-$Days.zip)
Get-ChildItem -Path $src -File -Filter *.sql |
Where-Object { $_.LastAccessTime -le $d } |
ForEach-Object {
  $f = $_.FullName
  7z a -sdel "$f.7z" $f
}

$d = Get-Date
$d = $d.AddDays(-$Days.move)
Get-ChildItem -Path $src -File -Filter *.7z |
Where-Object { $_.CreationTime -le $d } |
ForEach-Object {
  Move-Item $_.FullName $dst -Force
}

$d = Get-Date
$d = $d.AddDays(-$Days.drop)
Get-ChildItem -Path $dst -File -Filter *.7z |
Where-Object { $_.CreationTime -le $d } |
Where-Object { $_.Name -notcontains "-01.sql." } |
ForEach-Object {
  Remove-Item $_.FullName
}
