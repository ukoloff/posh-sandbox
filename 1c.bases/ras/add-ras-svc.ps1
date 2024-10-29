#
# Add 1C RAS service
#
$portRAS = 1545
$name = "1C.RAS"

$port1c = 1640

$exe = "c:\Program Files\1cv8\8.3.25.1336\bin\ras.exe"
$dsq = "1C:Enterprise 8.3 RAS Server"

sc.exe stop $name    | Out-Null
sc.exe delete $name  | Out-Null
$Service = @{
  Name           = $name
  BinaryPathName = "`"$exe`" --service cluster -p $portRAS 127.0.0.1:$port1c"
  Description    = $dsq
  StartupType    = "Automatic"
}
New-Service @Service
