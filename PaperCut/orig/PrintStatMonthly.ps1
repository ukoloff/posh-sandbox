####################################################################################
# �����: ����� ����						  		   #
# ����: 18-01-2024 ������: 1.1					  		   #
# ����������: ������ ��������� ����������� ���������� ������ � ���������	   #
####################################################################################

#������ ��������
Clear-Host
Import-Module ActiveDirectory

#���������� ������ ��������
$CSV1 = "C$\Program Files (x86)\PaperCut Print Logger\logs\csv\monthly\papercut-print-log-$(get-date -f yyyy-MM).csv"
$CSV2 = "C$\Program Files\PaperCut Print Logger\logs\csv\monthly\papercut-print-log-$(get-date -f yyyy-MM).csv"

#������ �������
$Template = "\\omzglobal.com\uxm\Exchange\PrintStat\PSTools\Template.csv"

#����� � ������������
$Path = "\\omzglobal.com\uxm\Exchange\PrintStat\Logs\Monthly"

#���������� ������������� ��� ������ �������� ������ ������
$SearchRootPC="OU=Computers,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com"
#��� ������
#$SearchRootPC="OU=TEST,OU=Computers,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com"
$Comps = Get-ADComputer -SearchBase $SearchRootPC -Filter {Enabled -eq "True" -and OperatingSystem -Like 'Windows*'} | sort name

#��� ���������� ������� �� ������
$Log = New-Object Text.StringBuilder

#�������� ������������� ������� �� �������
if (!(Test-Path -Path \\omzglobal.com\uxm\Exchange\PrintStat\Logs\Monthly\PrintLog-$(get-date -f MM-yyyy).csv)) {
Get-Content $Template -Encoding UTF8 | Out-File $Path\PrintLog-$(get-date -f MM-yyyy).csv -Force -Encoding UTF8
Write-Host "[����] ������ ����� ������ � ���������� [\\$Path\PrintLog-$(get-date -f MM-yyyy).csv]" -foregroundColor Cyan
}

#��������� ���� ������������ ������� �� ������� ��������
ForEach ($Comp in $Comps) {
Try {
$CompName = $Comp.name.ToString()
#�������� �� ������� ����������� �����������. ���� ������� ��������� ������� �������� ������, ���� ��� ��� �� ������������� ������
		Write-Host "[����] � ��������� ���������: [$CompName]" -foregroundColor Magenta
		if ((Test-WsMan -ComputerName $CompName -ErrorAction Ignore)) {
		if (!(Test-Path -Path "\\$CompName\C$\Program Files (x86)\PaperCut Print Logger") -And (!(Test-Path -Path "\\$CompName\C$\Program Files\PaperCut Print Logger"))) {
		\\omzglobal.com\uxm\Exchange\PrintStat\PSTools\psexec64.exe -accepteula -s -h \\$CompName -c -v \\omzglobal.com\uxm\Exchange\PrintStat\PSTools\papercut-print-logger.exe /NOICONS /VERYSILENT /SUPPRESSMSGBOXES /TYPE=secondary_print
		\\omzglobal.com\uxm\Exchange\PrintStat\PSTools\psexec.exe -accepteula -s -h \\$CompName -c -v \\omzglobal.com\uxm\Exchange\PrintStat\PSTools\papercut-print-logger.exe /NOICONS /VERYSILENT /SUPPRESSMSGBOXES /TYPE=secondary_print
	   	$Text = "{0} : [����!] ���������: [{1}] ������ ������ ������� �����������" -f (Get-Date).ToString(), $CompName
		$Log.AppendLine($Text) | Out-Null
} else {
		$Text = "{0} : [����!] ���������: [{1}] ������ ������ ��� �����������, ����� ������ ��������" -f (Get-Date).ToString(), $CompName
        	$Log.AppendLine($Text) | Out-Null
       		Write-Host "[����] ������ ������ ��� �����������, ����� ������ �������� [$CompName]" -foregroundColor Cyan
		if (Test-Path -Path "\\$CompName\C$\Program Files (x86)\PaperCut Print Logger") {$PrintLog = (Get-Content -Path "\\$CompName\$CSV1" -ErrorAction SilentlyContinue | Select -Skip 1); $PrintLog = ($PrintLog | Select -Skip 1)} else {$PrintLog = (Get-Content -Path "\\$CompName\$CSV2" -ErrorAction SilentlyContinue | Select -Skip 1); $PrintLog = ($PrintLog | Select -Skip 1)}
		Write-Host "$PrintLog"
		$PrintLog | Out-File $Path\PrintLog-$(get-date -f MM-yyyy).csv -Encoding UTF8 -Append -Force
}} else {
		$Text = "{0} : [������!] ���������: [{1}] �� �������� �� ������� �������" -f (Get-Date).ToString(), $CompName
        	$Log.AppendLine($Text) | Out-Null
       		Write-Host "[������] ���������: [$CompName] �� ��������..." -foregroundColor Cyan  
}} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [������!] ���������: [{1}] {2}" -f (Get-Date).ToString(), $CompName, $_.Exception.Message
    $Log.AppendLine($Text) | Out-Null
} Finally {
		Write-Host "[����] ������ �������� ������ ���������� [$CompName] ��������" -foregroundColor Green
		$Text = "{0} : [����!] ���������: [{1}] ������ �������� ������ ��������" -f (Get-Date).ToString(), $CompName
        	$Log.AppendLine($Text) | Out-Null
		$Jobs = Get-Content -Path $Path\PrintLog-$(get-date -f MM-yyyy).csv -ErrorAction SilentlyContinue | Sort-Object -Unique -Descending
		$Jobs | Out-File $Path\PrintLog-$(get-date -f MM-yyyy).csv -Encoding UTF8 -Force
		Write-Host "[����] ������ � [$CompName] ������� ��������� � ������" -foregroundColor Green
}}

