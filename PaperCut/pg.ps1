#
# Try access to PostgreSQL
#

# Install-Module -Name SimplySql

# Store Credentials:
# ------------------
# $cred = Get-Credential
# New-StoredCredential -Target pqsql:UXM -Credentials $cred -Persist LocalMachine
$cred = Get-StoredCredential -Target pqsql:UXM  # Try Kerberos if not found

Open-PostGreConnection -Server 'pg.ekb.ru' -Database uxm -Credential $null

$data = Invoke-SqlQuery "Select * from papercut" -AsDataTable
