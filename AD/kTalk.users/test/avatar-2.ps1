#
# User sync omzgloal.com -> uzxm.ktalk.ru
#
# Import-Module -Name CredentialManager -SkipEditionCheck

$cred = Get-StoredCredential -Target ktalk:uzxm

# https://techibee.com/powershell/convert-system-security-securestring-to-plain-text-using-powershell/2599
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($cred.Password)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$URI = "https://$($cred.UserName).ktalk.ru/api/Users"
$HTTP = @{
  Method  = 'POST'
  Headers = @{
    'X-Auth-Token' = $PlainPassword
  }
}

$jpg = Join-Path (Split-Path $PSCommandPath -Parent) avatar.jpg

$boundary = [guid]::NewGuid().Guid
$HTTP['Headers']['Content-Type'] = "multipart/form-data; boundary=$boundary"

[byte[]]$body = @(
  "--$boundary"
  "Content-Disposition: form-data; name=avatar; filename=$(Split-Path -Leaf $jpg)"
  "Content-Type: image/jpeg"
  ""
  [System.IO.File]::ReadAllBytes($jpg)
  ""
  "--$boundary--"
) | ForEach-Object {
  if ($_ -is [string]) {
    [System.Text.Encoding]::UTF8.GetBytes("$_`r`n")
  }
  else { $_ }
}

Invoke-WebRequest -Uri "$URI/bef471d4-fe11-4c14-9fa3-5fbaf68246c7/avatar" -Body $body @HTTP #-SkipHttpErrorCheck
