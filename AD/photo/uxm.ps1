#
# Save photos to files
#
$src = Split-Path ($MyInvocation.MyCommand.Source) -Parent
$dst = Join-Path $src 'jpeg'

$ldap = "((!(userAccountControl:1.2.840.113556.1.4.803:=2))(jpegPhoto=*))"
$base = 'OU=uxm,OU=MS,DC=omzglobal,DC=com'
Get-ADUser -LDAPFilter $ldap -SearchBase $base -Properties * `
| % {
  # https://github.com/chrisdee/Scripts/blob/master/PowerShell/Working/AD/GetADUserThumbnailPhotos.ps1
  $fname = Join-Path $dst ($_.SamAccountName + '.jpg')
  [System.Io.File]::WriteAllBytes($fname, $_.jpegPhoto[0])
}
