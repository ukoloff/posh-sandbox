﻿#
# Рассылка уведомлений о днях рождения
#
param(
  [switch]$install,
  [switch]$remove
)

Import-Module ActiveDirectory
$adBase = 'OU=uxm,OU=MS,DC=omzglobal,DC=com'

if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir
  $Trigger = New-ScheduledTaskTrigger -Daily -At 7:40 -RandomDelay 00:05:00
  $Task = New-ScheduledTask -Action $Action -Trigger $Trigger
  Register-ScheduledTask -TaskName $me -TaskPath uxm -InputObject $Task -User "System" -Force
  exit
}

if ($remove) {
  $me = Split-Path $PSCommandPath -Leaf
  Unregister-ScheduledTask -TaskName $me -TaskPath '\uxm\' -Confirm:$false
  exit
}

# Store Credentials:
# ------------------
# $cred = Get-Credential
# # Install-Module -Name CredentialManager
# New-StoredCredential -Target serviceuxm@omzglobal.com -Credentials $cred -Persist LocalMachine
$cred = Get-StoredCredential -Target serviceuxm@omzglobal.com

# Texts
$Greetings = @(
  "Примите теплые сердечные поздравления с днем рождения!<br>
От всей души желаем Вам счастья, благополучия и радости, неиссякаемой энергии для преодоления всех трудностей и, конечно, успехов в Вашей профессиональной деятельности.<br>
Пусть рядом всегда будут дорогие и любящие люди!",
  "Примите теплые сердечные поздравления с днём Вашего рождения!<br>
От всей души желаем Вам огромного счастья, удачи во всех Ваших начинаниях, понимания и поддержки со стороны друзей и близких, уважения и признательности коллег.<br>
Долгих лет Вам жизни в мире и благополучии.",
  "Примите самые искренние поздравления с днём рождения и пожелания Вам крепкого здоровья на долгие годы, жизненной энергии и прекрасного настроения!<br>
Пусть в Вашей  жизни всегда будет место прекрасному, а тепло сердец окружающих Вас людей каждый день дарит радость жизни!",
  "В этот замечательный день желаем Вам крепкого здоровья, счастья, добрых надежд и вдохновения, свершения Ваших самых заветных желаний!<br>
Пусть хорошее настроение и успех будут Вашими верными спутниками во всех делах и начинаниях!"
)

# Attachments
$me = Split-Path $PSCommandPath -Parent
[array]$assets = Join-Path $me assets |
Get-ChildItem -File |
ForEach-Object { $_.FullName }

$Log = @{
  LiteralPath = Join-Path $env:TMP "$(Split-Path $PSCommandPath -Leaf).log"
  Append      = $true
}

function timeStamp() {
  Get-Date -UFormat '%Y-%m-%d %T'
}

$today = Get-Date -Format "dd.MM"
# $today = '08.07'

$filter = "(&(!userAccountControl:1.2.840.113556.1.4.803:=2)(extensionAttribute1=$today.*)(mail=*))"
[array]$Users = Get-ADUser -SearchBase $adBase -LDAPFilter $filter -Properties mail, middleName

foreach ($user in $Users) {
  "[$(timeStamp)] Congratulate [$($user.SamAccountName)] via [$($user.mail)]" | Out-File @Log
  $body = @"
<html>
<head>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<title></title>
</head>
<body>
<table width="1024" height="218" border="0" style="height: 574px;">
<tbody>
<tr>
<td style="width: 300px; height: 574px;"><img src="cid:bgl.png"></td>
<td style="width: 444px;">
<p align=center style='text-align:center'>
    <span style='font-family:"Trebuchet MS","sans-serif"'>$(Get-Random $Greetings)<br>
    <br><br><i>Коллектив АО &laquo;Уралхиммаш&raquo;</i></span>
</p>
</td>
<td style="width: 280px;"><img src="cid:bgr.png"></td>
</tr>
</tbody>
</table>
</body>
</html>
"@
  $mail = @{
    Body        = $body
    Attachments = $assets
    BodyAsHtml  = $true
    Subject     = "Поздравляем с днем рождения, " + $user.givenName + " " + $User.middleName + "!"
    From        = 'serviceuxm@omzglobal.com'
    To          = $user.mail
    SmtpServer  = 'srvmail-ekbh5.omzglobal.com'
    Port        = '2525'
    Encoding    = 'UTF8'
    Credential  = $cred
  }

  Send-MailMessage @mail
}
