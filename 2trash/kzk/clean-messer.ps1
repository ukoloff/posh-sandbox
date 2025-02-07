#
# Очистка папки \\kzkServ\Data\ZEX23\MESSER от старых файлов
#
$folder = 'e:\Data\ZEX23\MESSER'
$day = 14
if (!(Test-Path $folder -PathType Container)) {
  $folder = 'C:\temp\messer\trash'
}

$d = (Get-Date).AddDays(-$day)
Get-ChildItem -Path $folder -File |
Where-Object { $_.LastWriteTime -le $d } |
ForEach-Object {
  $dst = Join-Path "$folder.sav" $_.LastAccessTime.ToString("yyyy\\MM\\")
  $dst = New-Item $dst -Force -ItemType Directory
  Move-Item $_.FullName $dst.FullName -Force
}
