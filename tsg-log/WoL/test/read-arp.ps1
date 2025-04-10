#
# Get & Update ARP table
#
Invoke-WebRequest https://nc.ekb.ru/omz/service/arp |
ConvertFrom-Json
