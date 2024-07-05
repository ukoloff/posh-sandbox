##################################################
# Автор: Сорвин Илья Mail: sorvin@ekb.ru
# Дата: 31-01-2020 Версия: 1.3
# Назначение: Скрипт заполения карточек AD
##################################################
Clear-Host
Import-Module ActiveDirectory

$Users = Import-Csv \\omzglobal.com\uxm\Exchange\employee_absence.csv -Delimiter ";" -Encoding UTF8
$Log = New-Object Text.StringBuilder

Foreach ($User in $Users) {
	Try {
        Get-ADUser -SearchBase "OU=uxm,OU=MS,DC=omzglobal,DC=com" -LDAPFilter "(&(employeeID=$($User.employeeID))(displayName=$($User.displayName)))" -Properties employeeID, displayName, extensionAttribute3, extensionAttribute4, extensionAttribute5, extensionAttribute6 |
             Set-ADUser -Add @{extensionAttribute3=$User.extensionAttribute3; extensionAttribute4=$User.extensionAttribute4; extensionAttribute5=$User.extensionAttribute5; extensionAttribute6=$User.extensionAttribute6;}

        Get-ADUser -SearchBase "OU=uxm,OU=MS,DC=omzglobal,DC=com" -LDAPFilter "(&(employeeID=$($User.employeeID))(displayName=$($User.displayName)))" -Properties employeeID, displayName, extensionAttribute3, extensionAttribute4, extensionAttribute5, extensionAttribute6 |
             Set-ADUser -Replace @{extensionAttribute3=$User.extensionAttribute3; extensionAttribute4=$User.extensionAttribute4; extensionAttribute5=$User.extensionAttribute5; extensionAttribute6=$User.extensionAttribute6;}

        $Text = "{0} : Всесены изменения для {1}" -f (Get-Date).ToString(), $User 
        $Log.AppendLine($Text) | Out-Null    
	} Catch {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        $StatusText = "{0} : Произошла ошибка Message: {1} ItemName: {2}" -f (Get-Date).ToString(), $_.Exception.Message, $_.Exception.ItemName
        $Log.AppendLine($StatusText) | Out-Null
    } Finally {
        Write-Host $Log -foregroundColor Green
    }
}

If($Log.ToString()) {
	$Log.ToString() | Out-File C:\Scripts\employee_absence.log
}