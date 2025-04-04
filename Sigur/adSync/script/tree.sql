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
)
select
  *
from
  tree
