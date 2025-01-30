#
# Associate 7z file manager with types
#
$exts = -split "7z zip rar cab xz txz lzma tar cpio bz2 bzip2 tbz2 gz gzip tgz z lzh lha rpm deb arj"
$handler = '7z.uxm'
$to = 'Registry::HKCR'

$cfg = 'HKLM:\SOFTWARE\7-Zip'

function Associate7zip {
  if (!(Test-Path $cfg -PathType Container)) {
    exit
  }

  $path = (Get-Item $cfg).GetValue('Path')
  if (!(Test-Path $path -PathType Container)) {
    exit
  }

  $bin = Join-Path $path 7zFM.exe

  New-Item -Path "$to\$handler\shell\open\command" -Force -Value "`"$bin`" `"%1`""
  foreach ($ext in $exts) {
    New-Item -Path "$to\.$ext" -Force -Value $handler
  }
}

Associate7zip
