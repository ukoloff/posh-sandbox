#
# Send mail with attachments
#
$cred = Get-StoredCredential -Target serviceuxm@omzglobal.com

Split-Path $PSCommandPath -Parent |
Get-ChildItem -Directory |
ForEach-Object {
  $src = $_.FullName
  $subject = (Get-Content -Raw (Join-Path $src subject.txt)).Trim()
  $body = (Get-Content -Raw (Join-Path $src body.html)).Trim()
  [array]$az = Join-Path $src files |
  Get-ChildItem -File |
  ForEach-Object { $_.FullName }

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
}
