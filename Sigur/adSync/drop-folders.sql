-- Delete folders, containing no users
delete from
  personal
where
  EMP_TYPE = 'EMP'
  and ID in (
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
    )
    select
      id
    from
      fcounts
    where
      allp = 0
  )
