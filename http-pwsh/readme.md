# PowerShell over HTTP(S)

Скрипты на Веб-сервере IIS для удалённого запуска PowerShell

## Установка

На IIS:
- Установите ASP (не ASP.NET)
- Установите сертификат и настройте доступ по SSL
- Для папки [inetpub/pwsh](ad.ekb.ru/inetpub/pwsh) настройте доступ:
  + Сделайте её приложением
  + Включите Basic Authorization (Обычная проверка подлинности)
  + Отключите Anonymous Authorization (Анонимная проверка подлинности)
  + Отключите сохранение состояния для ASP/Свойства сеанса
  + Потребуйте использовать SSL

Для сервера приложений:
- Установите [Node.js] (Лучше LTS)
- Создайте службу PoSH ([reg](./ad.ekb.ru/inetpub/pwsh/service.reg)-файл), например, при помощи [nssm]
    ```cmd
    nssm install PoSH node
    nssm set PoSH AppParameters .
    nssm set PoSH AppDirectory C:\inetpub\pwsh
    ```
- Заведите учётную запись пользователя для запуска службы
- Настройте службу PoSH для запуска от этой учётной записи
- Запустите службу PoSH

[Node.js]:  https://nodejs.org/
[nssm]:     https://nssm.cc/
[CredSSP]: https://learn.microsoft.com/en-us/powershell/module/microsoft.wsman.management/enable-wsmancredssp?view=powershell-7.4

## Удалённый доступ к серверам

Exchange:
```powershell
$cred = New-Object System.Management.Automation.PSCredential('OMZGLOBAL\user', (ConvertTo-SecureString 'password' -AsPlainText -Force))
$sess = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://srvmail-ekbh5.omzglobal.com/PowerShell/ -Authentication Kerberos -Credential $cred
Invoke-Command -Session $sess -ScriptBlock {${PoSH}}
Remove-PSSession $sess
```

Skype for Business:
```powershell
$cred = New-Object System.Management.Automation.PSCredential('OMZGLOBAL\user', (ConvertTo-SecureString 'password' -AsPlainText -Force))
$sess = New-PSSession -ComputerName srvsfb-ekbh1.omzglobal.com -Credential $cred -Authentication CredSSP
Invoke-Command -Session $sess -ScriptBlock {${PoSH}}
Remove-PSSession $sess
```

### Включение [CredSSP] (для Skype for Windows)

- Enable CredSSP delegation (@`ad.ekb.ru`)
    ```powershell
    Enable-WSManCredSSP -Role "Client" -DelegateComputer "srvsfb-ekbh1.omzglobal.com"
    ```

- Enable CredSSP
    + @`srvsfb-ekbh1` требуется перезагрузка
      ```powershell
      Enable-WSManCredSSP -Role "Server"
      ```
    + @`ad.ekb.ru` сразу же
      ```powershell
      Connect-WSMan -ComputerName "srvsfb-ekbh1.omzglobal.com"
      Set-Item -Path "WSMan:\srvsfb-ekbh1.omzglobal.com\service\auth\credSSP" -Value $True
      ```
