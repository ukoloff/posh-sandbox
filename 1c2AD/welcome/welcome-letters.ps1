#
# Рассылка серии приветственных писем новому сотруднику
#
param( # Для самостоятельной установки запуска по расписанию
  [switch]$install,
  [switch]$remove
)

$newEmployees = '\\omzglobal.com\uxm\Exchange\employee_mail.csv'

$newEmployees = Join-Path (Split-Path $PSCommandPath -Parent) test\users.csv

#
# Самостоятельная установка / удаление в Планировщик заданий
#
if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir
  $Trigger = New-ScheduledTaskTrigger -At 07:30 -Weekly -RandomDelay 00:05:00 -DaysOfWeek Monday, Tuesday, Wednesday, Thursday, Friday
  $tRep = New-ScheduledTaskTrigger -Once -At 07:30 -RepetitionDuration 10:00:00 -RepetitionInterval 00:10:00
  $Trigger.Repetition = $tRep.Repetition
  $Task = New-ScheduledTask -Action $Action -Trigger $Trigger
  Register-ScheduledTask -TaskName $me -TaskPath uxm -InputObject $Task -User "System" -Force
  exit
}

if ($remove) {
  $me = Split-Path $PSCommandPath -Leaf
  Unregister-ScheduledTask -TaskName $me -TaskPath '\uxm\' -Confirm:$false
  exit
}


$db = Join-Path (Split-Path $PSCommandPath -Parent) .db
$db = New-Item $db -Force -ItemType Directory
$db = Join-Path $db welcome.sq3
Open-SQLiteConnection $db
$isNew = (Get-Item $db).Length -eq 0
if ($isNew) {
  $sql = Get-Content -Raw (Join-Path (Split-Path $PSCommandPath -Parent) ddl.sql)
  $n = Invoke-SqlUpdate $sql
}

function textMessage($path, $u) {
  if (!(Test-Path $path -PathType Leaf)) {
    return
  }
  $body = [System.IO.File]::ReadAllLines($path)
  $subject = $body[0].Trim()
  $body = ($body | Select-Object -Skip 1) -join "`n"
  $body = $body.Trim()
  $io = ($u.givenName + ' ' + $u.middleName).Trim()
  $body = "Здравствуйте, $io!`n`n$body"
  return @{
    Body    = $body
    Subject = $subject
  }
}

function htmlMessage($path, $u) {
  if (!(Test-Path $path -PathType Container)) {
    return
  }
  $subject = (Get-Content -Raw (Join-Path $path subject.txt)).Trim()
  $body = (Get-Content -Raw (Join-Path $path body.html)).Trim()
  [array]$az = Join-Path $path files |
  Get-ChildItem -File |
  ForEach-Object { $_.FullName }

  return @{
    BodyAsHtml  = $true
    Body        = $body
    Subject     = $subject
    Attachments = $az
  }
}

foreach ($user in Import-Csv $newEmployees -Delimiter ';' -Encoding UTF8) {
  $n = Invoke-SqlUpdate @"
    Insert Or Ignore Into
      users(user)
    Values(@u)
"@ -Parameters @{u = $user.sAMAccountName }
}

if ($isNew) {
  $n = Invoke-SqlUpdate @"
    Update users
    Set ztime = CURRENT_TIMESTAMP
"@
}

[array]$users = Invoke-SqlQuery @"
  Select
    id, user,
    (select max(stage) from sent where sent."user" = users.id) as stage
  From users
  Where
    ztime is Null
"@ -WarningAction Ignore

foreach ($user in $users) {
  $u = Get-ADUser $user.user -Properties mail, middleName
  if (!$u.Enabled -or !$u.mail) {
    continue
  }
  if ($user.stage -eq [System.DBNull]::Value) {
    # Первое письмо посылаем тут же
    $stage = 1
  }
  else {
    # Последующие письма на следующий день
    $ok = Invoke-SqlScalar @"
      Select
        date(ctime) < date(CURRENT_TIMESTAMP)
      From sent
      Where sent."user" = @id
      Order by stage Desc
      Limit 1
"@ -Parameters @{id = $user.id }
    if (!$ok) {
      continue
    }
    $stage = $user.stage + 1
  }

  $path = Join-Path (Split-Path $PSCommandPath -Parent) "body\$stage"
  $msg = htmlMessage $path $u
  if (!$msg) {
    $msg = textMessage "$path.txt" $u
  }
  if (!$msg) {
    $n = Invoke-SqlUpdate @"
      Update users
      Set ztime = CURRENT_TIMESTAMP
      Where id = @id
"@ -Parameters @{id = $user.id }
    continue
  }

  $msg += @{
    From       = 'serviceuxm@omzglobal.com'
    To         = $u.mail
    Bcc        = 'Stanislav.Ukolov@omzglobal.com'
    SmtpServer = 'srvmail-ekbh5.omzglobal.com'
    Port       = '2525'
    Encoding   = 'UTF8'
    Credential = $cred
  }
  Send-MailMessage @msg

  $n = Invoke-SqlUpdate @"
    Insert Into
      sent(user, stage)
    Values(@id, @stage)
"@ -Parameters @{id = $user.id; stage = $stage }
}

Close-SqlConnection
