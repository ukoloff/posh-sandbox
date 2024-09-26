# Автоматическая раскатка баз из резервных копий

[Скрипт](dbclone.ps1)

## Prerequisites

- Установите модуль `SimplySql`
- Дать права пользователю `System` на SQL (`sysadmin`?)
- Создать задание
    ```powershell
    .\dbclone.ps1 -install
    ```
