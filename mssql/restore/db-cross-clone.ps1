#
# Восстановить БД из бэкапа на другом сервере
#
$src = "SRVSQL-1C"
$dst = "SRVSQL-1Ctests"
$dstFolder = "E:\"

$DBs = @{
  stas       = @{
    # skip = $true
    dst = 'stas2'
  }
  UPRIT_WORK = @{
    skip = $true
  }
  OP_WORK    = @{
    skip = $true
    dst  = 'OP_TEST2'
  }
  ERP_WORK   = @{
    skip = $true
    dst  = 'ERP_WORK_TEST'
  }
  ZUP_20     = @{
    skip = $true
    dst  = 'ZUP_20_TEST'
  }
}
