# PowerShell over HTTP(S)

Скрипты на Веб-сервере IIS для удалённого запуска PowerShell

## Установка

На IIS:
- Установите ASP (не ASP.NET)
- Установите сертификат и настройте доступ по SSL
- На папку [inetpub/pwsh](ad.ekb.ru/inetpub/pwsh) настройте доступ:
  + Включите Basic Authorization (Обычная проверка подлинности)
  + Отключите Anonymous Authorization (Анонимная проверка подлинности)

Для сервера приложений:
- Установите [Node.js] (Лучше LTS)
- Заведите учётную запись пользователя для запуска службы

[Node.js]: https://nodejs.org/
