#
# Добавка к Компас 22, чтобы работал Polynom
#
$src = '\\omzglobal.com\uxm\Distribute\kompas\KOMPAS-3D_v22_x64\'

if (!(Test-Path HKLM:\SOFTWARE\ASCON\KOMPAS-3D\22)) {
  exit
}

$Log = Join-Path $src Logs/p
$Log = Join-Path $Log (Get-Date -UFormat '%Y-%m-%d')
$Log = New-Item $Log -Force -ItemType Directory
$Log = Join-Path $Log "$($env:COMPUTERNAME)@$((Get-Date).ToString("HH-mm-ss_fff")).log"
function timeStamp() {
  "[$(Get-Date -UFormat '%Y-%m-%d %T %Z')]`t"
}

function doPolynom {
  foreach ($exe in Get-ChildItem $src -Recurse -Filter *-runtime-*.exe) {
    Write-Output "$(timeStamp)Installing:`t$($exe.FullName)"
    & $exe.FullName /passive /norestart | Write-Verbose
  }

  foreach ($msp in Get-ChildItem $src -Recurse Polynom*.msp) {
    Write-Output "$(timeStamp)Pathching:`t$($msp.FullName)"
    msiexec /update $msp.FullName /passive /norestart | Write-Verbose
  }

  Write-Output "$(timeStamp)That's all folks!"
}

doPolynom >$Log 2>&1
