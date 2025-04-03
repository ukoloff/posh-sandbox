-- Delete users, moved by ad-sigur-sync.ps1

delete from
  personal
where
  ID in (
    select
      p.ID
    from
      personal as p
      join personal as folder on p.PARENT_ID = folder.ID
      and folder.`TYPE` = 'DEP'
      and folder.STATUS = 'AVAILABLE'
      and folder.NAME in('-', '#', '!')
      join personal as root on folder.PARENT_ID = root.ID
      and not exists(
        select
          *
        from
          personal q
        where
          q.ID = root.PARENT_ID
      )
      and root.`TYPE` = 'DEP'
      and root.STATUS = 'AVAILABLE'
      join addomains ad on ad.DOMAIN_NAME = root.NAME
  )
