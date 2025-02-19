@ECHO OFF
mode con:cols=130 lines=40
color 1A
:: V 1.0 2019.12.27
chcp 1251 >NUL
TITLE ��������� OCS Agent

:: ��������� �������� OCS
TASKKILL /IM OCS* /T /F
:: ���������� ������ OCS
net stop "OCS Inventory Service"
sc stop "OCS Inventory Service"
net stop "OCS INVENTORY"
sc stop "OCS INVENTORY"
:: ������� ������ OCS
wmic product where name=�OCSInventory*" call uninstall /nointeractive

@cls
@echo off
chcp 1251 >NUL
:: ����������� IP DNS �� ������ � ��������� dos cp866 DNS-������� (�ࢥ��) � ���������� � ������ .5
::for /f "tokens=2 delims=:(" %%d in ('ipconfig /all^|FIND /I "DNS-"^|FIND /I ".5"') do set IPDNS=%%d
::set Server=http://%IPDNS: =%:3455/ocsinventory

::�������� ������ ������� �� ������ ���������� ������ ����� ��������� ��� dns
for /f "tokens=2 delims=:(" %%d in ('ipconfig /all^|FIND /I "IP"^|FINDSTR /c:"192.168." /c:"172.16."') do (
:: ��� ��� ip ������ ������ ������� :~1.10% ��� �� �������� ��������� �� ������
for /f "tokens=1-4 delims=. " %%k in ("%%d") do set IP=%%k.%%l.%%m
)
set Server=http://10.33.10.72:80/ocsinventory

::������ ������������ ������
::set /P inventar=������� ����������� ����� ������ �� � ������� Enter!:
::set tag=%inventar%

:: ����������� ������ Windows
::For /f "tokens=4" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName^|FIND /I "Windows"') do (
For /f "tokens=4,5" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName^|FIND /I "ProductName"') do (
if /i %%b==XP (goto :WindowsXP) else (if /i %%a==Vista (goto :WindowsVista) else if /i %%a==7 (goto :Windows7) else if /i %%a==8 (goto :Windows8) else if /i %%a==8.1 (goto :Windows8.1) else if /i %%a==10 (goto :Windows10) else if /i %%a==Server (goto :Windows10) else (goto :end)))

:WindowsXP
::���������� ����������� � ������ ������� ������ ���� %~dp0 � ��������� ����� ��������� � �����������
Set xOS=x64
If "%PROCESSOR_ARCHITECTURE%"=="x86" If Not Defined PROCESSOR_ARCHITEW6432 Set xOS=x86
If %xOS%==x86 (start "" "%~dp0OCSNG-Windows-Agent-2.1.1.1-xp-2003r2\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY) Else (start "" "%~dp0OCSNG-Windows-Agent-2.1.1.1-xp-2003r2\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY)
goto :end

:WindowsVista
::���������� ����������� � ������ ������� ������ ���� %~dp0 � ��������� ����� ��������� � �����������
Set xOS=x64
If "%PROCESSOR_ARCHITECTURE%"=="x86" If Not Defined PROCESSOR_ARCHITEW6432 Set xOS=x86
If %xOS%==x86 (start "" "%~dp0OCSNG-Windows-Agent-2.4.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY) Else (start "" "%~dp0OCS-Windows-Agent-2.6.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY)
goto :end

:Windows7
::���������� ����������� � ������ ������� ������ ���� %~dp0 � ��������� ����� ��������� � �����������
Set xOS=x64
If "%PROCESSOR_ARCHITECTURE%"=="x86" If Not Defined PROCESSOR_ARCHITEW6432 Set xOS=x86
If %xOS%==x86 (start "" "%~dp0OCSNG-Windows-Agent-2.4.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY) Else (start "" "%~dp0OCS-Windows-Agent-2.6.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY)
goto :end

:Windows8
::���������� ����������� � ������ ������� ������ ���� %~dp0 � ��������� ����� ��������� � �����������
Set xOS=x64
If "%PROCESSOR_ARCHITECTURE%"=="x86" If Not Defined PROCESSOR_ARCHITEW6432 Set xOS=x86
If %xOS%==x86 (start "" "%~dp0OCSNG-Windows-Agent-2.4.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY) Else (start "" "%~dp0OCS-Windows-Agent-2.6.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY)
goto :end

:Windows8.1
::���������� ����������� � ������ ������� ������ ���� %~dp0 � ��������� ����� ��������� � �����������
Set xOS=x64
If "%PROCESSOR_ARCHITECTURE%"=="x86" If Not Defined PROCESSOR_ARCHITEW6432 Set xOS=x86
If %xOS%==x86 (start "" "%~dp0OCSNG-Windows-Agent-2.4.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY) Else (start "" "%~dp0OCS-Windows-Agent-2.6.0.0\OCS-NG-Windows-Agent-Setup.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY)
goto :end

:Windows10
::���������� ����������� � ������ ������� ������ ���� %~dp0 � ��������� ����� ��������� � �����������
Set xOS=x64
If "%PROCESSOR_ARCHITECTURE%"=="x86" If Not Defined PROCESSOR_ARCHITEW6432 Set xOS=x86
If %xOS%==x86 (start "" "%~dp0OCS-Windows-Agent-2.10.1.0\OCS-Windows-Agent-Setup-x86.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY) Else (start "" "%~dp0OCSNG-Windows-Agent-2.10.1.0\OCS-Windows-Agent-Setup-x64.exe" /S /NOSPLASH /NOW /SSL=0 /SERVER=http://10.33.10.72:80/ocsinventory /DEBUG=0 /TAG="GHM" /NO_SYSTRAY)
goto :end

:end

::��� XP ������ Client 4061 � Agent-2.1.1.1
::��� Vista - 10 ����� 2.4.0.0 32 ���
::��� 64 bit Vista - 10 ����� 2.6.0.0