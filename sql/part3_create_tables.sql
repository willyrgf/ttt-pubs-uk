-- drop all before
drop table if exists ttt.pubs_user_comments;
drop table if exists ttt.users;

-- create the table and indexes
create table ttt.users(
    id uuid default uuid_generate_v4(),
    username citext,
    created_at timestamp with time zone default now(),
    deleted_at timestamp with time zone default null,
    primary key (id)
);
create index idx_users_deleted_at on ttt.users (deleted_at desc nulls last);
create index idx_users_username on ttt.users(username);

-- create the table and indexes
create table ttt.pubs_user_comments(
    id uuid default uuid_generate_v4(),
    user_id uuid,
    pub_id uuid,
    comment character(140),
    created_at timestamp with time zone default now(),
    primary key (id),
    constraint fk_pubs_user_comment_user foreign key (user_id) references ttt.users(id),
    constraint fk_pubs_user_comment_pub foreign key (pub_id) references ttt.pubs(id)
);
create index idx_pubs_user_comments_created_at_pub_id on ttt.pubs_user_comments (created_at desc nulls last, pub_id);

