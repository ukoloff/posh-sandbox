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
  echo $sid
}
