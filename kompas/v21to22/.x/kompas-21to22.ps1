﻿#
# Обновление Компас с v21 на v22
#
$src = '\\omzglobal.com\uxm\Distribute\kompas\KOMPAS-3D_v22_x64\'
$cadMech = '\\imech\IPS.InstClient\CADSystem\Setup_CAD_IPS.exe'

if (!(Test-Path HKLM:\SOFTWARE\ASCON\KOMPAS-3D\21)) {
#  exit
}

function timeStamp() {
  "[$(Get-Date -UFormat '%Y-%m-%d %T %Z')]`t"
}

$Log = Join-Path $src Logs
$Log = Join-Path $Log (Get-Date -UFormat '%Y-%m-%d')
$Log = New-Item $Log -Force -ItemType Directory
$Log = Join-Path $Log "$($env:COMPUTERNAME)@$((Get-Date).ToString("HH-mm-ss_fff")).log"

function doKompas {
  Write-Output "$(timeStamp)Host:`t$($env:COMPUTERNAME)"
  Write-Output @"
$(timeStamp)Users:`t$((
  Get-Process -IncludeUserName |
  Select-Object -ExpandProperty UserName -Unique |
  Where-Object {$_ -notmatch ' '} |
  Sort-Object) -join ' ')
"@

  $modules = Join-Path $src Modules
  $msi = Join-Path $modules KOMPAS-3D_v22_x64.msi

  $lic = Join-Path $src license.ini
  $licDst = Join-Path $env:ProgramData ASCON
  Write-Output "$(timeStamp)Copying licensing config: $licDst"
  Copy-Item $lic $licDst -Force

  foreach ($msi in (Get-ChildItem $modules -Filter *.msi -File)) {
    if ($msi.Name.Contains('-3D')) {
      continue
    }
    Write-Output "$(timeStamp)Installing: $($msi.FullName)"
    msiexec /i $msi.FullName /passive /norestart | Write-Verbose
  }

  foreach ($msi in (Get-ChildItem $src -Filter *.msi -File)) {
    Write-Output "$(timeStamp)Installing: $($msi.FullName)"
    msiexec /i $msi.FullName /passive /norestart | Write-Verbose
  }

  foreach ($msi in (Get-ChildItem $src -Filter *.msp -File -Recurse)) {
    Write-Output "$(timeStamp)Patching: $($msi.FullName)"
    msiexec /update $msi.FullName /passive /norestart | Write-Verbose
  }

  if (Test-Path c:\IM -PathType Container) {
    $exe = 'c:\IM\UNWISE.EXE'
    $log = 'c:\IM\Install.log'
    $exeOk = Test-Path $exe -PathType Leaf
    $logOk = Test-Path $log -PathType Leaf
    if ($exeOk -and $logOk) {
      Write-Output "$(timeStamp)Removing CadMech"
      &$exe /S /Z $log | Write-Verbose
    }
    Write-Output "$(timeStamp)Removing CadMech folder"
    Remove-Item c:\IM\ -Recurse -Force

    Write-Output "$(timeStamp)Installing CadMech: $cadMech"
    &$cadMech | Write-Verbose
  }

  Write-Output "$(timeStamp)That's all folks!"
}

doKompas >$Log 2>&1
