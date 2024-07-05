####################################################################################
# Автор: Сулев Илья						  		   #
# Дата: 18-01-2024 Версия: 1.1					  		   #
# Назначение: Скрипт получения ежемесячной статистики печати с принтеров	   #
####################################################################################

#Запуск сценария
Clear-Host
Import-Module ActiveDirectory

#Директории поиска журналов
$CSV1 = "C$\Program Files (x86)\PaperCut Print Logger\logs\csv\monthly\papercut-print-log-$(get-date -f yyyy-MM).csv"
$CSV2 = "C$\Program Files\PaperCut Print Logger\logs\csv\monthly\papercut-print-log-$(get-date -f yyyy-MM).csv"

#Шаблон таблицы
$Template = "\\omzglobal.com\uxm\Exchange\PrintStat\PSTools\Template.csv"

#Папка с результатами
$Path = "\\omzglobal.com\uxm\Exchange\PrintStat\Logs\Monthly"

#Логическое подразделение для поиска журналов печати хостов
$SearchRootPC="OU=Computers,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com"
#Для тестов
#$SearchRootPC="OU=TEST,OU=Computers,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com"
$Comps = Get-ADComputer -SearchBase $SearchRootPC -Filter {Enabled -eq "True" -and OperatingSystem -Like 'Windows*'} | sort name

#Лог выполнения задания по хостам
$Log = New-Object Text.StringBuilder

#Проверка существования журнала по шаблону
if (!(Test-Path -Path \\omzglobal.com\uxm\Exchange\PrintStat\Logs\Monthly\PrintLog-$(get-date -f MM-yyyy).csv)) {
Get-Content $Template -Encoding UTF8 | Out-File $Path\PrintLog-$(get-date -f MM-yyyy).csv -Force -Encoding UTF8
Write-Host "[ИНФО] Создан новый журнал в директории [\\$Path\PrintLog-$(get-date -f MM-yyyy).csv]" -foregroundColor Cyan
}

#Запускаем цикл формирования отчетов по рабочим станциям
ForEach ($Comp in $Comps) {
Try {
$CompName = $Comp.name.ToString()
#Проверка на наличие отключенных компьютеров. Если включен проверяем наличие каталога службы, если его нет то устанавливаем службу
		Write-Host "[ИНФО] В обработке комтьютер: [$CompName]" -foregroundColor Magenta
		if ((Test-WsMan -ComputerName $CompName -ErrorAction Ignore)) {
		if (!(Test-Path -Path "\\$CompName\C$\Program Files (x86)\PaperCut Print Logger") -And (!(Test-Path -Path "\\$CompName\C$\Program Files\PaperCut Print Logger"))) {
		\\omzglobal.com\uxm\Exchange\PrintStat\PSTools\psexec64.exe -accepteula -s -h \\$CompName -c -v \\omzglobal.com\uxm\Exchange\PrintStat\PSTools\papercut-print-logger.exe /NOICONS /VERYSILENT /SUPPRESSMSGBOXES /TYPE=secondary_print
		\\omzglobal.com\uxm\Exchange\PrintStat\PSTools\psexec.exe -accepteula -s -h \\$CompName -c -v \\omzglobal.com\uxm\Exchange\PrintStat\PSTools\papercut-print-logger.exe /NOICONS /VERYSILENT /SUPPRESSMSGBOXES /TYPE=secondary_print
	   	$Text = "{0} : [ИНФО!] Компьютер: [{1}] служба печати успешно установлена" -f (Get-Date).ToString(), $CompName
		$Log.AppendLine($Text) | Out-Null
} else {
		$Text = "{0} : [ИНФО!] Компьютер: [{1}] служба печати уже установлена, начат анализ журналов" -f (Get-Date).ToString(), $CompName
        	$Log.AppendLine($Text) | Out-Null
       		Write-Host "[ИНФО] Служба печати уже установлена, начат анализ журналов [$CompName]" -foregroundColor Cyan
		if (Test-Path -Path "\\$CompName\C$\Program Files (x86)\PaperCut Print Logger") {$PrintLog = (Get-Content -Path "\\$CompName\$CSV1" -ErrorAction SilentlyContinue | Select -Skip 1); $PrintLog = ($PrintLog | Select -Skip 1)} else {$PrintLog = (Get-Content -Path "\\$CompName\$CSV2" -ErrorAction SilentlyContinue | Select -Skip 1); $PrintLog = ($PrintLog | Select -Skip 1)}
		Write-Host "$PrintLog"
		$PrintLog | Out-File $Path\PrintLog-$(get-date -f MM-yyyy).csv -Encoding UTF8 -Append -Force
}} else {
		$Text = "{0} : [ОШИБКА!] Компьютер: [{1}] не отвечает на сетевые запросы" -f (Get-Date).ToString(), $CompName
        	$Log.AppendLine($Text) | Out-Null
       		Write-Host "[ОШИБКА] Компьютер: [$CompName] не отвечает..." -foregroundColor Cyan  
}} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [ОШИБКА!] Компьютер: [{1}] {2}" -f (Get-Date).ToString(), $CompName, $_.Exception.Message
    $Log.AppendLine($Text) | Out-Null
} Finally {
		Write-Host "[ИНФО] Анализ журналов печати компьютера [$CompName] завершен" -foregroundColor Green
		$Text = "{0} : [ИНФО!] Компьютер: [{1}] анализ журналов печати завершен" -f (Get-Date).ToString(), $CompName
        	$Log.AppendLine($Text) | Out-Null
		$Jobs = Get-Content -Path $Path\PrintLog-$(get-date -f MM-yyyy).csv -ErrorAction SilentlyContinue | Sort-Object -Unique -Descending
		$Jobs | Out-File $Path\PrintLog-$(get-date -f MM-yyyy).csv -Encoding UTF8 -Force
		Write-Host "[ИНФО] Данные о [$CompName] успешно сохранены в журнал" -foregroundColor Green
}}

