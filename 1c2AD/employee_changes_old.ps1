##################################################
# Автор: Борис Доронин
# Переписал Сорвинскую хуйню, которая крашелась если значения переменной выходили за пределы.
# Потому что все яйца положил в одну корзину, нахуя так делать, ошибки потом хуй отловишь :)
# Назначение: Скрипт заполения карточек AD
##################################################
Clear-Host
Import-Module ActiveDirectory

# Импортируем CSV разбиваем по точки с запятой
$Users = Import-Csv \\omzglobal.com\uxm\Exchange\employee_changes.csv -Delimiter ";" -Encoding UTF8
$Log = New-Object Text.StringBuilder

#Write-Output $User $Users  -foregroundColor Green

# Идем по списку форичем
Foreach ($User in $Users) {
	Try {
# присваиваем переменные и сразу приводим все значения к строковому типу
# этого не было у Сорвина кстати)
        $UserSearch = $User.displayName.ToString()
        $UserManager = $User.manager.ToString()
		$employeeID = $User.employeeID.ToString()
		$title=$User.title.ToString()
		$departmentNumber=$User.departmentNumber.ToString()
		$department=$User.department.ToString()
		$extensionAttribute1=$User.extensionAttribute1.ToString()
		$extensionAttribute2=$extensionAttribute2

		# Будем отдельно заполнять каждый атрибут.
		# Актуализируем начальника
		Get-ADUser -SearchBase "OU=uxm,OU=MS,DC=omzglobal,DC=com" -Filter {(displayName -eq $UserSearch)} -Properties * | Set-ADUser -Replace @{manager = $UserManager;}
		# Актуализируем день рождения
		Get-ADUser -SearchBase "OU=uxm,OU=MS,DC=omzglobal,DC=com" -Filter {(displayName -eq $UserSearch)} -Properties * | Set-ADUser -Replace @{extensionAttribute1 = $extensionAttribute1;}
		# Актуализируем отдел
		Get-ADUser -SearchBase "OU=uxm,OU=MS,DC=omzglobal,DC=com" -Filter {(displayName -eq $UserSearch)} -Properties * | Set-ADUser -Replace @{departmentNumber = $departmentNumber;}
		Get-ADUser -SearchBase "OU=uxm,OU=MS,DC=omzglobal,DC=com" -Filter {(displayName -eq $UserSearch)} -Properties * | Set-ADUser -Replace @{department = $department;}

        $Text = "{0} : Всесены изменения для {1}" -f (Get-Date).ToString(), $User 
        $Log.AppendLine($Text) | Out-Null    
		#$Log.AppendLine($Text) | Out-File employee_changes.log -Append    
	} Catch {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        $StatusText = "{0} : Произошла ошибка Message: {1} ItemName: {2}" -f (Get-Date).ToString(), $_.Exception.Message, $_.Exception.ItemName
        $Log.AppendLine($StatusText) | Out-Null
		#$Log.AppendLine($StatusText) | Out-File employee_changes.log -Append
    } Finally {
        Write-Host $Log -foregroundColor Green
		#Write-Host | Out-File employee_changes.log -Append
		
    }
}

If($Log.ToString()) {
	#$Log.ToString() | Out-File C:\Scripts\employee_changes.log -Append
	$Log.ToString() | Out-File employee_changes.log -Append
}