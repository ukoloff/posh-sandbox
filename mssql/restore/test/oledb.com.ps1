#
# Test New-Object System.Data.OleDb
#
$b = New-Object System.Data.OleDb.OleDbConnectionStringBuilder
$b.Provider = 'sqloledb'
$b.Add('Integrated Security', 'SSPI')
$b.Add('Data Source', "SRVSQL-1C")
$b.Add('Initial Catalog', 'msdb')

$conn = New-Object -ComObject ADODB.Connection
$conn.Open($b.ConnectionString)


$cmd = New-Object -ComObject ADODB.Command
$cmd.ActiveConnection = $conn
$cmd.CommandText = @"
  Select
    *
  From
    backupset
  -- Where
  --  database_name = @db
"@
$r = $cmd.Execute()
& {
  while (!$r.EOF) {
    $row = [ordered]@{}
    foreach ($f in $r.Fields) {
      $row[$f.Name] = $f.Value
    }
    $r.MoveNext()
    [PSCustomObject]$row
  } } |
Out-GridView

