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

## Credential Manager vs Powershell 7
```powershell
Import-Module -Name CredentialManager -UseWindowsPowerShell
Import-Module -Name CredentialManager -SkipEditionCheck
```

[Talk API]: https://developer.kontur.ru/doc/talk.public.api
