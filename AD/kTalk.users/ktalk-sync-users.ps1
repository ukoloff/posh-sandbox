#
# User sync omzgloal.com -> uzxm.ktalk.ru
#

$cred = Get-StoredCredential -Target ktalk:uzxm

# https://techibee.com/powershell/convert-system-security-securestring-to-plain-text-using-powershell/2599
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($cred.Password)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$URI = "https://$($cred.UserName).ktalk.ru/api/Users"
$HTTP = @{
  Headers = @{
    'X-Auth-Token' = $PlainPassword
    'Content-Type' = 'application/json'
  }
}
$q = Invoke-WebRequest -Uri "$URI/scan?includeDisabled=true" @HTTP
$users = (ConvertFrom-Json $q.Content).users

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

$updates = foreach ($user in $users) {
  if (!$user.email -or $user.mobilePhone) { continue }
  $ad = ([ADSISearcher]"(&(objectCategory=User)(mail=$(quoteLDAP $user.email)))").FindAll()
  if ($ad.Count -ne 1) { continue }
  $ad = $ad[0].Properties
  if (!$user.avatarUrl -and $ad.jpegphoto) {
    $avatars[$user.key] = $ad.jpegphoto[0]
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

if ($updates.Count) {
  $body = $updates | ConvertTo-Json -Compress
  $body = [System.Text.Encoding]::UTF8.GetBytes($body)
  Invoke-WebRequest -Uri $URI @HTTP -Method POST -Body $body
}
