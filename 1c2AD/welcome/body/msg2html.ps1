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

$name = (Get-Item $src).BaseName
$dst = New-Item -Force -ItemType Directory (Join-Path $folder $name)
# Move-Item $src $dst
$z.Subject | Out-File (Join-Path $dst subject.txt) -Encoding utf8
$z.HTMLbody | Out-File (Join-Path $dst body.html) -Encoding utf8
$z.body | Out-File (Join-Path $dst body.txt) -Encoding utf8
'*' | Out-File (Join-Path $dst .gitignore) -Encoding utf8
foreach ($a in $z.Attachments) {
  $aFolder = New-Item -Force -ItemType Directory (Join-Path $dst files)
  $a.SaveAsFile((Join-Path $aFolder $a.FileName))
}
$z.Close(1) # olDiscard
# $o.Quit()
