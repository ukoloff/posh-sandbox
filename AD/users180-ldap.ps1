#
# Users inactive for 180 days
#

# https://blog.idera.com/database-tools/working-with-ldap-and-dates/
$date = (Get-Date).AddDays(-180)
$ticks = $date.ToFileTime()

$ldap = "(&(objectClass=user)(lastLogonTimestamp<=$ticks)(!(UserAccountControl:1.2.840.113556.1.4.803:=2)))"
$base = 'OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'
Get-ADUser -LDAPFilter $ldap -SearchBase $base -Properties * `
  | Select-Object -Property sAMAccountName, name, distinguishedName, lastLogonDate `
  | Out-GridView
  # | Export-Excel 'aaa.xlsx'
