# Контур Толк

Синхронизация реквизитов пользователей
`omzgloal.com` $\to$ `uzxm.ktalk.ru`

## Credentials

Сохранить реквизиты доступа к
[Talk API]
```powershell
# Install-Module -Name CredentialManager
$cred = Get-Credential
New-StoredCredential -Target ktalk:uzxm -Credentials $cred -Persist LocalMachine
# От имени пользователя SYSTEM
psexec -si powershell New-StoredCredential -Target ktalk:uzxm -Credentials (Get-Credential) -Persist LocalMachine
```

[Talk API]: https://developer.kontur.ru/doc/talk.public.api
