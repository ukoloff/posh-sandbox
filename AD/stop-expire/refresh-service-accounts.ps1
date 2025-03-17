#
# Stop Expire! for service accounts
#
param( # Для самостоятельной установки запуска по расписанию
  [switch]$install,
  [switch]$remove
)

$OUs = @(
  'OU=ekb.ru,OU=Service,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'
  'OU=СТО,OU=ОИТ,OU=Дирекция ИТ,OU=Дирекция,OU=Users,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'
)
$Group = 'WAC'  # Not used

#
# Самостоятельная установка / удаление в Планировщик заданий
#
if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir
  $Trigger = New-ScheduledTaskTrigger -At 04:00 -Weekly -DaysOfWeek Sunday -RandomDelay 01:00:00
  $Task = New-ScheduledTask -Action $Action -Trigger $Trigger
  Register-ScheduledTask -TaskName $me -TaskPath uxm -InputObject $Task -User "System" -Force
  exit
}

if ($remove) {
  $me = Split-Path $PSCommandPath -Leaf
  Unregister-ScheduledTask -TaskName $me -TaskPath '\uxm\' -Confirm:$false
  exit
}

function getUsers {
  Get-ADUser -SearchBase $OU -Filter *

  Get-ADGroup $Group |
  Get-ADGroupMember -Recursive
}

$OUs |
ForEach-Object { Get-ADUser -SearchBase $_ -Filter *} |
Out-GridView

exit
getUsers |
Set-ADUser -Replace @{pwdLastSet = 0 } -PassThru |
Set-ADUser -Replace @{pwdLastSet = -1 } -PassThru |
Get-ADUser -Properties pwdLastSet, PasswordLastSet
