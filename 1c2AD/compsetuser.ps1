##################################################
# Автор: Сорвин Илья Mail: sorvin@ekb.ru
# Дата: 03-06-2019 Версия: 1.0
# Назначение: Скрипт установки сответствия ПК владельцам
##################################################
Clear-Host

#Функция возращает true, если заданный хост пингуется и false  - в противном случае
function Test-Host ($Name)
{
    $ping = new-object System.Net.NetworkInformation.Ping
    trap {Write-Verbose "Ошибка пинга"; $False; continue}
    if ($ping.send($Name).Status -eq "Success" ) { $True }
    else { $False }
}

#Такой путь был для УЗХМ
#$SearchRoot="OU=Computers,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com"

#Такой путь нужен для работы скрипта Skud.ps1 изменил 15.05.2023 Сулев И.А.
$SearchRoot="OU=MS,DC=omzglobal,DC=com"

$Comps = Get-ADComputer -ErrorAction SilentlyContinue -SearchBase $SearchRoot -Filter * #|Select-Object -property "Name","Description"
foreach ($Comp in $Comps)
{
  if (Test-Host $Comp.Name)
     {
    $LoggedonUserName = (gwmi Win32_ComputerSystem -ErrorAction SilentlyContinue -ComputerName $Comp.Name).UserName
    Write-Host "Computer=", $Comp.Name, "Logged on user=$LoggedonUserName"
    if ($LoggedonUserName -ne $null)
        {
            Set-ADComputer $Comp.Name -UserPrincipalName $LoggedonUserName.Substring(10) | Out-Null
            Set-ADComputer $Comp.Name -ManagedBy $LoggedonUserName.Substring(10) | Out-Null
        }
     }
}
#Дополнил атрибут -ManagedBy дополнительно -UserPrincipalName, т.к. данный атрибут можно вывести в AD в отдельный столбец "Имя входа пользователя"
#и видеть не проваливаясь внутрь контейнера. 28.04.2023г. Сулев И.А.