#
# Associate 7z file maneger with types
#

$cfg = 'HKLM:\SOFTWARE\7-Zip'

if (!(Test-Path $cfg -PathType Container)) {
  exit
}

$path = (Get-Item $cfg).GetValue('Path')
if (!(Test-Path $path -PathType Container)) {
  exit
}

