-- https://popsql.com/learn-sql/mysql/how-to-duplicate-a-table-in-mysql
drop table if exists ` personal.clone `;

create table ` personal.clone ` like ` personal `;

insert into
  ` personal.clone `
select
  *
from
  ` personal `;
