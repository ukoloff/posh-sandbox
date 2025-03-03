#
# Очистка правил брандмауэра на терминальных серверах
#
# https://winitpro.ru/index.php/2018/05/18/medlenno-rabotayut-remoteapp-problemy-menyu-windows-10/
# https://learn.microsoft.com/en-us/archive/msdn-technet-forums/992e86c8-2bee-4951-9461-e3d7710288e9
#

# Clean on exit
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy" -Type DWord -Name DeleteUserAppContainersOnLogoff -Value 1

# Cleanup Inbound Rules:
$FWInboundRules = Get-NetFirewallRule -Direction Inbound |
Where { $_.Owner -ne $Null } |
sort Displayname, Owner
$FWInboundRulesUnique = Get-NetFirewallRule -Direction Inbound |
Where { $_.Owner -ne $Null } |
sort Displayname, Owner -Unique

Write-Host "# inbound rules         : " $FWInboundRules.Count
Write-Host "# inbound rules (Unique): " $FWInboundRulesUnique.Count

if ($FWInboundRules.Count -ne $FWInboundRulesUnique.Count) {
    $Diff = Compare-Object -referenceObject $FWInboundRules  -differenceObject $FWInboundRulesUnique
    Write-Host "# rules to remove       : " $diff.Count
    $diff   |
    select -ExpandProperty inputobject |
    Remove-NetFirewallRule
}

# Cleanup Outbound Rules
$FWOutboundRules = Get-NetFirewallRule -Direction Outbound |
Where { $_.Owner -ne $Null } |
sort Displayname, Owner
$FWOutboundRulesUnique = Get-NetFirewallRule -Direction Outbound |
Where { $_.Owner -ne $Null } |
sort Displayname, Owner -Unique

Write-Host "# outbound rules         : : " $FWOutboundRules.Count
Write-Host "# outbound rules (Unique): " $FWOutboundRulesUnique.Count

if ($FWOutboundRules.Count -ne $FWOutboundRulesUnique.Count) {
    $diff = Compare-Object -referenceObject $FWOutboundRules  -differenceObject $FWOutboundRulesUnique
    Write-Host "# rules to remove       : " $diff.Count
    $diff   |
    select -ExpandProperty inputobject |
    Remove-NetFirewallRule
}

# Cleanup Configurable Service Rules
$FWConfigurableRules = Get-NetFirewallRule -policystore configurableservicestore |
Where { $_.Owner -ne $Null } |
sort Displayname, Owner
$FWConfigurableRulesUnique = Get-NetFirewallRule -policystore configurableservicestore |
Where { $_.Owner -ne $Null } |
sort Displayname, Owner -Unique

Write-Host "# service configurable rules         : " $FWConfigurableRules.Count
Write-Host "# service configurable rules (Unique): " $FWConfigurableRulesUnique.Count

if ($FWConfigurableRules.Count -ne $FWOutboundRulesUnique.Count) {
    $diff = Compare-Object -referenceObject $FWConfigurableRules  -differenceObject $FWConfigurableRulesUnique
    Write-Host "# rules to remove                    : " $diff.Count
    $diff   |
    select -ExpandProperty inputobject |
    Remove-NetFirewallRule
}
