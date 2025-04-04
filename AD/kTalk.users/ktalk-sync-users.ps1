#
# User sync omzgloal.com -> uzxm.ktalk.ru
#
param( # Для самостоятельной установки запуска по расписанию
  [switch]$install,
  [switch]$remove
)

#
# Самостоятельная установка / удаление в Планировщик заданий
#
if ($install) {
  $me = Split-Path $PSCommandPath -Leaf
  $dir = Split-Path $PSCommandPath -Parent
  $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir
  $Trigger = New-ScheduledTaskTrigger -At 07:30 -Daily -RandomDelay 00:07:00
  $tRep = New-ScheduledTaskTrigger -Once -At 07:30 -RepetitionDuration 12:00:00 -RepetitionInterval 00:42:00 -RandomDelay 00:07:00
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


$cred = Get-StoredCredential -Target ktalk:uzxm

# https://techibee.com/powershell/convert-system-security-securestring-to-plain-text-using-powershell/2599
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($cred.Password)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$URI = "https://$($cred.UserName).ktalk.ru/api/Users"
$HTTP = @{
  Headers         = @{
    'X-Auth-Token' = $PlainPassword
    'Content-Type' = 'application/json'
  }
  UseBasicParsing = $true
}
$q = Invoke-WebRequest -Uri "$URI/scan" @HTTP
[array]$users = (ConvertFrom-Json $q.Content).users
"Found Talk users:`t$($users.Count)"

function quoteLDAP ($s) {
  foreach ($q in [char[]]"\()*`0") {
    $s = $s.Replace([string]$q, '\' + ([int]$q).ToString('X2'))
  }
  $s
}

$fields = @{
  firstname  = 'givenname'
  surname    = 'sn'
  patronymic = 'middlename'
  post       = 'title'
  department = 'department'
  innerPhone = 'othertelephone'
}

$avatars = @{}
$kill = @{}

[array]$updates = foreach ($user in $users) {
  if (!$user.email -or $user.mobilePhone) { continue }
  $ad = ([ADSISearcher]"(&(objectCategory=User)(mail=$(quoteLDAP $user.email)))").FindAll()
  if ($ad.Count -ne 1) { continue }
  $ad = $ad[0].Properties
  if (!$user.avatarUrl) {
    if ($ad.jpegphoto) {
      $avatars[$user.key] = $ad.jpegphoto[0]
    }
    elseif ($ad.thumbnailphoto) {
      $avatars[$user.key] = $ad.thumbnailphoto[0]
    }
  }
  if ($ad.useraccountcontrol[0] -band 2) {
    $kill[$user.key] = $ad.cn[0]
  }
  $update = @{}
  $diff = 0
  foreach ($it in $fields.GetEnumerator()) {
    $a = $user.($it.Name)
    $b = $null
    if ($ad) {
      $b = $ad.($it.Value)
      if ($b) {
        $b = $b[0]
      }
    }
    if ($a -ne $b) { $diff++ }
    $update[$it.Name] = $b
  }
  if (!$diff) { continue }
  $update['userKey'] = $user.key
  $update
}

if ($kill.Count) {
  "Blocking Talk users:`t$($kill.Count)"
  $body = ConvertTo-Json -InputObject @{disabled = $true } -Compress
  foreach ($it in $kill.GetEnumerator()) {
    # Old API: https://kontur.renote.team/doc/gmVrwgTNW
    $q = Invoke-WebRequest -Uri "$URI/$($it.Key)/permissions" -Method PUT @HTTP -Body $body
  }
}

$HTTP['Method'] = 'POST'

if ($updates.Count) {
  "Updating Talk users:`t$($updates.Count)"

  $body = ConvertTo-Json -Compress -InputObject $updates
  $body = [System.Text.Encoding]::UTF8.GetBytes($body)
  $q = Invoke-WebRequest -Uri $URI @HTTP -Body $body
}

if ($avatars.Count) {
  "Adding avatars:`t$($avatars.Count)"

  foreach ($it in $avatars.GetEnumerator()) {
    $fh = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new('form-data')
    $fh.Name = 'avatar'
    $fh.FileName = 'photo.jpg'
    $mm = New-Object IO.MemoryStream($it.Value, 0, $it.Value.Length)
    $fc = [System.Net.Http.StreamContent]::new($mm)
    $fc.Headers.ContentDisposition = $fh
    $fc.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse('image/jpeg')
    $mc = [System.Net.Http.MultipartFormDataContent]::new()
    $mc.Add($fc)
    $HTTP['Headers']['Content-Type'] = $mc.Headers.ContentType.ToString() -replace '"', ''
    $body = $mc.ReadAsByteArrayAsync().GetAwaiter().GetResult()
    $mm.Close()
    $q = Invoke-WebRequest -Uri "$URI/$($it.Name)/avatar" -Body $body @HTTP
  }
}

"Found Talk users:`t$($users.Count)"
"Blocked Talk users:`t$($kill.Count)"
"Updated Talk users:`t$($updates.Count)"
"Added avatars:`t$($avatars.Count)"
