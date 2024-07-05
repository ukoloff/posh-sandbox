####################################################################################
# �����: ����� ����						  		   #
# ����: 05-01-2024 ������: 1.0					  		   #
# ����������: ������ ��������� ���������� ������ � ���������		 	   #
####################################################################################

#������ ��������
Clear-Host
Import-Module ActiveDirectory

#������� ������ ������� � ������� ������ � ������
$Days = "30" 

#����� � ������������
$Path = "\\omzglobal.com\uxm\Exchange\PrintStat"

#���������� ������������� ��� ������ �������� ������
$SearchRootPC="OU=Computers,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com"
#��� ������
#$SearchRootPC="OU=TEST,OU=Computers,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com"
$Comps = Get-ADComputer -SearchBase $SearchRootPC -Filter {Enabled -eq "True" -and OperatingSystem -Like 'Windows*'} | sort name

#��������� ������� �� ������
$Log = New-Object Text.StringBuilder

#��������� ���� ������������ ������� �� ������� ��������
ForEach ($Comp in $Comps) {
Try {
$CompName = $Comp.name.ToString()
#�������� �� ������� ����������� �����������. ���� ������� �������� ������� ��������
		Write-Host "[����] � ��������� ���������: [$CompName]" -foregroundColor Magenta
		if ((Test-WsMan -ComputerName $CompName -ErrorAction Ignore )) {Invoke-Command -ComputerName $CompName {
		netsh advfirewall firewall set rule group="Remote Event Log Management" new enable=yes} -ErrorAction SilentlyContinue
		\\omzglobal.com\uxm\Exchange\skud\PSTools\psexec64.exe -accepteula -s -h \\$CompName cmd /c wevtutil.exe sl Microsoft-Windows-PrintService/Operational /enabled:true
		Get-WinEvent -ComputerName $CompName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue -FilterHashTable @{LogName="Microsoft-Windows-PrintService/Operational"; ID=307; StartTime=(Get-Date).AddDays(-$Days)} | Select-object -Property TimeCreated, @{label='UserName';expression={$_.properties[2].value}},@{label='HostName';expression={$_.properties[3].value}}, @{label='Document';expression={$_.properties[1].value}}, @{label='PrinterName';expression={$_.properties[4].value}}, @{label='Pages';expression={$_.properties[7].value}} | Export-Csv -Path "$Path\Print_Audit-$(get-date -f dd-MM-yyyy).csv" �NoTypeInformation -Encoding UTF8 -Append
	   	$Text = "{0} : [����!] ���������: [{1}] ������ ����������" -f (Get-Date).ToString(), $CompName
		$Log.AppendLine($Text) | Out-Null
} else {
		$Text = "{0} : [������!] ���������: [{1}] �� �������� �� ������� �������" -f (Get-Date).ToString(), $CompName
        	$Log.AppendLine($Text) | Out-Null
        	Write-Host "[������] $CompName �� ��������..." -foregroundColor Cyan   
}} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [������!] ���������: [{1}] {2}" -f (Get-Date).ToString(), $CompName, $_.Exception.Message
    $Log.AppendLine($Text) | Out-Null
} Finally {
Write-Host "[Info] ������ �������� ������ ���������� [$CompName] ��������" -foregroundColor Green
}}

$SearchRootSRV="OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com"
#��� ������
#$SearchRootSRV="OU=TEST,OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com"
$Servers = Get-ADComputer -SearchBase $SearchRootSRV -Filter {Enabled -eq "True" -and OperatingSystem -Like 'Windows*'} | sort name


#��������� ������� �� ��������
$Log2 = New-Object Text.StringBuilder

#��������� ���� ������������ ������� �� ��������
ForEach ($Server in $Servers) {
Try {
$ServerName = $Server.name.ToString()
#�������� �� ������� ����������� ��������. ���� ������� �������� ������� ��������
		Write-Host "[����] � ��������� ������: [$ServerName]" -foregroundColor Magenta
		if ((Test-WsMan -ComputerName $ServerName -ErrorAction Ignore )) {Invoke-Command -ComputerName $ServerName -ScriptBlock {
		netsh advfirewall firewall set rule group="Remote Event Log Management" new enable=yes} -ErrorAction SilentlyContinue
		\\omzglobal.com\uxm\Exchange\skud\PSTools\psexec64.exe -accepteula -s -h \\$ServerName cmd /c wevtutil.exe sl Microsoft-Windows-PrintService/Operational /enabled:true
		Get-WinEvent -ComputerName $ServerName -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue -FilterHashTable @{LogName="Microsoft-Windows-PrintService/Operational"; ID=307; StartTime=(Get-Date).AddDays(-$Days)} | Select-object -Property TimeCreated, @{label='UserName';expression={$_.properties[2].value}},@{label='HostName';expression={$_.properties[3].value}}, @{label='Document';expression={$_.properties[1].value}}, @{label='PrinterName';expression={$_.properties[4].value}}, @{label='Pages';expression={$_.properties[7].value}} | Export-Csv -Path "$Path\Print_Audit-$(get-date -f dd-MM-yyyy).csv" �NoTypeInformation -Encoding UTF8 -Append
	   	$Text = "{0} : [����!] ������: [{1}] ������ ����������" -f (Get-Date).ToString(), $ServerName
		$Log2.AppendLine($Text) | Out-Null
} else {
		$Text = "{0} : [������!] ������: [{1}] �� �������� �� ������� �������" -f (Get-Date).ToString(), $ServerName
        	$Log.AppendLine($Text) | Out-Null
       		Write-Host "[������] $ServerName �� ��������..." -foregroundColor Cyan
}} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [������!] ������: [{1}] {2}" -f (Get-Date).ToString(), $ServerName, $_.Exception.Message
    $Log2.AppendLine($Text) | Out-Null
} Finally {
Write-Host "[Info] ������ �������� ������ ������� [$ServerName] ��������" -foregroundColor Green
}}   


#��������� ��� �� ������
If($Log.ToString()) {
	$Log.ToString() | Out-File "$Path\history-$(get-date -f dd-MM-yyyy).log" -Append
}

#��������� ��� �� ��������
If($Log2.ToString()) {
	$Log2.ToString() | Out-File "$Path\history-$(get-date -f dd-MM-yyyy).log" -Append
}