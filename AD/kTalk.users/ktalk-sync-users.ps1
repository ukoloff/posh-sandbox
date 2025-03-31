#
# User sync omzgloal.com -> uzxm.ktalk.ru
#

$cred = Get-StoredCredential -Target ktalk:uzxm

# https://techibee.com/powershell/convert-system-security-securestring-to-plain-text-using-powershell/2599
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($cred.Password)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$URI = "https://$($cred.UserName).ktalk.ru/api/Users"
$Headers = @{
  Headers = @{
   'X-Auth-Token' = $PlainPassword
  }
}
$q = Invoke-WebRequest -Uri "$URI/scan?includeDisabled=true" @Headers
$u = (ConvertFrom-Json $q.Content).users
$u | Out-GridView
