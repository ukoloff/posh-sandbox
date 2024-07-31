# Kerberos for TrueConf

Настройка Kerberos для TrueConf

+ В настройках LDAP <https://trueconf.ekb.ru/admin/ldap/settings/>
  выбрать `Автоматическое определение` (контроллера домена)

```powershell
Remove-ADComputer trueconf.ekb.ru
New-ADComputer trueconf.ekb.ru -Path 'OU=kerberos,OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com'
$Pass = -join (33..126 * 3 | Get-Random -Count 21 | % { [char]$_ })
ktpass +answer -princ trueconf/trueconf.ekb.ru@OMZGLOBAL.COM -ptype KRB5_NT_SRV_HST -crypto ALL -mapuser 'OMZGLOBAL\trueconf.ekb.ru$' -pass $Pass -out c:\temp\trueconf.keytab
Get-ADComputer trueconf.ekb.ru -Properties servicePrincipalName,userPrincipalName,msDS-KeyVersionNumber
$Pass
```
| Attribure              |  Value                                                                                   |
|------------------------|------------------------------------------------------------------------------------------|
| DistinguishedName      |  CN=trueconf.ekb.ru,OU=kerberos,OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com |
| DNSHostName            |                                                                                          |
| Enabled                |  True                                                                                    |
| msDS-KeyVersionNumber  |  4                                                                                       |
| Name                   |  trueconf.ekb.ru                                                                         |
| ObjectClass            |  computer                                                                                |
| ObjectGUID             |  c7093f29-f6b1-4832-bb7f-d8b7779b27e6                                                    |
| SamAccountName         |  trueconf.ekb.ru$                                                                        |
| servicePrincipalName   |  {trueconf/trueconf.ekb.ru}                                                              |
| SID                    |  S-1-5-21-429210517-1838642026-1537874043-149426                                         |
| UserPrincipalName      |  trueconf/trueconf.ekb.ru@OMZGLOBAL.COM                                                  |
