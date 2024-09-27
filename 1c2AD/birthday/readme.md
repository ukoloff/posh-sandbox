# Уведомления о днях рождения

Два вида уведомлений:

- [bday.ps1](bday.ps1) - поздравление виновнику торжества
- [before_bday.ps1](before_bday.ps1) - уведомление (за 3 дня) коллег

## Пароль для отправки почты

Для отправки почты используется почтовый ящик
<serviceuxm@omzglobal.com>,
пароль к нему должен храниться в
Диспетчере учётных данных Windows
для пользователя System.

Чтобы сохранить его туда,
можно использовать команды:
```powershell
psexec -sid powershell  # Запустить PowerShell от пользователя System
Install-Module -Name CredentialManager
$cred = Get-Credential  # Ввести учётную запись OMZGLOBAL\serviceuxm и пароль
New-StoredCredential -Target serviceuxm@omzglobal.com -Credentials $cred -Persist LocalMachine  # Сохранить
```

## Установка в качестве ежедневного задания

С правами администратора:
```powershell
.\bday.ps1 -install
.\before_bday.ps1 -install
```
