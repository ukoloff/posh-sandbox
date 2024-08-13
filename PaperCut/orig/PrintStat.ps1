####################################################################################
# Автор: Сулев Илья						  		   #
# Дата: 05-01-2024 Версия: 1.0					  		   #
# Назначение: Скрипт получения статистики печати с принтеров		 	   #
####################################################################################

#Запуск сценария
Clear-Host
Import-Module ActiveDirectory

#Глубина поиска событий в журнале печати в сутках
$Days = "30" 

#Папка с результатами
$Path = "\\omzglobal.com\uxm\Exchange\PrintStat"

#Логическое подразделение для поиска журналов печати
$SearchRootPC="OU=Computers,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com"
#Для тестов
#$SearchRootPC="OU=TEST,OU=Computers,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com"
$Comps = Get-ADComputer -SearchBase $SearchRootPC -Filter {Enabled -eq "True" -and OperatingSystem -Like 'Windows*'} | sort name

#Результат задания по хостам
$Log = New-Object Text.StringBuilder

#Запускаем цикл формирования отчетов по рабочим станциям
ForEach ($Comp in $Comps) {
Try {
$CompName = $Comp.name.ToString()
#Проверка на наличие отключенных компьютеров. Если включен получаем события журналов
		Write-Host "[ИНФО] В обработке комтьютер: [$CompName]" -foregroundColor Magenta
		if ((Test-WsMan -ComputerName $CompName -ErrorAction Ignore )) {Invoke-Command -ComputerName $CompName {
		netsh advfirewall firewall set rule group="Remote Event Log Management" new enable=yes} -ErrorAction SilentlyContinue
		\\omzglobal.com\uxm\Exchange\skud\PSTools\psexec64.exe -accepteula -s -h \\$CompName cmd /c wevtutil.exe sl Microsoft-Windows-PrintService/Operational /enabled:true
		Get-WinEvent -ComputerName $CompName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue -FilterHashTable @{LogName="Microsoft-Windows-PrintService/Operational"; ID=307; StartTime=(Get-Date).AddDays(-$Days)} | Select-object -Property TimeCreated, @{label='UserName';expression={$_.properties[2].value}},@{label='HostName';expression={$_.properties[3].value}}, @{label='Document';expression={$_.properties[1].value}}, @{label='PrinterName';expression={$_.properties[4].value}}, @{label='Pages';expression={$_.properties[7].value}} | Export-Csv -Path "$Path\Print_Audit-$(get-date -f dd-MM-yyyy).csv" –NoTypeInformation -Encoding UTF8 -Append
	   	$Text = "{0} : [ИНФО!] Компьютер: [{1}] данные обработаны" -f (Get-Date).ToString(), $CompName
		$Log.AppendLine($Text) | Out-Null
} else {
		$Text = "{0} : [ОШИБКА!] Компьютер: [{1}] не отвечает на сетевые запросы" -f (Get-Date).ToString(), $CompName
        	$Log.AppendLine($Text) | Out-Null
        	Write-Host "[ОШИБКА] $CompName не отвечает..." -foregroundColor Cyan   
}} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [ОШИБКА!] Компьютер: [{1}] {2}" -f (Get-Date).ToString(), $CompName, $_.Exception.Message
    $Log.AppendLine($Text) | Out-Null
} Finally {
Write-Host "[Info] Анализ журналов печати компьютера [$CompName] завершен" -foregroundColor Green
}}

$SearchRootSRV="OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com"
#Для тестов
#$SearchRootSRV="OU=TEST,OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com"
$Servers = Get-ADComputer -SearchBase $SearchRootSRV -Filter {Enabled -eq "True" -and OperatingSystem -Like 'Windows*'} | sort name


#Результат задания по серверам
$Log2 = New-Object Text.StringBuilder

#Запускаем цикл формирования отчетов по серверам
ForEach ($Server in $Servers) {
Try {
$ServerName = $Server.name.ToString()
#Проверка на наличие отключенных серверов. Если включен получаем события журналов
		Write-Host "[ИНФО] В обработке сервер: [$ServerName]" -foregroundColor Magenta
		if ((Test-WsMan -ComputerName $ServerName -ErrorAction Ignore )) {Invoke-Command -ComputerName $ServerName -ScriptBlock {
		netsh advfirewall firewall set rule group="Remote Event Log Management" new enable=yes} -ErrorAction SilentlyContinue
		\\omzglobal.com\uxm\Exchange\skud\PSTools\psexec64.exe -accepteula -s -h \\$ServerName cmd /c wevtutil.exe sl Microsoft-Windows-PrintService/Operational /enabled:true
		Get-WinEvent -ComputerName $ServerName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue -FilterHashTable @{LogName="Microsoft-Windows-PrintService/Operational"; ID=307; StartTime=(Get-Date).AddDays(-$Days)} | Select-object -Property TimeCreated, @{label='UserName';expression={$_.properties[2].value}},@{label='HostName';expression={$_.properties[3].value}}, @{label='Document';expression={$_.properties[1].value}}, @{label='PrinterName';expression={$_.properties[4].value}}, @{label='Pages';expression={$_.properties[7].value}} | Export-Csv -Path "$Path\Print_Audit-$(get-date -f dd-MM-yyyy).csv" –NoTypeInformation -Encoding UTF8 -Append
	   	$Text = "{0} : [ИНФО!] Сервер: [{1}] данные обработаны" -f (Get-Date).ToString(), $ServerName
		$Log2.AppendLine($Text) | Out-Null
} else {
		$Text = "{0} : [ОШИБКА!] Сервер: [{1}] не отвечает на сетевые запросы" -f (Get-Date).ToString(), $ServerName
        	$Log.AppendLine($Text) | Out-Null
       		Write-Host "[ОШИБКА] $ServerName не отвечает..." -foregroundColor Cyan
}} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [ОШИБКА!] Сервер: [{1}] {2}" -f (Get-Date).ToString(), $ServerName, $_.Exception.Message
    $Log2.AppendLine($Text) | Out-Null
} Finally {
Write-Host "[Info] Анализ журналов печати сервера [$ServerName] завершен" -foregroundColor Green
}}   


#Сохраняем лог по хостам
If($Log.ToString()) {
	$Log.ToString() | Out-File "$Path\history-$(get-date -f dd-MM-yyyy).log" -Append
}

#Сохраняем лог по серверам
If($Log2.ToString()) {
	$Log2.ToString() | Out-File "$Path\history-$(get-date -f dd-MM-yyyy).log" -Append
}