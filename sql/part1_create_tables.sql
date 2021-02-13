-- drop all before
drop table if exists ttt.cities;
drop table if exists ttt.pubs;

-- create the table and indexes
create table ttt.cities (
  id uuid default uuid_generate_v4(),
  name citext not null,
  location point not null,
  created_at timestamp with time zone default now(),
  deleted_at timestamp with time zone default null,
  primary key (id)
);
create index idx_cities_location on ttt.cities using gist(location);
create index idx_cities_deleted_at on ttt.cities (deleted_at desc nulls last);

-- create the table and indexes
create table ttt.pubs (
  id uuid default uuid_generate_v4(),
  name citext not null,
  location point not null,
  created_at timestamp with time zone default now(),
  deleted_at timestamp with time zone default null,
  primary key (id)
);
create index idx_pubs_location on ttt.pubs using gist(location);
create index idx_pubs_deleted_at on ttt.pubs (deleted_at desc nulls last);

