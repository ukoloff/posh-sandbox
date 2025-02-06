#
# Преобразовать сообщение Outlook .msg -> .html + вложения
#

$folder = Join-Path (Split-Path $PSCommandPath -Parent) ..\msg

Add-Type -AssemblyName System.Windows.Forms
$d = New-Object System.Windows.Forms.OpenFileDialog
$d.Title = "Выберите почтовое сообщение"
$d.Filter = 'Почтовые сообщения|*.msg|Все файлы|*.*'
$d.InitialDirectory = $folder

if ($d.ShowDialog() -ne "OK") {
  exit
}
$src = $d.FileName

$o = New-Object -ComObject Outlook.Application
$z = $o.Session.OpenSharedItem($src)

$name = (Get-Item $src).BaseName
$dst = New-Item -Force -ItemType Directory (Join-Path $folder $name)
# Move-Item $src $dst

$z.Subject |
Out-File (Join-Path $dst subject.txt) -Encoding utf8
($body = $z.HTMLbody) |
Out-File (Join-Path $dst body.html) -Encoding utf8
$z.body |
Out-File (Join-Path $dst body.txt) -Encoding utf8
'*' |
Out-File (Join-Path $dst .gitignore) -Encoding utf8

$changed = 0
# Attachments
foreach ($a in $z.Attachments) {
  $aFolder = New-Item -Force -ItemType Directory (Join-Path $dst files)
  $aName = Join-Path $aFolder $a.FileName
  $a.SaveAsFile($aName)
  $re = [regex]::Escape("cid:$($a.FileName)@") + "[a-z\d]{2,}[.][a-z\d]{2,}"
  $rep = "cid:$($a.FileName)"
  $body = $body -replace $re, $rep
  $changed++
}

if ($changed) {
  $body |
  Out-File (Join-Path $dst body.html) -Encoding utf8
}

# Cleanup (???)
$z.Close(1) # olDiscard
# $o.Quit()
