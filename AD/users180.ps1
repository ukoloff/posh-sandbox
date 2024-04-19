#
# Users inactive for 180 days...
#
$date= (get-date).AddDays(-90)

Get-ADUser -Filter {LastLogonDate -lt $date} |Out-GridView
# Get-ADUser -Filter "(LastLogonDate -lt '$date')" |Out-GridView
# Get-ADUser -Filter {(LastLogonDate -lt $date) -and Enabled -eq $true} |Out-GridView
