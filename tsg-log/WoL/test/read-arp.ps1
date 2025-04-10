#
# Get & Update ARP table
#
$cred = Get-StoredCredential -Target pqsql:TSG  # Fallback to Kerberos if not found
Open-PostGreConnection -Server pg.ekb.ru -Database uxm -Credential $cred
Start-SqlTransaction

$j = Invoke-WebRequest https://nc.ekb.ru/omz/service/arp |
Select-Object -ExpandProperty Content |
ConvertFrom-Json
$j | ForEach-Object {
  # https://stackoverflow.com/a/17267423/6127481
  $null = Invoke-SqlUpdate @"
    merge into arp using (values
      (@ip, @mac, clock_timestamp()))
      as vals (ip, mac, mtime)
      on arp.ip = vals.ip
  when matched then
  update
    set
      mac = vals.mac,
      mtime = vals.mtime
  when not matched then
    insert (ip, mac, mtime)
    values (vals.ip, vals.mac, vals.mtime)
"@ -ParamObject $_
}

Complete-SqlTransaction
Close-SqlConnection
