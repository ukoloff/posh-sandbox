@ECHO OFF
mode con:cols=130 lines=40
color 1A
:: V 1.0 2019.12.27
chcp 1251 >NUL
TITLE Установка OCS Agent

:: Завершить процессы OCS
TASKKILL /IM OCS* /T /F
:: Остановить службу OCS
net stop "OCS Inventory Service"
sc stop "OCS Inventory Service"
net stop "OCS INVENTORY"
sc stop "OCS INVENTORY"
:: Удалить старую OCS
wmic product where name=”OCSInventory*" call uninstall /nointeractive

@cls
@echo off
chcp 1251 >NUL
:: Определение IP DNS от Прокси в кодировке dos cp866 DNS-серверы (бҐаўҐал) и содержание в строке .5
::for /f "tokens=2 delims=:(" %%d in ('ipconfig /all^|FIND /I "DNS-"^|FIND /I ".5"') do set IPDNS=%%d
::set Server=http://%IPDNS: =%:3455/ocsinventory

::Получаем просто подсеть из начала совпадения сторки более правильно чем dns
for /f "tokens=2 delims=:(" %%d in ('ipconfig /all^|FIND /I "IP"^|FINDSTR /c:"192.168." /c:"172.16."') do (
:: Так как ip разной длинны обрезка :~1.10% нам не подходит разбиваем на октеты
for /f "tokens=1-4 delims=. " %%k in ("%%d") do set IP=%%k.%%l.%%m
)
set Server=http://10.33.10.72:80/ocsinventory

::Запрос Инвентарного номера
::set /P inventar=Введите Инвентарный Номер вашего ПК и нажмите Enter!:
::set tag=%inventar%

:: Определение версию Windows
::For /f "tokens=4" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName^|FIND /I "Windows"') do (
For /f "tokens=4,5" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName^|FIND /I "ProductName"') do (
if /i %%b==XP (goto :WindowsXP) else (if /i %%a==Vista (goto :WindowsVista) else if /i %%a==7 (goto :Windows7) else if /i %%a==8 (goto :Windows8) else if /i %%a==8.1 (goto :Windows8.1) else if /i %%a==10 (goto :Windows10) else if /i %%a==Server (goto :Windows10) else (goto :end)))

:WindowsXP
::Определяем разрядность и откуда запущен батник путь %~dp0 и запускаем тихую установку с параметрами
Set xOS=x64
If "%PROCESSOR_ARCHITECTURE%"=="x86" If Not Defined PROCESSOR_ARCHITEW6432 Set xOS=x86
If %xOS%==x86 (start "" "%~dp0OCSNG-Windows-Agent-2.1.1.1-xp-2003r2\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY) Else (start "" "%~dp0OCSNG-Windows-Agent-2.1.1.1-xp-2003r2\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY)
goto :end

:WindowsVista
::Определяем разрядность и откуда запущен батник путь %~dp0 и запускаем тихую установку с параметрами
Set xOS=x64
If "%PROCESSOR_ARCHITECTURE%"=="x86" If Not Defined PROCESSOR_ARCHITEW6432 Set xOS=x86
If %xOS%==x86 (start "" "%~dp0OCSNG-Windows-Agent-2.4.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY) Else (start "" "%~dp0OCS-Windows-Agent-2.6.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY)
goto :end

:Windows7
::Определяем разрядность и откуда запущен батник путь %~dp0 и запускаем тихую установку с параметрами
Set xOS=x64
If "%PROCESSOR_ARCHITECTURE%"=="x86" If Not Defined PROCESSOR_ARCHITEW6432 Set xOS=x86
If %xOS%==x86 (start "" "%~dp0OCSNG-Windows-Agent-2.4.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY) Else (start "" "%~dp0OCS-Windows-Agent-2.6.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY)
goto :end

:Windows8
::Определяем разрядность и откуда запущен батник путь %~dp0 и запускаем тихую установку с параметрами
Set xOS=x64
If "%PROCESSOR_ARCHITECTURE%"=="x86" If Not Defined PROCESSOR_ARCHITEW6432 Set xOS=x86
If %xOS%==x86 (start "" "%~dp0OCSNG-Windows-Agent-2.4.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY) Else (start "" "%~dp0OCS-Windows-Agent-2.6.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY)
goto :end

:Windows8.1
::Определяем разрядность и откуда запущен батник путь %~dp0 и запускаем тихую установку с параметрами
Set xOS=x64
If "%PROCESSOR_ARCHITECTURE%"=="x86" If Not Defined PROCESSOR_ARCHITEW6432 Set xOS=x86
If %xOS%==x86 (start "" "%~dp0OCSNG-Windows-Agent-2.4.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY) Else (start "" "%~dp0OCS-Windows-Agent-2.6.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY)
goto :end

:Windows10
::Определяем разрядность и откуда запущен батник путь %~dp0 и запускаем тихую установку с параметрами
Set xOS=x64
If "%PROCESSOR_ARCHITECTURE%"=="x86" If Not Defined PROCESSOR_ARCHITEW6432 Set xOS=x86
If %xOS%==x86 (start "" "%~dp0OCS-Windows-Agent-2.10.1.0\OCS-Windows-Agent-Setup-x86.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY) Else (start "" "%~dp0OCSNG-Windows-Agent-2.10.1.0\OCS-Windows-Agent-Setup-x64.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY)
goto :end

:end

::Для XP Клиент Client 4061 и Agent-2.1.1.1
::Для Vista - 10 Агент 2.4.0.0 32 бит
::Для 64 bit Vista - 10 Агент 2.6.0.0