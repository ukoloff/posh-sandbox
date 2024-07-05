####################################################################################
# Автор: Сулев Илья						  		   #
# Дата: 19-05-2023 Версия: 1.0					  		   #
# Назначение: Скрипт распространения модуля Windows Update на сервера          	   #
####################################################################################

#Запуск сценария
Clear-Host
Import-Module ActiveDirectory

#Результаты задания
$Log = New-Object Text.StringBuilder
$Success = New-Object Text.StringBuilder

#Задаем переменные, если что-то будет меняться - достаточно изменить эти строки

#Находим все сервера
$Servers = Get-ADComputer -SearchBase "OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com" -Filter {Enabled -eq "True"} -Properties name |sort name| select name

#Запускаем цикл проверки и установки модуля
ForEach ($Server in $Servers) {
Try {
$CompName = $Server.name.ToString()
#Проверка на наличие отключенных компьютеров. Если включен устанавливаем пакет Windows Update
    if (!(Test-Connection -ComputerName $CompName -Count 2 -Quiet)) {
	$Text = "{0} : [ОШИБКА!] Сервер: [{1}] не отвечает на сетевые запросы" -f (Get-Date).ToString(), $CompName
        $Log.AppendLine($Text) | Out-Null
        Write-Host "$CompName не отвечает..." -foregroundColor Magenta
    } else {
		if (Test-Path -Path "\\$CompName\C$\ProgramData\WU1") {
        	Write-Host "Пакет Windows Update уже установлен! $CompName" -foregroundColor Magenta
		$Text = "{0} : [ИНФО!] Сервер: [{1}] Пакет Windows Update уже установлен ранее" -f (Get-Date).ToString(), $CompName
		$Success.AppendLine($Text) | Out-Null
        	}
        	else {
		Write-Host "Установка пакета на $CompName" -foregroundColor Magenta
		\\omzglobal.com\uxm\Exchange\skud\PSTools\psexec64.exe -acceptelua -s -h \\$CompName cmd /c netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow  enable=yes remoteip=any profile=any
		Invoke-Command -ComputerName $CompName -ScriptBlock {Set-ExecutionPolicy RemoteSigned -force}
		Invoke-Command -ComputerName $CompName -ScriptBlock {Set-PSRepository -Name PSGallery -InstallationPolicy Trusted}
		Invoke-Command -ComputerName $CompName -ScriptBlock {Install-Module PSwindowsUpdate -Confirm:$false; Enable-WURemoting}
        	New-Item -Path "\\$CompName\C$\ProgramData\WU1"
		$Version = Get-Package -Name PSWindowsUpdate
		$Ver = $Version.version.ToString()	
			if (Test-Path -Path "\\$CompName\C$\ProgramData\WU1") {
			$Text = "{0} : [УСПЕХ!] Сервер: [{1}] Пакет Windows Update Ver. $Ver успешно установлен" -f (Get-Date).ToString(), $CompName
			$Success.AppendLine($Text) | Out-Null
			}
			Else {
			$Text = "{0} : [ОШИБКА!] Сервер: [{1}] Пакет Windows Update не установлен" -f (Get-Date).ToString(), $CompName
        		$Log.AppendLine($Text) | Out-Null
			}
		}
	   }
} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [ОШИБКА!] Сервер: [{1}] Ошибка: {2} " -f (Get-Date).ToString(), $CompName, $_.Exception.Message
    $Log.AppendLine($Text) | Out-Null
} Finally {
Write-Host "[Info] Установка пакета Windows Update Ver. $Ver на сервер [$CompName] завершена" -foregroundColor Magenta
}
}

#Сохраняем лог успеха
If($Success.ToString()) {
	$Success.ToString() | Out-File "C:\Scripts\servers_success.log" -Append
}

#Сохраняем лог ошибок
If($Log.ToString()) {
	$Log.ToString() | Out-File "C:\Scripts\servers_error.log" -Append
}