#
# User sync omzgloal.com -> uzxm.ktalk.ru
#

$cred = Get-StoredCredential -Target ktalk:uzxm

$URI = "https://$($cred.UserName).ktalk.ru/Users"

$URI
