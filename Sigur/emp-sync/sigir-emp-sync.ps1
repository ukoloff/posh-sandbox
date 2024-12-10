#
# Update Sigur persons
#

$Server = 'srvskud-ekbh1-d'

$cred = Get-StoredCredential -Target 'mysql:SKUD'

Open-MySqlConnection -Server $Server -Port 3305 -Database  tc-db-main -Credential $cred
