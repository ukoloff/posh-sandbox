# https://blog.idera.com/database-tools/working-with-ldap-and-dates/
$date = (Get-Date).AddDays(-180)
$ticks = $date.ToFileTime()

$ldap = "(&(objectClass=user)(lastLogonTimestamp<=$ticks)(!(UserAccountControl:1.2.840.113556.1.4.803:=2)))"
Get-ADUser -LDAPFilter $ldap | Out-GridView
# -Properties * | Select-Object -Property name, enabled, lastLogonTimestamp, dn | Out-GridView
