#
# Sigur backup
#
$src = 'c:\Program Files (x86)\SIGUR access management\server\autobackup'
$dst = '\\DATATRASH\Sigur$'

$Days = [PSCustomObject]@{
  zip  = 3
  move = 3
  drop = 42
}

$d = Get-Date
$d = $d.AddDays(-$Days.zip)
Get-ChildItem -Path $src -File -Filter *.sql |
Where-Object { $_.LastAccessTime -le $d } |
ForEach-Object {
  $f = $_.FullName
  7z a -sdel "$f.7z" $f
}
