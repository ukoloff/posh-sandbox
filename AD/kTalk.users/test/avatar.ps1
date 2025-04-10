﻿#
# User sync omzgloal.com -> uzxm.ktalk.ru
#

$cred = Get-StoredCredential -Target ktalk:uzxm

# https://techibee.com/powershell/convert-system-security-securestring-to-plain-text-using-powershell/2599
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($cred.Password)
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$URI = "https://$($cred.UserName).ktalk.ru/api/Users"
$HTTP = @{
  Method = 'POST'
  Headers = @{
   'X-Auth-Token' = $PlainPassword
  }
}

$jpg = Join-Path (Split-Path $PSCommandPath -Parent) avatar.jpg

# https://learn.microsoft.com/ru-ru/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.5#5
$FileHeader = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new('form-data')
$FileHeader.Name = 'avatar'
$FileHeader.FileName = Split-Path -Leaf $jpg

$me = [ADSISearcher]"(&(objectCategory=User)(SAMAccountName=$env:USERNAME))"
$me = $me.FindOne().Properties
$adStream = New-Object IO.MemoryStream($me.jpegphoto[0], 0, $me.jpegphoto[0].Length)

# $FileStream = [System.IO.FileStream]::new($jpg, [System.IO.FileMode]::Open)
$FileContent = [System.Net.Http.StreamContent]::new($adStream)
$FileContent.Headers.ContentDisposition = $FileHeader
$FileContent.Headers.ContentType = [System.Net.Http.Headers.MediaTypeHeaderValue]::Parse('image/jpeg')

$MultipartContent = [System.Net.Http.MultipartFormDataContent]::new()
$MultipartContent.Add($FileContent)
$HTTP['Headers']['Content-Type'] = $MultipartContent.Headers.ContentType.ToString() -replace '"', ''
$body = $MultipartContent.ReadAsByteArrayAsync().GetAwaiter().GetResult()
# $FileStream.Close()
$adStream.Close()

Invoke-WebRequest -Uri "$URI/bef471d4-fe11-4c14-9fa3-5fbaf68246c7/avatar" -Body $body @HTTP
