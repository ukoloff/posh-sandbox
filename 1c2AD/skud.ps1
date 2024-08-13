####################################################################################
# �����: ����� ����						  		   #
# ����: 15-05-2023 ������: 1.2					  		   #
# ����������: ������ ��������������� �� ���� SIGUR � ���������� ����� AD 	   #
####################################################################################

#������ ��������
Clear-Host
Import-Module ActiveDirectory

#���������� �������
$Log = New-Object Text.StringBuilder
$Result = New-Object Text.StringBuilder
$Success = New-Object Text.StringBuilder

#������ ����������, ���� ���-�� ����� �������� - ���������� �������� ��� ������

#������ ������������ ����
$Group = "srvskud-ekbh1"
#������ ��� ������
#$Group = "skud"
#���������� ������������� ��� ������ ����������� � Active Directory
$SearchRoot="OU=MS,DC=omzglobal,DC=com"
#������ ������ ������������ � AD � �������� ������ �������������
$Users = Get-ADGroupMember $Group -Recursive | sort name | Select SamAccountName, distinguishedName, name
#����� � �� � ������������
$Path = "\\omzglobal.com\uxm\Exchange\skud"

#��������� ���� ������������ �������
ForEach ($User in $Users) {
	$CN = $User.distinguishedName.ToString()
	$Name = $User.SamAccountName.ToString()
	$FullName = $User.name.ToString()
	$Search = Get-ADUser -SearchBase $SearchRoot -Properties * -Filter {SamAccountName -like $Name -and Enabled -eq "True"}
#�������� �� ������� ����������� ������� �������
if($Search -eq $null)
 {
	#������� � ������ ���������� �� ����������� ������
	$Text = "{0} : [��������!] ������������ �������� � �������� Active Directory {1}({2})" -f (Get-Date).ToString(), $FullName, $Name
        $Log.AppendLine($Text) | Out-Null
 }
Else
 {
#�������� DN � ������������ ��� �� SIGUR ����, ��� �������� �������� � ������ ����������������� ����� �� ������ ������������ Active Directory
#�������� ��� ���������� � ������������� ������, ���� �� ��� �� ��� ����������. ���� ������������ ����� � ����� ������ �� ������ �� - ��������� ���������� �� ��� ��� ��.
$Comps = Get-ADComputer -SearchBase $SearchRoot -Filter {ManagedBy -eq $CN}
ForEach ($Comp in $Comps) {
Try {
$CompName = $Comp.name.ToString()
#�������� �� ������� ����������� �����������. ���� ������� ������������� �� ������ SIGUR
    if (!(Test-Connection -ComputerName $CompName -Count 2 -Quiet)) {
	$Text = "{0} : [������!] ���������: [{1}] ������������: [{2}] ��������� �� �������� �� ������� �������" -f (Get-Date).ToString(), $CompName, $FullName
        $Log.AppendLine($Text) | Out-Null
        Write-Host "$CompName ������������ $FullName �� ��������..." -foregroundColor Magenta
    } else {
        	if (Test-Path -Path "\\$CompName\C$\ProgramData\Microsoft\Windows\Start Menu\Programs\���� Sigur") {
        	Write-Host " ������ ��� ����������! $CompName ��� $FullName" -foregroundColor Magenta
		$Text = "{0} : [����!] ���������: [{1}] ������������: [{2}] ������ SIGUR ��� ���������� �����" -f (Get-Date).ToString(), $CompName, $FullName
		$Success.AppendLine($Text) | Out-Null
        	}
        	else {
		Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Software\Sysinternals' -Name 'EulaAccepted' -Value 1
        	Write-Host "��������� ������� �� $CompName ��� $FullName" -foregroundColor Magenta
        	&\\omzglobal.com\uxm\Exchange\skud\PSTools\psexec64.exe -acceptelua -s -h \\$CompName -c -v "\\omzglobal.com\uxm\Exchange\skud\Client\setup-1.1.1.53.s.exe" /S
        	\\omzglobal.com\uxm\Exchange\skud\PSTools\psexec64.exe -s -h \\$CompName cmd /c xcopy /C /Y "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\���� Sigur\������.lnk" "C:\Users\$Name\Desktop"
        	Copy-Item -Path "$Path\Client\.tcgui.cfg" -Destination "\\$CompName\c$\Users\$Name\.tcgui.cfg"
			if (Test-Path -Path "\\$CompName\C$\ProgramData\Microsoft\Windows\Start Menu\Programs\���� Sigur") {
			$Text = "{0} : [�����!] ���������: [{1}] ������������: [{2}] ������ SIGUR ������� ����������" -f (Get-Date).ToString(), $CompName, $FullName
			$Success.AppendLine($Text) | Out-Null
			}
			Else {
			$Text = "{0} : [������!] ���������: [{1}] ������������: [{2}] ������ �� ����������" -f (Get-Date).ToString(), $CompName, $FullName
        		$Log.AppendLine($Text) | Out-Null
			}
		}
	   }
} Catch {
    $ErrorMessage = $_.Exception.Message
    $Text = "{0} : [������!] ���������: [{1}] ������������: [{2}] {3}" -f (Get-Date).ToString(), $CompName, $FullName, $_.Exception.Message
    $Log.AppendLine($Text) | Out-Null
} Finally {
Write-Host "[Info] ��������� ������� ��� $FullName �� ��������� [$CompName] ���������" -foregroundColor Magenta
}
}
	$DNDC = $User.distinguishedName.ToString()
	$DC = ",DC=omzglobal,DC=com"
	$DN = $DNDC.Trimend($DC)
	$Result.AppendLine($DN) | Out-Null
 }       
}

#��������� ��������� ������� � ����
If($Result.ToString()) {
	$Result.ToString() | Out-File "$Path\DN.txt"
}

#��������� ��� ������
If($Success.ToString()) {
	$Success.ToString() | Out-File "$Path\success.log" -Append
}

#��������� ��� ������
If($Log.ToString()) {
	$Log.ToString() | Out-File "$Path\error.log" -Append
}