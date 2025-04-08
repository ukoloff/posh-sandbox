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
),
people(id) as (
  select
    ID
  from
    personal
  where
    TYPE != 'DEP'
),
folders(id) as (
  select
    ID
  from
    personal
  where
    TYPE = 'DEP'
),
fcounts(id, ownp, allp, ownf, allf) as (
  select
    F.id,
    (
      select
        count(*)
      from
        layer
        join people on layer.d = people.id
      where
        layer.u = F.id
    ),
    (
      select
        count(*)
      from
        tree
        join people on tree.d = people.id
      where
        tree.u = F.id
    ),
    (
      select
        count(*)
      from
        layer
        join folders on layer.d = folders.id
      where
        layer.u = F.id
    ),
    (
      select
        count(*)
      from
        tree
        join folders on tree.d = folders.id
      where
        tree.u = F.id
    )
  from
    folders F
),
paths(id, path) as(
  select
    ID,
    (
      select
        GROUP_CONCAT(
          x.NAME
          order by
            h desc separator ' / '
        )
      from
        tree
        join personal x on tree.u = x.ID
      where
        tree.d = p.ID
    )
  from
    personal p
),
operators(id) as(
  select
    ID
  from
    personal p
  where
    USER_ENABLED
    and USER_T_SSPILOGIN
    and EXTID is not null
)
select
  *
from
  paths
