####################################################################################
# Автор: Сулев Илья						  		   #
# Дата: 15-05-2023 Версия: 1.2					  		   #
# Назначение: Скрипт распространения ПО СКУД SIGUR и интеграции через AD 	   #
####################################################################################

#Запуск сценария
Clear-Host
Import-Module ActiveDirectory

#Результаты задания
$Log = New-Object Text.StringBuilder
$Result = New-Object Text.StringBuilder
$Success = New-Object Text.StringBuilder

#Задаем переменные, если что-то будет меняться - достаточно изменить эти строки

#Группа безопасности СКУД
$Group = "srvskud-ekbh1"
#Группа для тестов
#$Group = "skud"
#Логическое подразделение для поиска сотрудников в Active Directory
$SearchRoot="OU=MS,DC=omzglobal,DC=com"
#Парсим группу безопасности в AD и получаем список пользователей
$Users = Get-ADGroupMember $Group -Recursive | sort name | Select SamAccountName, distinguishedName, name
#Папка с ПО и результатами
$Path = "\\omzglobal.com\uxm\Exchange\skud"

#Запускаем цикл формирования отчетов
ForEach ($User in $Users) {
	$CN = $User.distinguishedName.ToString()
	$Name = $User.SamAccountName.ToString()
	$FullName = $User.name.ToString()
	$Search = Get-ADUser -SearchBase $SearchRoot -Properties * -Filter {SamAccountName -like $Name -and Enabled -eq "True"}
#Проверка на наличие отключенных учетных записей
if($Search -eq $null)
 {
	#Заносим в журнал информацию об отключенной записи
	$Text = "{0} : [ВНИМАНИЕ!] Пользователь отключен в каталоге Active Directory {1}({2})" -f (Get-Date).ToString(), $FullName, $Name
        $Log.AppendLine($Text) | Out-Null
 }
Else
 {
#Приводим DN к необходимому для ПО SIGUR виду, сам параметр задается в центре администрирования сигур на вкладе пользователя Active Directory
#Выясняем имя компьютера и устанавливаем клиент, если он еще не был установлен. Если пользователь сидит с одной учетки на разных ПК - установка произойдет на все эти ПК.
$Comps = Get-ADComputer -SearchBase $SearchRoot -Filter {ManagedBy -eq $CN}
ForEach ($Comp in $Comps) {
Try {
$CompName = $Comp.name.ToString()
#Проверка на наличие отключенных компьютеров. Если включен устанавливаем ПО клиент SIGUR
    if (!(Test-Connection -ComputerName $CompName -Count 2 -Quiet)) {
	$Text = "{0} : [ОШИБКА!] Компьютер: [{1}] Пользователь: [{2}] Компьютер не отвечает на сетевые запросы" -f (Get-Date).ToString(), $CompName, $FullName
        $Log.AppendLine($Text) | Out-Null
        Write-Host "$CompName пользователя $FullName не отвечает..." -foregroundColor Magenta
    } else {
        	if (Test-Path -Path "\\$CompName\C$\ProgramData\Microsoft\Windows\Start Menu\Programs\СКУД Sigur") {
        	Write-Host " Клиент уже установлен! $CompName для $FullName" -foregroundColor Magenta
		$Text = "{0} : [ИНФО!] Компьютер: [{1}] Пользователь: [{2}] Клиент SIGUR уже установлен ранее" -f (Get-Date).ToString(), $CompName, $FullName
		$Success.AppendLine($Text) | Out-Null
        	}
        	else {
		Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Software\Sysinternals' -Name 'EulaAccepted' -Value 1
        	Write-Host "Установка клиента на $CompName для $FullName" -foregroundColor Magenta
        	&\\omzglobal.com\uxm\Exchange\skud\PSTools\psexec64.exe -acceptelua -s -h \\$CompName -c -v "\\omzglobal.com\uxm\Exchange\skud\Client\setup-1.1.1.53.s.exe" /S
        	\\omzglobal.com\uxm\Exchange\skud\PSTools\psexec64.exe -s -h \\$CompName cmd /c xcopy /C /Y "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\СКУД Sigur\Клиент.lnk" "C:\Users\$Name\Desktop"
        	Copy-Item -Path "$Path\Client\.tcgui.cfg" -Destination "\\$CompName\c$\Users\$Name\.tcgui.cfg"
			if (Test-Path -Path "\\$CompName\C$\ProgramData\Microsoft\Windows\Start Menu\Programs\СКУД Sigur") {
			$Text = "{0} : [УСПЕХ!] Компьютер: [{1}] Пользователь: [{2}] Клиент SIGUR успешно установлен" -f (Get-Date).ToString(), $CompName, $FullName
			$Success.AppendLine($Text) | Out-Null
			}
			Else {
			$Text = "{0} : [ОШИБКА!] Компьютер: [{1}] Пользователь: [{2}] Клиент не установлен" -f (Get-Date).ToString(), $CompName, $FullName
        		$Log.AppendLine($Text) | Out-Null
			}
		}
	   }
} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [ОШИБКА!] Компьютер: [{1}] Пользователь: [{2}] {3}" -f (Get-Date).ToString(), $CompName, $FullName, $_.Exception.Message
    $Log.AppendLine($Text) | Out-Null
} Finally {
Write-Host "[Info] Установка клиента для $FullName на компьютер [$CompName] завершена" -foregroundColor Magenta
}
}
	$DNDC = $User.distinguishedName.ToString()
	$DC = ",DC=omzglobal,DC=com"
	$DN = $DNDC.Trimend($DC)
	$Result.AppendLine($DN) | Out-Null
 }       
}

#Сохраняем результат задания в файл
If($Result.ToString()) {
	$Result.ToString() | Out-File "$Path\DN.txt"
}

#Сохраняем лог успеха
If($Success.ToString()) {
	$Success.ToString() | Out-File "$Path\success.log" -Append
}

#Сохраняем лог ошибок
If($Log.ToString()) {
	$Log.ToString() | Out-File "$Path\error.log" -Append
}