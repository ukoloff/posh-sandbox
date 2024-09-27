#
# Уведомления перед днём рождения
#
param(
  [switch]$install,
  [switch]$remove
)

Import-Module ActiveDirectory
$adBase = 'OU=uxm,OU=MS,DC=omzglobal,DC=com'

#
# Установка / удаление ежедневного задания
#
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

$Log = @{
  LiteralPath = Join-Path $env:TMP "$(Split-Path $PSCommandPath -Leaf).log"
  Append      = $true
}
function timeStamp() {
  Get-Date -UFormat '%Y-%m-%d %T'
}

$bday = (Get-Date).AddDays(3)
$then = $bday.ToString("dd.MM")
$fullday = $bday.ToString('dd MMMM yyyy г. (dddd)')

$filtEn = '(!userAccountControl:1.2.840.113556.1.4.803:=2)'
$filter = "(&$filtEn(extensionAttribute1=$then.*))"
[array]$Users = Get-ADUser -SearchBase $adBase -LDAPFilter $filter -Properties Manager, title, department, displayName

$mgrFilter = "(&$filtEn(directReports=*)(Manager=*))"
function getManagers($u) {
  # Для одного пользователя найти непосредственного руководителя или нескольких
  $u = Get-ADUser $u -Properties Manager
  if ($u.Manager -and $u.Enabled) {
    $m = Get-ADUser $u.Manager -Properties Manager
    if ($m.Enabled -and $m.Manager) {
      return @($m)
    }
  }

  # Руководитель не указан, ищем руководителей в подразделении
  $dn = $u.DistinguishedName
  while (1) {
    $ou = ($dn -split ',OU=', 2)[1]
    if (!$ou) {
      return @()
    }
    $ou = 'OU=' + $ou
    [array]$list = Get-ADUser -SearchBase $ou -LDAPFilter $mgrFilter -SearchScope OneLevel -Properties Manager
    if ($list) {
      return $list
    }
    $dn = $ou
  }
}

function escalate([object]$u) {
  # Для руководителя найти самого высокого руководителя
  $seen = @{}
  while (1) {
    $seen[$u.SamAccountName] = 1
    $m = Get-ADUser $u.Manager -Properties Manager
    if ($seen[$m.SamAccountName] -or !$m.Enabled -or !$m.Manager) {
      return $u
    }
    $u = $m
  }
}

function descend($managers) {
  # Составить список всех подчинённых для (нескольких) руководителей
  $seen = @{}
  [System.Collections.ArrayList]$result = @()
  [System.Collections.ArrayList]$q = $managers.ForEach({ Get-ADUser $_ -Properties directReports, mail, CanonicalName })
  while ($q.Count) {
    $u = $q[0]
    $q.RemoveAt(0)
    if ($seen[$u.SamAccountName]) { continue }
    $seen[$u.SamAccountName] = 1
    $null = $result.Add($u)
    $q.AddRange($u.
      directReports.
      ForEach({ Get-ADUser $_ -Properties directReports, mail, CanonicalName }).
      Where({ $_.Enabled }))
  }
  , $result
}

function buildPeers($u) {
  # Составить список, кого предупреждать о дне рождения пользователя
  [array]$ms = getManagers $u
  $ms = $ms.ForEach({ escalate $_ })
  $rcpt = descend $ms
  $id = (Get-ADUser $u).SamAccountName
  , $rcpt.Where({ $_.SamAccountName -ne $id })
}

function getMails($u) {
  $peers = buildPeers $u
  , $peers.ForEach({ $_.mail })
}

$Users.ForEach({
    $pz = buildPeers $_
    "[$(timeStamp)] Prepare to congratulate [$($_.SamAccountName)], $($pz.Count) recepients" | Out-File @Log
    if (!$pz) { return }
    $recepients = $pz |
    ForEach-Object { $_.CanonicalName + "`t<" + $_.mail + ">" } |
    Sort-Object | Out-String
    $recepients | Out-File @Log

    $body = @"
<html>
<head>
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<style>
body {
    text-align: center;
    font-family: Trebuchet MS, sans-serif;
}</style>
</head>
<body>
$fullday свой день рождения празднует
<br>
<big>
$($_.displayName)
</big>
<br>
$($_.title)
<br>
<i>
$($_.department)
</i>
<!--
$recepients
-->
</body>
</html>
"@
    $mail = @{
      Body       = $body
      BodyAsHtml = $true
      Subject    = "Поздравляем с днем рождения..."
      From       = 'serviceuxm@omzglobal.com'
      Bcc        = 'Stanislav.Ukolov@omzglobal.com'
      To         = $pz.ForEach({ $_.mail })
      SmtpServer = 'srvmail-ekbh5.omzglobal.com'
      Port       = '2525'
      Encoding   = 'UTF8'
      Credential = $cred
    }

    Send-MailMessage @mail
  })

# Тесты
<#
@(
  'P.Vazhenin'
  's.ukolov'
  'a.bystrov'
  'A.Shantarin'
  'lobza'
  'gretskaya'
  'e.ermakova'
  ).ForEach({
    $pz = getMails $_
    Write-Output "$($_):`t$($pz -join ', ')"
  })
#>
