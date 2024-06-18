####################################################################
# �����: ����� ����						   #
# ����: 10-05-2023 ������: 1.0					   #
# ����������: ������ ���������� �������� AD (��������� ���������)  #
####################################################################

#������ ��������
Clear-Host
Import-Module ActiveDirectory

#������ �������
$Log = New-Object Text.StringBuilder

#������ ������������� ��������� ���������
$warn = New-Object Text.StringBuilder

#���������� ������������� ��� ������ ����������� � Active Directory
$SearchRoot = "OU=uxm,OU=MS,DC=omzglobal,DC=com"

#������ ���� �� 1�
$Users = Import-Csv "\\omzglobal.com\uxm\Exchange\employee_changes.csv" -Delimiter ";" -Encoding UTF8
# $Users = Import-Csv "c:\Scripts\test\employee_changes.csv" -Delimiter ";" -Encoding UTF8

#��������� ���� �������� � �������� ��������� � ��������
Foreach ($User in $Users) {
#������ ���������� �� CSV
	$employeeID = $User.employeeID.ToString()
	$Manager = $User.manager.ToString()
	$title=$User.title.ToString()
	$departmentNumber=$User.departmentNumber.ToString()
	$department=$User.department.ToString() -replace '/.*', ''
	$extensionAttribute1=$User.extensionAttribute1.ToString()
	$extensionAttribute2=$User.extensionAttribute2.ToString()

	$Search = Get-ADUser -SearchBase $SearchRoot -Properties * -Filter {(employeeID -eq $employeeID) -and (Enabled -eq "True")}
if($Search -eq $null)
 {
	#������� � ������ ���������� �� ���������� ������������ � �������� AD
	$Text = "{0} : [������!] ������������ ����������� � �������� Active Directory {1} {2}" -f (Get-Date).ToString(), $User.employeeID,$User.displayName
        $Log.AppendLine($Text) | Out-Null
 }
Else
 {
	#������������� ���������� ���� �� �����
        if ($Manager -ne "") {
	$UserManager = Get-ADUser -SearchBase $SearchRoot -Properties * -Filter {(displayName -eq $Manager)}
	$Search | Set-ADUser -manager $UserManager
        }
	Else {
	$Search | Set-ADUser -Clear manager
	#������� � ������ �������������� �� ���������� ������ � ����������
	$Text = "{0} : [��������!] �� ��������� ���� ��������� ��� {1} {2}" -f (Get-Date).ToString(), $User.employeeID,$User.displayName
        $warn.AppendLine($Text) | Out-Null }
	#������������� ���� ���� �������� ��� � ����� ������
	$Search | Set-ADUser -Replace @{extensionAttribute1=$extensionAttribute1}
	$Search | Set-ADUser -Replace @{extensionAttribute2=$extensionAttribute2}
	$Search | Set-ADUser -Replace @{departmentNumber=$departmentNumber}
	#������������� ����������� ������������� � ���������
	#$Search | Set-ADUser -Department $department
	#$Search | Set-ADUser -Title $title
	$Search | Set-ADUser -Replace @{department=$department}
	$Search | Set-ADUser -Replace @{title=$title}
	#����� ������ �������� ���������
        $Text = "{0} : [�����!] ������� ��������� � �������� Acrive Directory ��� {1} {2}" -f (Get-Date).ToString(), $User.employeeID,$User.displayName
        $Log.AppendLine($Text) | Out-Null
 }    
}
#��������� � ������ � ������� �� ������� ��������� 50 �����
If($Log.ToString()) {
	$Log.ToString() | Out-File C:\Scripts\employee_changes.log -Append
	Get-Content -Path C:\Scripts\employee_changes.log -Tail 50
}
#��������� ������ ��������������
If($warn.ToString()) {
	$warn.ToString() | Out-File C:\Scripts\employee_changes_no_manager.log
}