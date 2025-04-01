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

$avatars = @{}

foreach ($user in $users) {
  if (!$user.email) { continue }
  $ad = ([ADSISearcher]"(&(objectCategory=User)(mail=$(quoteLDAP $user.email)))").FindAll()
  if ($ad.Count -ne 1) { continue }
  $ad = $ad[0].Properties
  if (!$user.avatarUrl -and $ad.jpegphoto) {
    $avatars[$user.key] = $ad.jpegphoto[0]
  }
}

$avatars
