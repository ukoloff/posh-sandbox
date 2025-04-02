#
# Test New-Object System.Data.OleDb
#
$b = New-Object System.Data.OleDb.OleDbConnectionStringBuilder
$b.Provider = 'sqloledb'
$b.Add('Integrated Security', 'SSPI')
$b.Add('Data Source', "SRVSQL-1C")
$b.Add('Initial Catalog', 'msdb')

$conn = New-Object System.Data.OleDb.OleDbConnection $b.ConnectionString
$conn.Open()

$cmd = $conn.CreateCommand()
$cmd.CommandText = @"
  Select
    *
  From
    backupset
  Where
    database_name = ?
"@
# $cmd.Parameters.AddWithValue('@db', 'ERP_WORK')
# $cmd.Parameters.Add('@db', [Data.SQLDBType]::varchar).Value = 'ERP_WORK'
$cmd.Parameters.Add('@db', 12).Value = 'ERP_WORK'
# ^^^ 12 = Variant
# https://learn.microsoft.com/ru-ru/dotnet/api/system.data.oledb.oledbtype?view=net-8.0
$r = $cmd.ExecuteReader()
& {
  while ($r.Read()) {
    $row = [ordered]@{}
    foreach ($i in 1..$r.FieldCount) {
      $row[$r.GetName($i - 1)] = $r.GetValue($i - 1)
    }
    [PSCustomObject]$row
  } } |
Out-GridView

