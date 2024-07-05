##################################################
# �����: ����� �������
# ��������� ���������� �����, ������� ��������� ���� �������� ���������� �������� �� �������.
# ������ ��� ��� ���� ������� � ���� �������, ����� ��� ������, ������ ����� ��� �������� :)
# ����������: ������ ��������� �������� AD
##################################################
Clear-Host
Import-Module ActiveDirectory

# ����������� CSV ��������� �� ����� � �������
$Users = Import-Csv \\omzglobal.com\uxm\Exchange\employee_changes.csv -Delimiter ";" -Encoding UTF8
$Log = New-Object Text.StringBuilder

#Write-Output $User $Users  -foregroundColor Green

# ���� �� ������ �������
Foreach ($User in $Users) {
	Try {
# ����������� ���������� � ����� �������� ��� �������� � ���������� ����
# ����� �� ���� � ������� ������)
        $UserSearch = $User.displayName.ToString()
        $UserManager = $User.manager.ToString()
		$employeeID = $User.employeeID.ToString()
		$title=$User.title.ToString()
		$departmentNumber=$User.departmentNumber.ToString()
		$department=$User.department.ToString()
		$extensionAttribute1=$User.extensionAttribute1.ToString()
		$extensionAttribute2=$extensionAttribute2

		# ����� �������� ��������� ������ �������.
		# ������������� ����������
		Get-ADUser -SearchBase "OU=uxm,OU=MS,DC=omzglobal,DC=com" -Filter {(displayName -eq $UserSearch)} -Properties * | Set-ADUser -Replace @{manager = $UserManager;}
		# ������������� ���� ��������
		Get-ADUser -SearchBase "OU=uxm,OU=MS,DC=omzglobal,DC=com" -Filter {(displayName -eq $UserSearch)} -Properties * | Set-ADUser -Replace @{extensionAttribute1 = $extensionAttribute1;}
		# ������������� �����
		Get-ADUser -SearchBase "OU=uxm,OU=MS,DC=omzglobal,DC=com" -Filter {(displayName -eq $UserSearch)} -Properties * | Set-ADUser -Replace @{departmentNumber = $departmentNumber;}
		Get-ADUser -SearchBase "OU=uxm,OU=MS,DC=omzglobal,DC=com" -Filter {(displayName -eq $UserSearch)} -Properties * | Set-ADUser -Replace @{department = $department;}

        $Text = "{0} : ������� ��������� ��� {1}" -f (Get-Date).ToString(), $User 
        $Log.AppendLine($Text) | Out-Null    
		#$Log.AppendLine($Text) | Out-File employee_changes.log -Append    
	} Catch {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        $StatusText = "{0} : ��������� ������ Message: {1} ItemName: {2}" -f (Get-Date).ToString(), $_.Exception.Message, $_.Exception.ItemName
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