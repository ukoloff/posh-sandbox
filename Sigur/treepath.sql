with recursive roots as(
	select
		ID
	from
		personal p
	where
		ID = PARENT_ID
		or not exists (
			select
				*
			from
				personal x
			where
				x.ID = p.PARENT_ID
		)
),
ground as (
	select
		p.PARENT_ID,
		p.ID,
		1
	from
		roots r
		join personal p on r.ID = p.PARENT_ID
),
tree(id_a, id_z, level) as(
	select
		*
	from
		ground
	union
	select
		*
	from
		(
			select
				t.id_a,
				p.ID,
				t.level + 1
			from
				tree t
				join personal p on t.id_z = p.PARENT_ID
			union
			select
				t.id_z,
				p.ID,
				1
			from
				tree t
				join personal p on t.id_z = p.PARENT_ID
		) S2
),
paths as(
	select
		p.ID,
		p.NAME,
		group_concat(
			q.NAME
			order by
				tree.level desc separator '::'
		) as path
	from
		personal p
		left join tree on p.ID = tree.id_z
		left join personal q on tree.id_a = q.ID
	group by
		p.ID
)
select
	*
from
	paths
order by path
