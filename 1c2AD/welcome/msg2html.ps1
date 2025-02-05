#
# Преобразовать сообщение Outlook .msg -> .html + вложения
#

# $msg = Join-Path (Split-Path $PSCommandPath -Parent) msg\uxm.msg
$msg = 'C:\Users\s.ukolov\Documents\repo\posh-sandbox\1c2AD\welcome\msg\uxm.msg'

$o = New-Object -ComObject Outlook.Application
$z = $o.Session.OpenSharedItem($msg)

echo $z.HTMLBody
