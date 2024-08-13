####################################################################################
# Автор: Сулев Илья						  		   #
# Дата: 31-05-2023 Версия: 1.0					  		   #
# Назначение: Скрипт отображения списка установленных приложений на серверах       #
####################################################################################

#Запуск сценария
Clear-Host
Import-Module ActiveDirectory

#Результаты задания
$Log = New-Object Text.StringBuilder

function Get-AppListServer {
$Roots = @("HKLM:", "HKCU:")
$Folders = @(
              "\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
              "\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
            )

$Result = @()
foreach($Root in $Roots) {
  foreach($Folder in $Folders) {
    $Path = $Root + "\" + $Folder
    Set-Location $Path -ErrorAction SilentlyContinue
    $Programs = Get-ChildItem $Path -ErrorAction SilentlyContinue

    foreach($Program in $Programs) {
      $App = New-Object PSObject
      $Hidden = $Program.GetValue("SystemComponent")
      if ($Hidden -eq $null) {
        # Name and version
        $Name = $Program.GetValue("DisplayName")
        $Version = $Program.GetValue("DisplayVersion")

        # Size
        $EstimatedSize = $Program.GetValue("EstimatedSize")
        if ($EstimatedSize -ne $null) {
          $EstimatedSize = $EstimatedSize * 1024
        }

        # InstallDate
        $InstallDate = $Program.GetValue("InstallDate")
        if ($InstallDate -ne $null) {
          try {
            $InstallDate = [datetime]::ParseExact($InstallDate,'yyyyMMdd', $null)
          }
          catch {
            $InstallDate = $null
          }
        }

        # Publisher
        $Publisher = $Program.GetValue("Publisher")

        # UninstallString and IsRemovable
        $UninstallString = $Program.GetValue("UninstallString")

        if ($UninstallString) {
          if ($UninstallString.ToLower().Contains("msiexec.exe")) {
            # If the UninstallString uses msiexec.exe, replace the /I with /X for uninstall
            if ($UninstallString.Contains("/I")) {
              $UninstallString = $UninstallString.Replace("/I", "/X");
            } elseif ($UninstallString.Contains("/i")) {
              $UninstallString = $UninstallString.Replace("/i", "/x");
            }
            $IsRemovable = $true
          } else {
            # If the UninstallString uses an uninstall exe, then mark this app as unremovable.
            $IsRemovable = $false
          }
        } else {
          $IsRemovable = $false
        }

        # ID
        if ($UninstallString -ne $null) {
          $Id = $UninstallString
        } else {
          $Id = $Name + $Version
        }

        $App | Add-Member -MemberType NoteProperty -Name "Name" -Value $Name
        $App | Add-Member -MemberType NoteProperty -Name "Version" -Value $Version
        $App | Add-Member -MemberType NoteProperty -Name "Size" -Value $EstimatedSize
        $App | Add-Member -MemberType NoteProperty -Name "InstallDate" -Value $InstallDate
        $App | Add-Member -MemberType NoteProperty -Name "Source" -Value $null
        $App | Add-Member -MemberType NoteProperty -Name "Publisher" -Value $Publisher
        $App | Add-Member -MemberType NoteProperty -Name "UninstallString" -Value $UninstallString
        $App | Add-Member -MemberType NoteProperty -Name "IsRemovable" -Value $IsRemovable
        $App | Add-Member -MemberType NoteProperty -Name "Id" -Value $Id

        $Result += $App
      }
    }
  }
}

$Result

}


#Логическое подразделение для поиска в Active Directory
$SearchRoot = "OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com"
#Критерий выбора станций
$Comps = Get-ADComputer -SearchBase $SearchRoot -Filter {Enabled -eq "True"} | sort name

#Запуск цикла поиска приложений
ForEach ($Comp in $Comps) {
Try {
#Задаем имена
$CompName = $Comp.name.ToString()
    $Log.AppendLine("[$CompName]") | Out-Null
    $Log.AppendLine("---------------------------------------------------------------------------------------") | Out-Null
#Проверка на наличие отключенных компьютеров.
Write-Host "Сканирование узла [$CompName]..." -foregroundColor Green -backgroundColor Black
    if (!(Test-Connection -ComputerName $CompName -Count 1 -Quiet)) {
        $Log.AppendLine("Компьютер не отвечает на сетевые запросы") | Out-Null
        Write-Host "Узел [$CompName] не отвечает..." -foregroundColor Yellow -backgroundColor Black    
    } else {
	$Apps = Invoke-Command -ComputerName $CompName -ScriptBlock ${Function:Get-AppListServer}
	$i = 0
	ForEach ($App in $Apps) {
	$Name = $App.name	
	If($Name -ne $null) {
	$i = $i + 1
	$Log.AppendLine("$i. $Name") | Out-Null
        Write-Host "[$i] Найдено приложение: [$Name]" -foregroundColor DarkCyan -backgroundColor Black
        }}
    }
} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [ОШИБКА!] Компьютер: [{1}] {2}" -f (Get-Date).ToString(), $CompName, $_.Exception.Message
} Finally {
    $Log.AppendLine($Text) | Out-Null
    $Log.AppendLine("---------------------------------------------------------------------------------------") | Out-Null
}}

#Сохраняем лог задачи
If($Log.ToString()) {
	$Log.ToString() | Out-File "C:\Scripts\Apps.log"
}