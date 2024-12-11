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

$d = Get-Date
$d = $d.AddDays(-$Days.move)
Get-ChildItem -Path $src -File -Filter *.7z |
Where-Object { $_.CreationTime -le $d } |
ForEach-Object {
  Move-Item $_.FullName $dst -Force
}

$d = Get-Date
$d = $d.AddDays(-$Days.drop)
Get-ChildItem -Path $dst -File -Filter *.7z |
Where-Object { $_.CreationTime -le $d } |
Where-Object { $_.Name -notcontains "-01.sql." } |
ForEach-Object {
  Remove-Item $_.FullName
}
