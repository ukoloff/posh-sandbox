# Access to TSG

Enumerate access to TS Gateway

## Log
```SQL
select
	"user",
	date_trunc('month', start)::date as "month",
	count(*) as "count",
	count(distinct date_part('day', start)) as days,
	sum(duration) as "seconds",
	sum(inb) as "inBytes",
	sum(outb) as "outBytes"
from
	tsg
where
	start >= '2025-01-01'
group by
	"user",
	date_trunc('month', start)::date
order by
	1, 2
```
