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
- Создайте службу PoSH, например, при помощи [nssm]
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
