####################################################################
# Автор: Сулев Илья						   #
# Дата: 10-05-2023 Версия: 1.0					   #
# Назначение: Скрипт заполнения карточек AD (изменение атрибутов)  #
####################################################################

#Запуск сценария
Clear-Host
Import-Module ActiveDirectory

#Журнал задания
$Log = New-Object Text.StringBuilder

#Журнал незаполненных атрибутов начальник
$warn = New-Object Text.StringBuilder

#Логическое подразделение для поиска сотрудников в Active Directory
$SearchRoot = "OU=uxm,OU=MS,DC=omzglobal,DC=com"

#Парсим файл из 1С
$Users = Import-Csv "\\omzglobal.com\uxm\Exchange\employee_changes.csv" -Delimiter ";" -Encoding UTF8
# $Users = Import-Csv "c:\Scripts\test\employee_changes.csv" -Delimiter ";" -Encoding UTF8

#Запускаем цикл проверки и внесения изменений в карточки
Foreach ($User in $Users) {
#Задаем переменные из CSV
	$employeeID = $User.employeeID.ToString()
	$Manager = $User.manager.ToString()
	$title=$User.title.ToString()
	$departmentNumber=$User.departmentNumber.ToString()
	$department=$User.department.ToString() -replace '/.*', ''
	$extensionAttribute1=$User.extensionAttribute1.ToString()
	$extensionAttribute2=$User.extensionAttribute2.ToString()

	$Search = Get-ADUser -SearchBase $SearchRoot -Properties * -Filter {(employeeID -eq $employeeID) -and (Enabled -eq "True")}
if($Search -eq $null)
 {
	#Заносим в журнал информацию об отсутствии пользователя в каталоге AD
	$Text = "{0} : [ОШИБКА!] Пользователь отсутствует в каталоге Active Directory {1} {2}" -f (Get-Date).ToString(), $User.employeeID,$User.displayName
        $Log.AppendLine($Text) | Out-Null
 }
Else
 {
	#Актуализируем начальника если он задан
        if ($Manager -ne "") {
	$UserManager = Get-ADUser -SearchBase $SearchRoot -Properties * -Filter {(displayName -eq $Manager)}
	$Search | Set-ADUser -manager $UserManager
        }
	Else {
	$Search | Set-ADUser -Clear manager
	#Заносим в журнал предупреждение об отсутствии записи о начальнике
	$Text = "{0} : [ВНИМАНИЕ!] Не заполнено поле начальник для {1} {2}" -f (Get-Date).ToString(), $User.employeeID,$User.displayName
        $warn.AppendLine($Text) | Out-Null }
	#Актуализируем поля день рождения пол и номер отдела
	$Search | Set-ADUser -Replace @{extensionAttribute1=$extensionAttribute1}
	$Search | Set-ADUser -Replace @{extensionAttribute2=$extensionAttribute2}
	$Search | Set-ADUser -Replace @{departmentNumber=$departmentNumber}
	#Актуализируем структурное подразделение и должность
	#$Search | Set-ADUser -Department $department
	#$Search | Set-ADUser -Title $title
	$Search | Set-ADUser -Replace @{department=$department}
	$Search | Set-ADUser -Replace @{title=$title}
	#Ведем журнал успешных изменений
        $Text = "{0} : [УСПЕХ!] Внесены изменения в карточку Acrive Directory для {1} {2}" -f (Get-Date).ToString(), $User.employeeID,$User.displayName
        $Log.AppendLine($Text) | Out-Null
 }    
}
#Сохраняем в журнал и выводим на консоль последние 50 строк
If($Log.ToString()) {
	$Log.ToString() | Out-File C:\Scripts\employee_changes.log -Append
	Get-Content -Path C:\Scripts\employee_changes.log -Tail 50
}
#Сохраняем журнал предупреждений
If($warn.ToString()) {
	$warn.ToString() | Out-File C:\Scripts\employee_changes_no_manager.log
}