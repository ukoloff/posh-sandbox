$ldap = "(&(objectClass=user)(!(userAccountControl:1.2.840.113556.1.4.803:=2))(!(userAccountControl=512)))"
$base = 'OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'
Get-ADUser -LDAPFilter $ldap -SearchBase $base -Properties * `
  | Select-Object -Property sAMAccountName, userAccountControl, name, distinguishedName `
  | Sort-object userAccountControl `
  | Out-GridView
  # | Export-Excel 'aaa.xlsx'

  # SCRIPT (Запуск логон скрипта)	0x0001	1
  # ACCOUNTDISABLE (Учетная запись отключена)	0x0002	2
  # HOMEDIR_REQUIRED (Требуется домашняя папка)	0x0008	8
  # LOCKOUT (Учетная запись заблокирована)	0x0010	16
  # PASSWD_NOTREQD (Пароль не требуется)	0x0020	32
  # PASSWD_CANT_CHANGE (Запретить смену пароля пользователем)	0x0040	64
  # ENCRYPTED_TEXT_PWD_ALLOWED (Хранить пароль, используя обратимое шифрование)	0x0080	128
  # TEMP_DUPLICATE_ACCOUNT (учетная запись пользователя, чья основная учетная запись хранится в другом домене)	0x0100	256
  # NORMAL_ACCOUNT (Учетная запись по умолчанию. Обычная активная учетная запись)	0x0200	512
  # INTERDOMAIN_TRUST_ACCOUNT	0x0800	2048
  # WORKSTATION_TRUST_ACCOUNT	0x1000	4096
  # SERVER_TRUST_ACCOUNT	0x2000	8192
  # DONT_EXPIRE_PASSWORD (Срок действия пароля не ограничен)	0x10000	65536
  # MNS_LOGON_ACCOUNT	0x20000	131072
  # SMARTCARD_REQUIRED (Для интерактивного входа в сеть нужна смарт-карта)	0x40000	262144
  # TRUSTED_FOR_DELEGATION	0x80000	524288
  # NOT_DELEGATED	0x100000	1048576
  # USE_DES_KEY_ONLY	0x200000	2097152
  # DONT_REQ_PREAUTH (Не требуется предварительная проверка подлинности Kerberos)	0x400000	4194304
  # PASSWORD_EXPIRED (Срок действия пароля пользователя истек)	0x800000	8388608
  # TRUSTED_TO_AUTH_FOR_DELEGATION	0x1000000	16777216
  # PARTIAL_SECRETS_ACCOUNT	0x04000000	67108864

#    544 = 512 + 32
#  66048 = 65536 + 512
#  66080 = 65536 + 512 + 32
#
