# OCS host

Замена хоста для OCS Inventory
для клиентов
с 10.33.10.72
на ocs.ekb.ru

## Способы запуска Task из GPO

Компьютер / Настройка / Панель управления / Задания / Создать немедленную задачу

+ `-f \\service\Soft\Scripts\ocs-patch.ps1`
+ `Get-Content -Raw \\service\Soft\Scripts\ocs-patch.ps1 | Invoke-Expression` почему-то работает без `-c`

