#
# Преобразовать сообщение Outlook .msg -> .html + вложения
#

$folder = Join-Path (Split-Path $PSCommandPath -Parent) msg

Add-Type -AssemblyName System.Windows.Forms

$d = New-Object System.Windows.Forms.OpenFileDialog
$d.Title = "Выберите почтовое сообщение"
$d.Filter = 'Почтовые сообщения|*.msg|Все файлы|*.*'
$d.InitialDirectory = $folder

if ($d.ShowDialog() -ne "OK") {
  exit
}
$src = $d.FileName

# $msg = 'C:\Users\s.ukolov\Documents\repo\posh-sandbox\1c2AD\welcome\msg\uxm.msg'

$o = New-Object -ComObject Outlook.Application
$z = $o.Session.OpenSharedItem($src)

$z.Subject

$z.Close(1) # olDiscard
# $o.Quit()
