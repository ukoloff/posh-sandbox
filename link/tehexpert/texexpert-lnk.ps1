#
# Обновление ярлыка "Техэксперт-клиент" на рабочем столе пользователей
#
$name = "Техэксперт-клиент.lnk"
$tgt = "\\tehexpert-ekbh3\techexpert_client\kclient.exe"

$d = [Environment]::GetFolderPath('CommonDesktopDirectory')
if (!(Test-Path "$d\$name" -PathType Leaf)) {
  exit
}
$sh = New-Object -com wscript.shell
$lnk = $sh.CreateShortcut("$d\$name")
$lnk.TargetPath = $tgt
$lnk.Save()