#Логическое подразделение для поиска журналов печати серверов
$SearchRootSRV="OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com"
#Для тестов
#$SearchRootSRV="OU=TEST,OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com"
$Servers = Get-ADComputer -SearchBase $SearchRootSRV -Filter {Enabled -eq "True" -and OperatingSystem -Like 'Windows*'} | sort name


#Лог выполнения задания по серверам
$Log2 = New-Object Text.StringBuilder

#Запускаем цикл формирования отчетов по серверам
ForEach ($Server in $Servers) {
Try {
$ServerName = $Server.name.ToString()
#Проверка на наличие отключенных серверов. Если включен проверяем наличие каталога службы, если его нет то устанавливаем службу
		Write-Host "[ИНФО] В обработке сервер: [$ServerName]" -foregroundColor Magenta
		if ((Test-WsMan -ComputerName $ServerName -ErrorAction Ignore)) {
		if (!(Test-Path -Path "\\$ServerName\C$\Program Files (x86)\PaperCut Print Logger")) {
		\\omzglobal.com\uxm\Exchange\PrintStat\PSTools\psexec64.exe -accepteula -s -h \\$ServerName -c -v \\omzglobal.com\uxm\Exchange\PrintStat\PSTools\papercut-print-logger.exe /NOICONS /VERYSILENT /SUPPRESSMSGBOXES /TYPE=secondary_print
	   	$Text = "{0} : [ИНФО!] Сервер: [{1}] служба установлена данные обработаны" -f (Get-Date).ToString(), $ServerName
		$Log2.AppendLine($Text) | Out-Null
} else {
		$Text = "{0} : [ИНФО!] Сервер: [{1}] служба печати уже установлена, начат анализ журналов" -f (Get-Date).ToString(), $ServerName
        	$Log2.AppendLine($Text) | Out-Null
       		Write-Host "[ИНФО] Служба печати уже установлена, начат анализ журналов [$ServerName]" -foregroundColor Cyan
		if (Test-Path -Path "\\$ServerName\C$\Program Files (x86)\PaperCut Print Logger") {$PrintLog = (Get-Content -Path "\\$ServerName\$CSV1" -ErrorAction SilentlyContinue | Select -Skip 1); $PrintLog = ($PrintLog | Select -Skip 1)} else {$PrintLog = (Get-Content -Path "\\$ServerName\$CSV2" -ErrorAction SilentlyContinue | Select -Skip 1); $PrintLog = ($PrintLog | Select -Skip 1)}
		Write-Host "$PrintLog"
		$PrintLog | Out-File $Path\PrintLog-$(get-date -f MM-yyyy).csv -Encoding UTF8 -Append -Force
}} else {
		$Text = "{0} : [ОШИБКА!] Сервер: [{1}] не отвечает на сетевые запросы" -f (Get-Date).ToString(), $ServerName
        	$Log2.AppendLine($Text) | Out-Null
       		Write-Host "[ОШИБКА] Сервер: [$ServerName] не отвечает..." -foregroundColor Cyan
}} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [ОШИБКА!] Сервер: [{1}] {2}" -f (Get-Date).ToString(), $ServerName, $_.Exception.Message
    $Log2.AppendLine($Text) | Out-Null
} Finally {
		Write-Host "[ИНФО] Анализ журналов печати сервера [$ServerName] завершен" -foregroundColor Green
		$Text = "{0} : [ИНФО!] Сервер: [{1}] анализ журналов печати завершен" -f (Get-Date).ToString(), $ServerName
        	$Log2.AppendLine($Text) | Out-Null
		$Jobs = Get-Content -Path $Path\PrintLog-$(get-date -f MM-yyyy).csv -ErrorAction SilentlyContinue | Sort-Object -Unique -Descending
		$Jobs | Out-File $Path\PrintLog-$(get-date -f MM-yyyy).csv -Encoding UTF8 -Force
		Write-Host "[ИНФО] Данные о [$ServerName] успешно сохранены в журнал" -foregroundColor Green
}}   

#Чистим дубликаты и сохраняем результат
$Jobs = Get-Content -Path $Path\PrintLog-$(get-date -f MM-yyyy).csv -ErrorAction SilentlyContinue | Sort-Object -Unique -Descending
$Jobs | Out-File $Path\PrintLog-$(get-date -f MM-yyyy).csv -Encoding UTF8 -Force
Write-Host "[ИНФО] Все данные успешно сохранены" -foregroundColor Cyan

#Сохраняем лог скрипта по хостам
If($Log.ToString()) {
	$Log.ToString() | Out-File "$Path\history-$(get-date -f dd-MM-yyyy).log" -Append
}

#Сохраняем лог скрипта по серверам
If($Log2.ToString()) {
	$Log2.ToString() | Out-File "$Path\history-$(get-date -f dd-MM-yyyy).log" -Append
}