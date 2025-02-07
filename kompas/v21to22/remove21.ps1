#
# Удалить остатки Компас v21 и Viewer v21
#
$src = '\\omzglobal.com\uxm\Distribute\kompas\KOMPAS-3D_v22_x64\'
$kompas21 = "$($env:ProgramFiles)\ASCON\KOMPAS-3D v21"

$K = Test-Path $kompas21 -PathType Container
$V = Test-Path 'HKLM:\SOFTWARE\ASCON\KOMPAS-3D Viewer\21'

if (!$K -and !$V) {
  exit
}

$Log = Join-Path $src Logs/rem
$Log = Join-Path $Log (Get-Date -UFormat '%Y-%m-%d')
$Log = New-Item $Log -Force -ItemType Directory
$Log = Join-Path $Log "$($env:COMPUTERNAME)@$((Get-Date).ToString("HH-mm-ss_fff")).log"

function timeStamp() {
  "[$(Get-Date -UFormat '%Y-%m-%d %T %Z')]`t"
}

function remove21 {
  Write-Output "$(timeStamp)Host:`t$($env:COMPUTERNAME)"
  Write-Output @"
$(timeStamp)Users:`t$((
  Get-Process -IncludeUserName |
  Select-Object -ExpandProperty UserName -Unique |
  Where-Object {$_ -notmatch ' '} |
  Sort-Object) -join ' ')
"@

  if ($K) {
    Write-Output "$(timeStamp)Removing Kompas v21 folder"
    Remove-Item $kompas21 -Recurse -Force
  }

  if ($V) {
    Write-Output "$(timeStamp)Removing Kompas v21 Viewer"
    $v21 = '{DC8BA2AE-D46B-49CA-BB21-A0871AB2991B}'
    msiexec.exe /X $v21 /passive /norestart | Write-Verbose
  }

  Write-Output "$(timeStamp)That's all folks!"
}

remove21 >$Log 2>&1
