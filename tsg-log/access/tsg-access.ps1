#
# Enumerate access to TS Gateway
#
$Groups = Write-Output  RDP RDP_UMZ Support RDP-enable-resourse

foreach ($g in $Groups) {
  (Get-ADGroup $g -Properties member).member |
  ForEach-Object {
    Get-ADUser $_ -Properties CanonicalName, Title |
    Select-Object Name, CanonicalName, Enabled, SamAccountName, Title |
    Sort-Object Name
  } |
  Export-Excel -WorksheetName $g
}
