# Автоматическая раскатка баз из резервных копий

[Скрипт](dbclone.ps1)

## Файлы

- [dbclone-fs.ps1](dbclone-fs.ps1) - ищет бэкапы в папках
- [dbclone.ps1](dbclone.ps1) - ищет бэкапы в журнале SQL-сервера
- `*.ps1` - тестовые скрипты

## Prerequisites

- Установите модуль `SimplySql`
- Дать права пользователю `System` на SQL (`sysadmin`?)
- Создать задание
    ```powershell
    .\dbclone.ps1 -install
    ```
