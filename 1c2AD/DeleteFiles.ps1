####################################################################################
# Автор: Сулев Илья						  		   #
# Дата: 30-05-2023 Версия: 1.0					  		   #
# Назначение: Скрипт удаления объектов с хостов без GPO                 	   #
####################################################################################

#Запуск сценария
Clear-Host
Import-Module ActiveDirectory

#Результаты задания
$Log = New-Object Text.StringBuilder

#Логическое подразделение для поиска АРМ в Active Directory
$SearchRoot = "OU=EKBH,OU=UXM,OU=MS,DC=omzglobal,DC=com"
#Имя файла
$File = "Tessa Deski.lnk"
#Критерий выбора рабочих станций
$Comps = Get-ADComputer -SearchBase $SearchRoot -Filter {Enabled -eq "True"} | sort name

#Запуск цикла поиска и удаления файла
ForEach ($Comp in $Comps) {
Try {
#Задаем имена
$CompName = $Comp.name.ToString()

#Проверка на наличие отключенных компьютеров. 
    if (!(Test-Connection -ComputerName $CompName -Count 1 -Quiet)) {
	$Text = "{0} : [ОШИБКА!] Компьютер: [{1}] Компьютер не отвечает на сетевые запросы" -f (Get-Date).ToString(), $CompName
        $Log.AppendLine($Text) | Out-Null
        Write-Host "$CompName не отвечает..." -foregroundColor Cyan     
    } else {
#Узнаем кто пользователь
$UserName = (gwmi Win32_ComputerSystem -ErrorAction SilentlyContinue -ComputerName $CompName).UserName.Substring(10)
#Задаем путь к файлу
$FilePath1 = "\\$CompName\C$\Users\$UserName\Desktop\$File"
$FilePath2 = "\\$CompName\C$\Users\Public\Desktop\$File"
#Проверяем наличие файла, если есть удаляем
if (Test-Path -Path $FilePath1) {
    Remove-Item -Path $FilePath1
    $Text = "{0} : [УСПЕХ!] Компьютер: [{1}] Пользователь: [{2}] Файл $FilePath1 успешно удален" -f (Get-Date).ToString(), $CompName, $UserName
    Write-Host "$Text" -foregroundColor Green
    $Log.AppendLine($Text) | Out-Null
    } else {
   	   $Text = "{0} : [ВНИМАНИЕ!] Компьютер: [{1}] Пользователь: [{2}] Файл $FilePath1 не найден" -f (Get-Date).ToString(), $CompName, $UserName
	   Write-Host "$Text" -foregroundColor Magenta 
    	   $Log.AppendLine($Text) | Out-Null
           }
if (Test-Path -Path $FilePath2) {
    Remove-Item -Path $FilePath2
    $Text = "{0} : [УСПЕХ!] Компьютер: [{1}] Пользователь: [{2}] Файл $FilePath2 успешно удален" -f (Get-Date).ToString(), $CompName, $UserName
    Write-Host "$Text" -foregroundColor Green
    $Log.AppendLine($Text) | Out-Null
    } else {
   	   $Text = "{0} : [ВНИМАНИЕ!] Компьютер: [{1}] Пользователь: [{2}] Файл $FilePath2 не найден" -f (Get-Date).ToString(), $CompName, $UserName
	   Write-Host "$Text" -foregroundColor Magenta
    	   $Log.AppendLine($Text) | Out-Null 
           }
    }
} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [ОШИБКА!] Компьютер: [{1}] Пользователь: [{2}] {3}" -f (Get-Date).ToString(), $CompName, $FullName, $_.Exception.Message
    $Log.AppendLine($Text) | Out-Null
} Finally {
#Write-Host "$ErrorMessage" -foregroundColor Cyan
}}

#Сохраняем лог задачи
If($Log.ToString()) {
	$Log.ToString() | Out-File "C:\Scripts\DeleteFiles.log"
}