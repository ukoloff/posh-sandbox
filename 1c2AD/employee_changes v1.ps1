##################################################
# Автор: Сорвин Илья Mail: sorvin@ekb.ru
# Дата: 18-01-2020 Версия: 1.1
# Назначение: Скрипт заполения карточек AD
##################################################
Clear-Host
Import-Module ActiveDirectory

$Users = Import-Csv \\omzglobal.com\uxm\Exchange\employee_changes.csv -Delimiter ";" -Encoding UTF8
$Log = New-Object Text.StringBuilder

Foreach ($User in $Users) {
	Try {
        $UserSearch = $User.displayName.ToString()
        $UserManager = $User.manager.ToString()

        if ($UserManager -ne " ") {
            $UserManager = Get-ADUser -SearchBase "OU=uxm,OU=MS,DC=omzglobal,DC=com" -Filter {(displayName -eq $UserManager)} -Properties *

            Get-ADUser -SearchBase "OU=uxm,OU=MS,DC=omzglobal,DC=com" -Filter {(displayName -eq $UserSearch)} -Properties * | 
                Set-ADUser -Manager $UserManager
        }

        Get-ADUser -SearchBase "OU=uxm,OU=MS,DC=omzglobal,DC=com" -Filter {(displayName -eq $UserSearch)} -Properties * | 
            Set-ADUser -Replace @{employeeID=$User.employeeID; title=$User.title; departmentNumber=$User.departmentNumber; department=$User.department; extensionAttribute1=$User.extensionAttribute1; extensionAttribute2=$User.extensionAttribute2;}

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
	$Log.ToString() | Out-File C:\Scripts\employee_changes.log -Append
}