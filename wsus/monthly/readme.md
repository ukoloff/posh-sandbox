# WSUS Monthly

День сисадмина -
третья суббота месяца -
скачивание и установка обновлений Windows
без перезагрузки

## Setup

Запускается как Scheduled Task ежедневно

+ Установить скрипт и архив в общедоступную сетевую папку
+ Создать подпапку `Logs`
+ Дать права на запись в неё группе `Domain Computers`
+ Создать политику
    + Компьютер / Настройка / Параметры Панели Управления / Назначенные задания
    + Запланированная задача / Ежедневно / `NT AUTHORITY\System`

[Пример настройки](ScheduledTasks.xml) задания
<details>
<summary>
Лежит в 
</summary>
\\srvdc-ekbh5.omzglobal.com\SysVol\omzglobal.com\Policies\{18E26CA4-3418-47CD-AF1D-0B96A9C96367}\Machine\Preferences\ScheduledTasks
</details>
