# 1C RAS

Создание служб RAS для 1C

## Firewall Rule

```powershell
New-NetFirewallRule -DisplayName "1C RAS" -Direction Inbound -Program "%ProgramFiles%\1cv8\8.3.25.1336\bin\ras.exe" -Action Allow
```

## See also

+ [RAS@infostart]
+ [RAS@Windows]
+ [1C@Zabbix]

[RAS@Windows]: https://sysadminchik.ru/str/liversi_result.php?search_id=141
[RAS@infostart]: https://infostart.ru/1c/articles/810752/
[1C@Zabbix]: https://github.com/slothfk/1c_zabbix_template_ce/
