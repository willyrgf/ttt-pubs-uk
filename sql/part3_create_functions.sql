-- drop function before
drop function if exists ttt.create_user;

/*
create_user is a function to create a user in the ttt.users table with
one arg:
    v_username citext: the name of the pub

and one output arg:
    v_return uuid: the uuid of the pub inserted
*/
create or replace function ttt.create_user(
    v_username citext,
    out v_return uuid
)
returns uuid
language plpgsql
as $$

begin

    if v_username = '' then
        raise exception 'v_username input arg is empty: %', v_username;
    end if;

    insert into
        ttt.users (
            username
        )
        values (
            v_username
        )
        returning id into v_return;
end;

$$;

-- drop function before
drop function if exists ttt.store_comment;

/*
store_comment is a function to store a comment from a user 
in the ttt.pubs_user_comments table with three args:
    v_username citext: the username of the user
    v_pub_name citext: the name of the pub
    v_comment character(140): the comment

and one output arg:
    v_return uuid: the uuid of the pub inserted
*/
create or replace function ttt.store_comment(
    v_username citext,
    v_pub_name citext,
    v_comment character(140),
    out v_return uuid
)
returns uuid
language plpgsql
as $$

declare
    v_user_id uuid;
    v_pub_id uuid;

begin

    if length(v_comment) < 10 then
        raise exception 'length of v_comment must be greater than 10: %', v_comment;
    end if;

    v_user_id := (select u.id from ttt.users u where u.username = v_username);
    v_pub_id := (select p.id from ttt.pubs p where p.name = v_pub_name limit 1);

    if v_user_id is null then
        raise exception 'v_username doesnt exist: %', v_username;
    end if;

    if v_pub_id is null then
        raise exception 'v_pub_name doesnt exist: %', v_pub_name;
    end if;


    insert into
        ttt.pubs_user_comments (
            user_id,
            pub_id,
            comment
        )
        values (
            v_user_id,
            v_pub_id,
            v_comment
        )
        returning id into v_return;
end;

$$;


-- drop function before
drop function if exists ttt.get_recents_comments;

/*
get_recents_comments is a function to get the recent comments of the pubs
by our users with two args:
    v_pub_name citext: the name of the pub
    v_interval interval: the interval of time that we will get comments 
    default is '1 week'
*/
create or replace function ttt.get_recents_comments(
    v_pub_name citext,
    v_interval interval default '1 week'::interval
)
returns table (
    id uuid,
    pub_id uuid,
    user_id uuid,
    username citext,
    pub_name citext,
    comment character(140),
    created_at timestamp with time zone
)
language plpgsql
as $$

declare
    v_pub_id uuid;

begin

    v_pub_id := (select p.id from ttt.pubs p where p.name = v_pub_name limit 1);

    if v_pub_id is null then
        raise exception 'v_pub_name doesnt exist: %', v_pub_name;
    end if;


    return query (
        select
            puc.id,
            puc.pub_id,
            puc.user_id,
            u.username,
            p.name as pub_name,
            puc.comment,
            puc.created_at
        from
            ttt.pubs_user_comments puc
            join ttt.users u on u.id = puc.user_id
            join ttt.pubs p on p.id = v_pub_id
        where
            true
            and puc.created_at > (now()-v_interval)
            and puc.pub_id = v_pub_id
    );

end;

$$;

