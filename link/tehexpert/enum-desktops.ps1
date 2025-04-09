#
# Найти все рабочие столы
#
Get-ChildItem -Path Registry::HKU\ |
ForEach-Object {
  $sid = $_.PSChildName
  $x = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid"
  if (!(Test-Path $x)) {
    return
  }
  $p = Get-ItemPropertyValue $x -Name ProfileImagePath
  $d = (Get-Item "$($_.PSPath)\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders").GetValue('Desktop', $null, 'DoNotExpandEnvironmentNames')
  $d = $d -replace '%USERPROFILE%', $p
  if (!(Test-Path $d -PathType Container)) {
    return
  }
  echo $d
}
