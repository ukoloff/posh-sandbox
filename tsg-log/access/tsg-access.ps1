#
# Enumerate access to TS Gateway
#
$Groups = Write-Output  RDP RDP_UMZ Support RDP-enable-resourse

foreach ($g in $Groups) {
  (Get-ADGroup $g -Properties member).member |
  ForEach-Object {
    Get-ADUser $_ -Properties CanonicalName, Title |
    Select-Object Name, CanonicalName, Enabled, SamAccountName, Title
  } |
  Sort-Object Name |
  Export-Excel -WorksheetName $g
}

$cred = Get-StoredCredential -Target pqsql:TSG  # Fallback to Kerberos if not found
Open-PostGreConnection -Server 'pg.ekb.ru' -Database uxm -Credential $cred
Invoke-SqlQuery @"
select
	"user",
	to_char(date_trunc('month', start)::date, 'YYYY-MM') as "month",
	count(*) as "count",
	count(distinct date_part('day', start)) as days,
	sum(duration) as "seconds",
	sum(inb) as "inBytes",
	sum(outb) as "outBytes"
from
	tsg
where
	start >= date_trunc('month', now()::date - 42)
group by
	"user",
	date_trunc('month', start)::date
order by
	1, 2
"@ |
Export-Excel -WorksheetName Sessions
Close-SqlConnection
