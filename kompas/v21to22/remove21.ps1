#
# Удалить остатки Компас v21 и Viewer v21
#

$kompas21 = "$($env:ProgramFiles)\ASCON\KOMPAS-3D v21"

$K = Test-Path $kompas21 -PathType Container
$V = Test-Path 'HKLM:\SOFTWARE\ASCON\KOMPAS-3D Viewer\21'

if (!$K -and !$V) {
  exit
}

echo Hi!
