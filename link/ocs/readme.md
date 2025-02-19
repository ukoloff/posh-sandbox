# OCS host

Замена хоста для OCS Inventory
для клиентов
с 10.33.10.72
на ocs.ekb.ru

## Способы запуска Task из GPO

Компьютер / Настройка / Панель управления / Задания / Создать немедленную задачу

+ `-f \\service\Soft\Scripts\ocs-patch.ps1`
+ `Get-Content -Raw \\service\Soft\Scripts\ocs-patch.ps1 | Invoke-Expression` почему-то работает без `-c`

## Политики

* `EKBH-Workstations` {40E9B6E4-ED16-4B6B-B1AB-C51B71BD3766}
* `EKBH-WinRM` {E48C4483-5F61-4306-A969-AAC6CF6FEE4B}
* `UMZ-Common` {8DC850A0-0B05-4526-AA92-2E2A1599D730}

Всё - в `\\OMZGLOBAL.COM\SYSVOL\omzglobal.com\Policies\`,
задания - в `Machine\Preferences\ScheduledTasks\ScheduledTasks.xml`

XML-файлы вполне можно копировать между папками GPO.
