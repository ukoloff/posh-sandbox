#
# Обновление Компас-3D
#
$GUID = '{05AB476A-CCCF-456F-B37F-43DDD7AE5F72}'
$v = '21.0.0'

[array]$kompas = Get-WmiObject -Class "Win32_Product" -Filter "IdentifyingNumber='$GUID'"
