#
# Рассылка уведомлений о днях рождения
#
Import-Module ActiveDirectory
$adBase = 'OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'

# Store Credentials:
# ------------------
# $cred = Get-Credential
# # Install-Module -Name CredentialManager
# New-StoredCredential -Target serviceuxm@omzglobal.com -Credentials $cred -Persist LocalMachine
$cred = Get-StoredCredential -Target serviceuxm@omzglobal.com

$today = Get-Date -Format "dd.MM"
$today = '08.07'

$filter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(extensionAttribute1=$today.*)(mail=*)(sAMAccountName=s.*))"
[array]$Users = Get-ADUser -SearchBase $adBase -LDAPFilter $filter -Properties mail,middleName

foreach ($user in $Users) {

  $mail = @{
    Body       = 'Проверка связи'
    # Attachments = $Attachment0.FullName,$Attachment1.FullName
    # BodyAsHtml = $true
    Subject    = "Поздравляем с днем рождения, " +  $user.givenName + " " + $User.middleName + "!"
    From       = 'serviceuxm@omzglobal.com'
    To         = $user.mail
    SmtpServer = 'srvmail-ekbh5.omzglobal.com'
    Port       = '2525'
    Encoding   = 'UTF8'
    Credential = $cred
  }

  Send-MailMessage @mail
}
