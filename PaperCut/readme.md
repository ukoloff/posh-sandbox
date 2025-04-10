# Import PaperCut logs

## Setup Kerberos for PostgreSQL

+ См. также [Kerberos для TrueConf](trueconf.md)

```ini
# /etc/krb5.conf
[libdefaults]
default_realm = OMZGLOBAL.COM

[realms]
OMZGLOBAL.COM = {
 kdc = srvdc-ekbh5.omzglobal.com
 kdc = srvdc-ekbh6.omzglobal.com
 admin_server = srvdc-ekbh5.omzglobal.com
}
```

```powershell
Remove-ADComputer pg.ekb.ru
New-ADComputer pg.ekb.ru -Path 'OU=kerberos,OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com'
ktpass -princ postgres/pg.ekb.ru@OMZGLOBAL.COM -ptype KRB5_NT_SRV_HST -crypto ALL -mapuser 'OMZGLOBAL\pg.ekb.ru$' -pass +rndpass -out c:\temp\pg.keytab +answer
Get-ADComputer pg.ekb.ru -Properties servicePrincipalName,userPrincipalName,msDS-KeyVersionNumber
```
| Attribute              |  Value                                                                             |
|------------------------|------------------------------------------------------------------------------------|
| DistinguishedName      |  CN=pg.ekb.ru,OU=kerberos,OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com |
| DNSHostName            |                                                                                    |
| Enabled                |  True                                                                              |
| msDS-KeyVersionNumber  |  3                                                                                 |
| Name                   |  pg.ekb.ru                                                                         |
| ObjectClass            |  computer                                                                          |
| ObjectGUID             |  faf35921-0c69-427e-a836-49d48d44c451                                              |
| SamAccountName         |  pg.ekb.ru$                                                                        |
| servicePrincipalName   |  {postgres/pg.ekb.ru}                                                              |
| SID                    |  S-1-5-21-429210517-1838642026-1537874043-149424                                   |
| UserPrincipalName      |  postgres/pg.ekb.ru@OMZGLOBAL.COM                                                  |

## Switch to User account for Kerberos
```powershell
$Pass = -join (33..126 * 3 | Get-Random -Count 21 | % { [char]$_ })
New-ADUser pg.ekb.ru -Path 'OU=ekb.ru,OU=Service,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com' -PasswordNeverExpires $true -CannotChangePassword $true
ktpass +answer -princ postgres/pg.ekb.ru@OMZGLOBAL.COM -ptype KRB5_NT_PRINCIPAL -crypto ALL -mapuser 'OMZGLOBAL\pg.ekb.ru' -pass $Pass -out c:\temp\pg.keytab
Set-ADUser pg.ekb.ru -Enabled $true
Get-ADUser pg.ekb.ru -Properties servicePrincipalName,userPrincipalName,msDS-KeyVersionNumber
```
 Attribure            |  Value
----------------------|------------------------------------------------------------------------------------------
DistinguishedName     | CN=pg.ekb.ru,OU=ekb.ru,OU=Service,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com
Enabled               | True
GivenName             |
msDS-KeyVersionNumber | 2
Name                  | pg.ekb.ru
ObjectClass           | user
ObjectGUID            | 6a3b8c07-23a6-4882-814c-38960e22df26
SamAccountName        | pg.ekb.ru
servicePrincipalName  | {postgres/pg.ekb.ru}
SID                   | S-1-5-21-429210517-1838642026-1537874043-149619
Surname               |
UserPrincipalName     | postgres/pg.ekb.ru@OMZGLOBAL.COM

## See also

- [Настройка СУБД Postgresql для аутентификации пользователей через Active Directory][krb]
    + [Keytab and more...][2keytab]
    + [TrueConf]
    + [Openfire]
- JavaScript tables
    + [jsGrids]
    + [Tabulator]
    + [DevExtreme]

[krb]: https://www.opennet.ru/tips/3212_postgresql_kerberos_ldap_activedirectory_auth.shtml
[2keytab]: https://pro-ldap.ru/art/levintsa/20160420-ktpass/
[jsGrids]: https://jsgrids.statico.io/
[Tabulator]: https://tabulator.info/docs/6.2/quickstart#sources-download
[DevExtreme]: https://js.devexpress.com/jQuery/
[TrueConf]: https://trueconf.com/blog/knowledge-base/configuration-of-kerberos-sso-in-trueconf-server.html
[Openfire]: https://habr.com/ru/articles/181374/
