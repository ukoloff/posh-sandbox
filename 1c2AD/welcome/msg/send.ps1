#
# Send mail with attachments
#
$name = 'uxm'

$src = Join-Path (Split-Path $PSCommandPath -Parent) $name

$subject = (Get-Content -Raw (Join-Path $src subject.txt)).Trim()
$body = (Get-Content -Raw (Join-Path $src body.html)).Trim()
[array]$az = Get-ChildItem (Join-Path $src files) | ForEach-Object { $_.FullName }

$cred = Get-StoredCredential -Target serviceuxm@omzglobal.com

$mail = @{
  BodyAsHtml  = $true
  Body        = $body
  Subject     = $subject
  Attachments = $az
  From        = 'serviceuxm@omzglobal.com'
  To          = 'Stanislav.Ukolov@omzglobal.com'
  SmtpServer  = 'srvmail-ekbh5.omzglobal.com'
  Port        = '2525'
  Encoding    = 'UTF8'
  Credential  = $cred
}

Send-MailMessage @mail

