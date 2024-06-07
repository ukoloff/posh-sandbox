$ldap = "((!(userAccountControl:1.2.840.113556.1.4.803:=2))(jpegPhoto=*))"
$base = 'OU=Цех №15,OU=Дирекция по производству,OU=Дирекция,OU=Users,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'
Get-ADUser -LDAPFilter $ldap -SearchBase $base -Properties * `
    | Out-GridView
