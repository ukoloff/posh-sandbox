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

