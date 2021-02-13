-- drop all before
drop table if exists ttt.pubs_reviewer_rating;

-- create the table and indexes
create table ttt.pubs_reviewer_rating (
    id uuid default uuid_generate_v4(),
    pub_id uuid,
    rating numeric,
    created_at timestamp with time zone default now(),
    deleted_at timestamp with time zone default null,
    primary key (id),
    constraint fk_pub foreign key (pub_id) references ttt.pubs(id)
);

create index idx_pubs_reviewer_rating_deleted_at on ttt.pubs_reviewer_rating (deleted_at desc nulls last);
create index idx_pubs_reviewer_rating_rating on ttt.pubs_reviewer_rating (rating desc);

-- keep only one pub rating without deleted_at
create unique index idx_pubs_reviewer_rating_pub_id_deleted_at on ttt.pubs_reviewer_rating (pub_id) where deleted_at is null;

