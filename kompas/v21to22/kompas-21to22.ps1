#
# Обновление Компас с v21 на v22
#

if (!(Test-Path HKLM:\SOFTWARE\ASCON\KOMPAS-3D\21)) {
  exit
}

$kompas21 = '{05AB476A-CCCF-456F-B37F-43DDD7AE5F72}'

msiexec /X $kompas21 /quiet

