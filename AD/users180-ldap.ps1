# https://blog.idera.com/database-tools/working-with-ldap-and-dates/
$date = (Get-Date).AddDays(-180)
$ticks = $date.ToFileTime()

$ldap = "(&(objectClass=user)(lastLogonTimestamp<=$ticks))"
Get-ADUser -LDAPFilter $ldap -Properties * | Select-Object -Property name, enabled, lastLogonTimestamp, dn | Out-GridView
