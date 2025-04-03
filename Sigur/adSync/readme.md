# AD -> Sigur

Самописная синхронизация операторов из AD в Сигур

Для целей авторизации (SSO)

## Очистка

После  запуска
[ad-sigur-sync.ps1](ad-sigur-sync.ps1)
можно __однократно__ запустить
+ [drop-users.sql](drop-users.sql)
для удаления ненужных пользователей

## Setup

```powershell
Install-Module -Name SimplySql
```

```powershell
# Store Credentials:

Install-Module CredentialManager

$cred = Get-Credential
New-StoredCredential -Target mysql:SKUD -Credentials $cred -Persist LocalMachine
```

If running as System, store credentials for that account
