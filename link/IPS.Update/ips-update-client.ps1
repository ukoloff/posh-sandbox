#
# Modify IPS Update Client script
#

$dst = 'C:\IPS\UpdateClient.bat'

if (Test-Path $dst -PathType Leaf) {
  $data = Get-Content $dst -Raw
  $fixed = $data -replace '([\\/])_(IPS.InstClient[\\/])', '$1$2'
  if ($data -ne $fixed) {
    Set-Content -Path $dst -Value $fixed -Force
  }
}
