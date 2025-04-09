#
# Remove folder in Scheduled Tasks
#

$fs = 'C:\Windows\System32\Tasks'
$reg = 'HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree'

$base = 'uxm'
$remove = @('tmp', 'test')

foreach ($pfx in @($fs, $reg)) {
  foreach ($sfx in $remove) {
    $path = Join-Path $pfx $base
    $path = Join-Path $path $sfx
    Remove-Item -LiteralPath $path -Force -Recurse -ErrorAction SilentlyContinue
  }
}
