#
# Назначение баз 1С пользователю
#
$Groups = 'OU=1CBase,OU=Service,OU=EKBH,OU=uxm,OU=MS,DC=omzglobal,DC=com'
$stopGroup = 'UZHM-1C не переписывать базы'
$null = $stopGroup  # ^ Не используется

$s = [adsisearcher]"(objectClass=group)"
$s.SearchRoot = [adsi]"LDAP://$Groups"
$s.PropertiesToLoad.Add('info')
$s.FindAll()
