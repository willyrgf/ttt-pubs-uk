
-- drop function before
drop function if exists ttt.store_user_pub_rating;

/*
store_user_pub_rating is a function to store the pub rating by our users 
with three input args:
    v_username citext: the username of user
    v_pub_name citext: the name of the pub
    v_rating numeric: the rating to the pub

and one output arg:
    v_return uuid: the uuid of the rating pub inserted
*/
create or replace function ttt.store_user_pub_rating(
    v_username citext,
    v_pub_name citext,
    v_rating numeric,
    out v_return uuid
)
returns uuid
language plpgsql
as $$
declare
    v_user_id uuid;
    v_pub_id uuid;

begin

    if not(v_rating >= 0 and v_rating <= 100) then
        raise exception 'v_rating must be between 0 and 100: %', v_rating;
    end if;

    v_user_id := (
        select u.id 
        from ttt.users u 
        where u.username = v_username and u.deleted_at is null
    );
    v_pub_id := (
        select p.id 
        from ttt.pubs p 
        where p.name = v_pub_name and p.deleted_at is null limit 1
    );

    if v_user_id is null then
        raise exception 'v_username doesnt exist: %', v_username;
    end if;

    if v_pub_id is null then
        raise exception 'v_pub_name doesnt exist: %', v_pub_name;
    end if;

    insert into
        ttt.pubs_user_rating (
            pub_id,
            user_id,
            rating 
        )
        values (
            v_pub_id,
            v_user_id,
            v_rating
        )
        returning id into v_return;

end;

$$;

