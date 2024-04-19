# https://blog.idera.com/database-tools/working-with-ldap-and-dates/
$date = (Get-Date).AddDays(-180)
$ticks = $date.ToFileTime()

$ldap = "(lastLogonTimestamp<=$ticks)"
$base = 'OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'
Get-ADComputer -LDAPFilter $ldap -SearchBase $base -Properties * | Select-Object -Property samaccountname, name, distinguishedname, lastLogonTimestamp, lastLogon | Out-GridView
