-- drop all before
drop table if exists ttt.pubs_user_rating;

-- create the table and indexes
create table ttt.pubs_user_rating(
    id uuid default uuid_generate_v4(),
    pub_id uuid,
    user_id uuid,
    rating numeric,
    created_at timestamp with time zone default now(),
    deleted_at timestamp with time zone default null,
    primary key (id),
    unique(pub_id, user_id),
    constraint fk_pubs_user_rating_pub_id foreign key (pub_id) references ttt.pubs(id),
    constraint fk_pubs_user_rating_user_id foreign key (user_id) references ttt.users(id)
);
create index idx_pubs_user_rating_pub_id on ttt.pubs_user_rating (pub_id);


-- a materialized view to get the avg of the rating to the pubs by users
create materialized view ttt.pubs_user_rating_avg as (
    select
        pur.pub_id,
        p.name as pub_name,
        avg(pur.rating) as avg_rating
    from
        ttt.pubs_user_rating pur
        join ttt.pubs p on p.id = pur.pub_id
    where
        true
        and pur.deleted_at is null
    group by pur.pub_id, p.name
    order by p.name
);
create unique index idx_unique_pubs_user_rating_avg on ttt.pubs_user_rating_avg(pub_id, pub_name);

-- create a cron job to refresh the materialized view
\c gis;
insert into
  cron.job(
    schedule,
    command,
    nodename,
    nodeport,
    database,
    username
  )
values
  (
    '* * * * * *',
    $$ refresh materialized view concurrently ttt.pubs_user_rating_avg $$,
    'localhost',
    '5432',
    'pubsuk',
    'postgres'
  );

