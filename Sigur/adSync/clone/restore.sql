drop table if exists ` personal `;

create table ` personal ` like ` personal.clone `;

insert into
  ` personal `
select
  *
from
  ` personal.clone `;
