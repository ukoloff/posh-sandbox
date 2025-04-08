#
# Mirror repos to GitLab
#
param(
  [switch]$install,
  [switch]$remove
)

if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir

  # https://gist.github.com/NickolajA/9f670e80bb3791b87389e3093909d1dc
  $StateChangeTrigger = Get-CimClass -Namespace "root\Microsoft\Windows\TaskScheduler" -ClassName "MSFT_TaskSessionStateChangeTrigger"
  $Trigger = New-CimInstance -CimClass $StateChangeTrigger -Property @{ StateChange = 8 } -ClientOnly
  $Trigger.StateChange = 7 # TASK_SESSION_LOCK https://learn.microsoft.com/en-us/windows/win32/taskschd/sessionstatechangetrigger-statechange
  $Trigger.Delay = "PT5M"

  $Task = New-ScheduledTask -Action $Action -Trigger $Trigger
  Register-ScheduledTask -TaskName $me -TaskPath uxm -InputObject $Task -Force
  exit
}


Set-Location (Split-Path $PSCommandPath -Parent)
$root = git rev-parse --show-toplevel
$repos = Split-Path $root -Parent
$repos = Get-ChildItem -Path $repos -Directory

foreach ($repo in $repos) {
  "[$($repo)]"

  Set-Location $repo.FullName
  if ('gitlab' -notin (git remote)) {
    continue
  }
  git push --all gitlab
}
