#
# Настройка баз 1С
#
$dst = Join-Path $env:APPDATA 1C\1CEStart
$src = Split-Path $PSCommandPath -Parent
$src = Join-Path $src ibases.v8i
Copy-Item $src $dst
