#
# Associate 7z file manager with types
#
$exts = -split "7z zip rar cab xz txz lzma tar cpio bz2 bzip2 tbz2 gz gzip tgz z lzh lha rpm deb arj"
$handler = '7z.uxm'
$to = 'Registry::HKCR'

$cfg = 'HKLM:\SOFTWARE\7-Zip'

if (!(Test-Path $cfg -PathType Container)) {
  exit
}

$path = (Get-Item $cfg).GetValue('Path')
if (!(Test-Path $path -PathType Container)) {
  exit
}

New-Item -path "$to\$handler\shell\open\command" -force -value "`"$path\7zFM.exe`" `"%1`""
foreach ($ext in $exts) {
  New-Item -path "$to\.$ext" -force -value $handler
}
