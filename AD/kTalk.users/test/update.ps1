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
   'Content-Type' = 'application/json'
  }
}

$update = @(@{
  userKey = 'bef471d4-fe11-4c14-9fa3-5fbaf68246c7'
  firstname = 'Станислав'
  surname = 'Уколов'
  patronymic = 'Сергеевич'
  post = 'Ведущий системный администратор'
  department = 'Группа поддержки ИТ-инфракструктуры'
  innerPhone = '7876'
})
$body = ConvertTo-Json -Compress $update
$body = [System.Text.Encoding]::UTF8.GetBytes($body)
$q = $null
$q = Invoke-WebRequest -Uri $URI @Headers -Method POST -Body $body
$q
