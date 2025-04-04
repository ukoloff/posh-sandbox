with recursive layer(u, d) as(
  select
    U.ID,
    D.ID
  from
    personal as U
    join personal as D on U.ID = D.PARENT_ID
),
tree(u, d, h) as(
  select
    *,
    1
  from
    layer
  union
  select
    L.u,
    R.d,
    L.h + 1
  from
    tree as L
    join layer as R on L.d = R.u
),
roots(id) as (
  select
    ID
  from
    personal
  where
    ID not in(
      select
        distinct d
      from
        layer
    )
),
leaves(id) as (
  select
    ID
  from
    personal
  where
    ID not in(
      select
        distinct u
      from
        layer
    )
)
select
  *
from
  roots
