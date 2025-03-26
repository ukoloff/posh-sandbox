#
# Test New-Object System.Data.SqlClient
#
# https://stackoverflow.com/a/58139999/6127481
#
$b = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
$b.Server = "SRVSQL-1C"
$b.Database = 'msdb'
$b['Integrated Security'] = $true

$conn = New-Object System.Data.SqlClient.SqlConnection $b.ConnectionString
$conn.Open()

$cmd = $conn.CreateCommand()
$cmd.CommandText = @"
  Select
    *
  From
    backupset
  Where
    database_name = @db
"@
$cmd.Parameters.Add('@db', [System.Data.SqlDbType]::Variant).Value = 'ERP_WORK'
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
$r.Close()

# Table

$r = $cmd.ExecuteReader()
$t = New-Object System.Data.DataTable
$t.Load($r)
$t | Out-GridView
