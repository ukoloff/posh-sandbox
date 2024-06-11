# https://winitpro.ru/index.php/2016/04/19/vypolnenie-mysql-zaprosov-iz-powershell/
#
# Install-Module -Name SimplySql
#

$cred = Get-StoredCredential -Target 'mysql:SKUD'

$sql = Open-MySqlConnection -ConnectionName Sigur -Server srvskud-ekbh1 -Port 3305 -Database  tc-db-main -Credential $cred

