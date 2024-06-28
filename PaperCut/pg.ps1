#
# Try access to PostgreSQL
#

# Install-Module -Name SimplySql
Open-PostGreConnection -Server 'pg.ekb.ru' -Database uxm -Credential $null

$data = Invoke-SqlQuery "Select * from papercut" -AsDataTable
