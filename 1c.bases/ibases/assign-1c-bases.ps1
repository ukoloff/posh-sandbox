#
# Назначение баз 1С пользователю
#
$Groups = 'OU=1CBase,OU=Service,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'
$stopGroup = 'UZHM-1C не переписывать базы'
$null = $stopGroup  # ^ Не используется

$ini = "$($env:APPDATA)\1C\1CEStart\ibases.v8i"

# List 1C groups
$s = [ADSISearcher]"(objectClass=group)"
$s.SearchRoot = [ADSI]"LDAP://$Groups"
$null = $s.PropertiesToLoad.Add('info')
$null = $s.PropertiesToLoad.Add('sAMAccountName')
$g = $s.FindAll()

# List my groups
# https://www.secuinfra.com/en/techtalk/adsisearcher-resolve-groups-recursively/
$me = [ADSISearcher]"(&(objectClass=user)(sAMAccountName=$($env:USERNAME)))"
$me = $me.FindOne().Properties.distinguishedname
$s = [ADSISearcher]"(&(objectClass=group)(member:1.2.840.113556.1.4.1941:=$me))"
$null = $s.PropertiesToLoad.Add('sAMAccountName')
$myG = $s.FindAll()
