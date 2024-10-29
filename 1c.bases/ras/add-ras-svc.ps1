#
# Add 1C RAS service(s)
#
$portRAS = 1545
$name = "1C.RAS"

$hosts = @(3, 2)
$server = "srv1c-ekbh"
$port1c = 1640

$exe = "c:\Program Files\1cv8\8.3.25.1336\bin\ras.exe\"
$cmd = "`"$exe`" --service cluster"
$dsq = "1C:Enterprise 8.3 RAS Server"

foreach ($id in $hosts) {
  $aName = "$name-$id"
  $aServer = $server + $id
  sc.exe stop $aName    | Out-Null
  sc.exe delete $aName  | Out-Null
  $Service = @{
    Name = "$name-$id"
    BinaryPathName = "$cmd  -p $portRAS $aServer`:$port1c"
    Description = "$dsq @$aServer"
    StartupType = "Automatic"
  }
  $portRAS++
  New-Service @Service
}
