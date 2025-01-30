#
# Обновление ярлыка "Техэксперт-клиент" на рабочем столе пользователей
#
Get-ChildItem -Path Registry::HKU\ |
ForEach-Object {
  $sid = $_.PSChildName
  $x = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid"
  if (!(Test-Path $x)) {
    return
  }
  $p = Get-ItemPropertyValue $x -Name ProfileImagePath
  $q = (Get-Item "$($_.PSPath)\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders").GetValue('Desktop', $null, 'DoNotExpandEnvironmentNames')
  $q = $q -replace '%USERPROFILE%', $p
  echo $q
}
