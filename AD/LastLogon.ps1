$base = 'OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'

Get-ADUser -SearchBase $base -Filter * -Properties Enabled, SamAccountName, whenCreated, whenChanged, lastLogon, logonCount, badPasswordTime, DistinguishedName |
Select Name, Enabled, SamAccountName, whenCreated, whenChanged, @{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}}, logonCount, DistinguishedName |
Sort-Object Enabled | FT
