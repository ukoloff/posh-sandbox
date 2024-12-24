#
# Обновление Компас с v21 на v22
#
$src = '\\omzglobal.com\uxm\Distribute\kompas\KOMPAS-3D_v22_x64\'

if (!(Test-Path HKLM:\SOFTWARE\ASCON\KOMPAS-3D\21)) {
  exit
}

Stop-Process -Name kompas -Force -ErrorAction SilentlyContinue

$kompas21 = '{05AB476A-CCCF-456F-B37F-43DDD7AE5F72}'

msiexec.exe /X $kompas21 /passive | Write-Verbose

$modules = Join-Path $src Modules
$msi = Join-Path $modules KOMPAS-3D_v22_x64.msi
msiexec /i $msi /passive | Write-Verbose

foreach ($msi in (Get-ChildItem $modules -Filter *.msi -File)) {
  if ($msi.Name -contains '-3D') {
    continue
  }
  msiexec /i $msi.FullName /passive | Write-Verbose
}

foreach ($msi in (Get-ChildItem $src -Filter *.msi -File)) {
  msiexec /i $msi.FullName /passive | Write-Verbose
}

foreach ($msi in (Get-ChildItem $src -Filter *.msp -File -Recurse)) {
  msiexec /update $msi.FullName /passive | Write-Verbose
}

$lic = Join-Path $src license.ini
$licDst = Join-Path $env:ProgramData ASCON
Copy-Item $lic $licDst -Force