#���������� ������������� ��� ������ �������� ������ ��������
$SearchRootSRV="OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com"
#��� ������
#$SearchRootSRV="OU=TEST,OU=uxm,OU=servers-ekb-uhm,OU=Servers,DC=omzglobal,DC=com"
$Servers = Get-ADComputer -SearchBase $SearchRootSRV -Filter {Enabled -eq "True" -and OperatingSystem -Like 'Windows*'} | sort name


#��� ���������� ������� �� ��������
$Log2 = New-Object Text.StringBuilder

#��������� ���� ������������ ������� �� ��������
ForEach ($Server in $Servers) {
Try {
$ServerName = $Server.name.ToString()
#�������� �� ������� ����������� ��������. ���� ������� ��������� ������� �������� ������, ���� ��� ��� �� ������������� ������
		Write-Host "[����] � ��������� ������: [$ServerName]" -foregroundColor Magenta
		if ((Test-WsMan -ComputerName $ServerName -ErrorAction Ignore)) {
		if (!(Test-Path -Path "\\$ServerName\C$\Program Files (x86)\PaperCut Print Logger")) {
		\\omzglobal.com\uxm\Exchange\PrintStat\PSTools\psexec64.exe -accepteula -s -h \\$ServerName -c -v \\omzglobal.com\uxm\Exchange\PrintStat\PSTools\papercut-print-logger.exe /NOICONS /VERYSILENT /SUPPRESSMSGBOXES /TYPE=secondary_print
	   	$Text = "{0} : [����!] ������: [{1}] ������ ����������� ������ ����������" -f (Get-Date).ToString(), $ServerName
		$Log2.AppendLine($Text) | Out-Null
} else {
		$Text = "{0} : [����!] ������: [{1}] ������ ������ ��� �����������, ����� ������ ��������" -f (Get-Date).ToString(), $ServerName
        	$Log2.AppendLine($Text) | Out-Null
       		Write-Host "[����] ������ ������ ��� �����������, ����� ������ �������� [$ServerName]" -foregroundColor Cyan
		if (Test-Path -Path "\\$ServerName\C$\Program Files (x86)\PaperCut Print Logger") {$PrintLog = (Get-Content -Path "\\$ServerName\$CSV1" -ErrorAction SilentlyContinue | Select -Skip 1); $PrintLog = ($PrintLog | Select -Skip 1)} else {$PrintLog = (Get-Content -Path "\\$ServerName\$CSV2" -ErrorAction SilentlyContinue | Select -Skip 1); $PrintLog = ($PrintLog | Select -Skip 1)}
		Write-Host "$PrintLog"
		$PrintLog | Out-File $Path\PrintLog-$(get-date -f MM-yyyy).csv -Encoding UTF8 -Append -Force
}} else {
		$Text = "{0} : [������!] ������: [{1}] �� �������� �� ������� �������" -f (Get-Date).ToString(), $ServerName
        	$Log2.AppendLine($Text) | Out-Null
       		Write-Host "[������] ������: [$ServerName] �� ��������..." -foregroundColor Cyan
}} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [������!] ������: [{1}] {2}" -f (Get-Date).ToString(), $ServerName, $_.Exception.Message
    $Log2.AppendLine($Text) | Out-Null
} Finally {
		Write-Host "[����] ������ �������� ������ ������� [$ServerName] ��������" -foregroundColor Green
		$Text = "{0} : [����!] ������: [{1}] ������ �������� ������ ��������" -f (Get-Date).ToString(), $ServerName
        	$Log2.AppendLine($Text) | Out-Null
		$Jobs = Get-Content -Path $Path\PrintLog-$(get-date -f MM-yyyy).csv -ErrorAction SilentlyContinue | Sort-Object -Unique -Descending
		$Jobs | Out-File $Path\PrintLog-$(get-date -f MM-yyyy).csv -Encoding UTF8 -Force
		Write-Host "[����] ������ � [$ServerName] ������� ��������� � ������" -foregroundColor Green
}}   

#������ ��������� � ��������� ���������
$Jobs = Get-Content -Path $Path\PrintLog-$(get-date -f MM-yyyy).csv -ErrorAction SilentlyContinue | Sort-Object -Unique -Descending
$Jobs | Out-File $Path\PrintLog-$(get-date -f MM-yyyy).csv -Encoding UTF8 -Force
Write-Host "[����] ��� ������ ������� ���������" -foregroundColor Cyan

#��������� ��� ������� �� ������
If($Log.ToString()) {
	$Log.ToString() | Out-File "$Path\history-$(get-date -f dd-MM-yyyy).log" -Append
}

#��������� ��� ������� �� ��������
If($Log2.ToString()) {
	$Log2.ToString() | Out-File "$Path\history-$(get-date -f dd-MM-yyyy).log" -Append
}