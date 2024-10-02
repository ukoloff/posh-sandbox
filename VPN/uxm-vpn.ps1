#
# Настройка VPN @Уралхиммаш
#
function isAdmin {
  $user = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $user.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

