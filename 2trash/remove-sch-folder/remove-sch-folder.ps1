#
# Remove folder in Scheduled Tasks
#

$fs = 'C:\Windows\System32\Tasks'
$reg = 'HKLM:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree'

$base = 'uxm'
$remove = @('tmp', 'test')
