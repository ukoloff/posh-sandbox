##################################################
# �����: ������ ���� Mail: sorvin@ekb.ru
# ����: 03-06-2019 ������: 1.0
# ����������: ������ ��������� ����������� �� ����������
##################################################
Clear-Host

#������� ��������� true, ���� �������� ���� ��������� � false  - � ��������� ������
function Test-Host ($Name)
{
    $ping = new-object System.Net.NetworkInformation.Ping
    trap {Write-Verbose "������ �����"; $False; continue}
    if ($ping.send($Name).Status -eq "Success" ) { $True }
    else { $False }
}

#����� ���� ��� ��� ����
#$SearchRoot="OU=Computers,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com"

#����� ���� ����� ��� ������ ������� Skud.ps1 ������� 15.05.2023 ����� �.�.
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
#�������� ������� -ManagedBy ������������� -UserPrincipalName, �.�. ������ ������� ����� ������� � AD � ��������� ������� "��� ����� ������������"
#� ������ �� ������������ ������ ����������. 28.04.2023�. ����� �.�.