#
# Преобразовать сообщение Outlook .msg -> .html + вложения
#
$msg = Join-Path (Split-Path $PSCommandPath -Parent) msg\uxm.msg

$outlook = New-Object -comobject outlook.application
echo $msg
$z = $outlook.Session.OpenSharedItem($msg)

echo $z.body
