# Обновление Компас

Запуск планируется через:
Компьютер / Политики / Конфигурация Windows / Сценарии / Автозагрузка / PowerShell

## Версии:

 GUID | ПО
---|---
`{05AB476A-CCCF-456F-B37F-43DDD7AE5F72}` | КОМПАС-3D v21 x64
`{DC8BA2AE-D46B-49CA-BB21-A0871AB2991B}` | КОМПАС-3D Viewer v21 x64
`{F344813A-7FCF-4E35-BB23-7019F5010D42}` | КОМПАС-3D Viewer v23 x64

## Узнать версию Компас

Реестр: `HKLM\SOFTWARE\ASCON\KOMPAS-3D\21\ProductVersion`

Удалённо:
```powershell
Invoke-Command -ComputerName uxm00536 -ScriptBlock { ls HKLM:\SOFTWARE\ASCON\KOMPAS-3D }
Invoke-Command -ComputerName uxm00536 -ScriptBlock { ls "HKLM:\SOFTWARE\ASCON\KOMPAS-3D Viewer" }
```
