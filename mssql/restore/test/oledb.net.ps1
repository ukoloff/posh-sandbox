#
# Test New-Object System.Data.OleDb
#
$b = New-Object System.Data.OleDb.OleDbConnectionStringBuilder
$b.Provider = 'sqloledb'
$b.Add('Integrated Security', 'SSPI')
$b.Add('Data Source', "SRVSQL-1C")
$b.Add('Initial Catalog', 'msdb')
$b.ConnectionString
