#
# Рассылка уведомлений о днях рождения
#


# Store Credentials:
# ------------------
# $cred = Get-Credential
# # Install-Module -Name CredentialManager
# New-StoredCredential -Target serviceuxm@omzglobal.com -Credentials $cred -Persist LocalMachine
$cred = Get-StoredCredential -Target serviceuxm@omzglobal.com

$mail = @{
  Body = 'Проверка связи'
  # Attachments = $Attachment0.FullName,$Attachment1.FullName
  # BodyAsHtml = $true
  Subject = "Поздравляем с днем рождения. Пух"
  From = 'serviceuxm@omzglobal.com'
  To = 'Stanislav.Ukolov@omzglobal.com'
  SmtpServer = 'srvmail-ekbh5.omzglobal.com'
  Port = '2525'
  Encoding  = 'UTF8'
  Credential = $cred
}

Send-MailMessage @mail
