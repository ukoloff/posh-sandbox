####################################################################################
# �����: ����� ����						  		   #
# ����: 30-05-2023 ������: 1.0					  		   #
# ����������: ������ �������� �������� � ������ ��� GPO                 	   #
####################################################################################

#������ ��������
Clear-Host
Import-Module ActiveDirectory

#���������� �������
$Log = New-Object Text.StringBuilder

#���������� ������������� ��� ������ ��� � Active Directory
$SearchRoot = "OU=EKBH,OU=UXM,OU=MS,DC=omzglobal,DC=com"
#��� �����
$File = "Tessa Deski.lnk"
#�������� ������ ������� �������
$Comps = Get-ADComputer -SearchBase $SearchRoot -Filter {Enabled -eq "True"} | sort name

#������ ����� ������ � �������� �����
ForEach ($Comp in $Comps) {
Try {
#������ �����
$CompName = $Comp.name.ToString()

#�������� �� ������� ����������� �����������. 
    if (!(Test-Connection -ComputerName $CompName -Count 1 -Quiet)) {
	$Text = "{0} : [������!] ���������: [{1}] ��������� �� �������� �� ������� �������" -f (Get-Date).ToString(), $CompName
        $Log.AppendLine($Text) | Out-Null
        Write-Host "$CompName �� ��������..." -foregroundColor Cyan     
    } else {
#������ ��� ������������
$UserName = (gwmi Win32_ComputerSystem -ErrorAction SilentlyContinue -ComputerName $CompName).UserName.Substring(10)
#������ ���� � �����
$FilePath1 = "\\$CompName\C$\Users\$UserName\Desktop\$File"
$FilePath2 = "\\$CompName\C$\Users\Public\Desktop\$File"
#��������� ������� �����, ���� ���� �������
if (Test-Path -Path $FilePath1) {
    Remove-Item -Path $FilePath1
    $Text = "{0} : [�����!] ���������: [{1}] ������������: [{2}] ���� $FilePath1 ������� ������" -f (Get-Date).ToString(), $CompName, $UserName
    Write-Host "$Text" -foregroundColor Green
    $Log.AppendLine($Text) | Out-Null
    } else {
   	   $Text = "{0} : [��������!] ���������: [{1}] ������������: [{2}] ���� $FilePath1 �� ������" -f (Get-Date).ToString(), $CompName, $UserName
	   Write-Host "$Text" -foregroundColor Magenta 
    	   $Log.AppendLine($Text) | Out-Null
           }
if (Test-Path -Path $FilePath2) {
    Remove-Item -Path $FilePath2
    $Text = "{0} : [�����!] ���������: [{1}] ������������: [{2}] ���� $FilePath2 ������� ������" -f (Get-Date).ToString(), $CompName, $UserName
    Write-Host "$Text" -foregroundColor Green
    $Log.AppendLine($Text) | Out-Null
    } else {
   	   $Text = "{0} : [��������!] ���������: [{1}] ������������: [{2}] ���� $FilePath2 �� ������" -f (Get-Date).ToString(), $CompName, $UserName
	   Write-Host "$Text" -foregroundColor Magenta
    	   $Log.AppendLine($Text) | Out-Null 
           }
    }
} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [������!] ���������: [{1}] ������������: [{2}] {3}" -f (Get-Date).ToString(), $CompName, $FullName, $_.Exception.Message
    $Log.AppendLine($Text) | Out-Null
} Finally {
#Write-Host "$ErrorMessage" -foregroundColor Cyan
}}

#��������� ��� ������
If($Log.ToString()) {
	$Log.ToString() | Out-File "C:\Scripts\DeleteFiles.log"
}