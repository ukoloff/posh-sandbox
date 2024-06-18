####################################################################
# Автор: Сулев Илья						   #
# Дата: 02-05-2023 Версия: 1.0					   #
# Назначение: Скрипт заполения карточек AD (длительное отсутствие) #
####################################################################

#Запуск сценария
Clear-Host
Import-Module ActiveDirectory

#Журнал задания
$Log = New-Object Text.StringBuilder
#Логическое подразделение для поиска сотрудников в Active Directory
$SearchRoot="OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com"
#Парсим файл из 1С
$Users = Import-Csv "\\omzglobal.com\uxm\Exchange\employee_absence.csv" -Delimiter ";" -Encoding UTF8

#Запускаем цикл проверки и внесения изменений в карточки
Foreach ($User in $Users) {
#Задаем переменные
$Search = Get-ADuser -SearchBase $SearchRoot -Properties employeeID, displayName, extensionAttribute3, extensionAttribute4, extensionAttribute5, extensionAttribute6 -LDAPFilter "(&(objectClass=user)(employeeID=$($User.employeeID)))"
$Attribute6 = "$($User.extensionAttribute6)"
#Проверяем наличие учётной записи в Active Directory по employeeID
if($Search -eq $null)
 {
	$Text = "{0} : Пользователь отсутствует в каталоге Active Directory {1} {2}" -f (Get-Date).ToString(), $User.employeeID,$User.displayName
        $Log.AppendLine($Text) | Out-Null
 }
Else
 {	
	#Проверяем пустое ли поле аттрибут6, если пустое вычищаем предыдущее значение и добавляем переменные 3,4,5 если поле заполнено - добавляем переменные 3,4,5,6
	if($Attribute6 -eq "")
  {
		$Search | Set-ADUser -Add @{extensionAttribute3="$($User.extensionAttribute3)";extensionAttribute4="$($User.extensionAttribute4)";extensionAttribute5="$($User.extensionAttribute5)"}
		$Search | Set-ADUser -Clear "extensionAttribute6"
        	$Text = "{0} : Внесены изменения в карточку Active Directory для {1} {2}" -f (Get-Date).ToString(), $User.employeeID,$User.displayName
        	$Log.AppendLine($Text) | Out-Null
  }
 Else
  {
		$Search | Set-ADUser -Add @{extensionAttribute3="$($User.extensionAttribute3)";extensionAttribute4="$($User.extensionAttribute4)";extensionAttribute5="$($User.extensionAttribute5)";extensionAttribute6="$($User.extensionAttribute6)"}
        	$Text = "{0} : Внесены изменения в карточку Active Directory для {1} {2}" -f (Get-Date).ToString(), $User.employeeID,$User.displayName 
        	$Log.AppendLine($Text) | Out-Null
  }
 }
}

#Сохраняем лог и выводим отчёт в консоль
If($Log.ToString())
{
	$Log.ToString() | Out-File C:\Scripts\employee_absence.log
	Write-Host $Log -foregroundColor Green
}