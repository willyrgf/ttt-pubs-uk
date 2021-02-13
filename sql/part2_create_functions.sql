-- drop function before
drop function if exists ttt.store_pub_rating;

/*
store_pub_rating is a function to store the pub rating by our reviewer with
two input args:
    v_name citext: the name of the pub
    v_rating numeric: the rating to the pub

and one output arg:
    v_return uuid: the uuid of the rating pub inserted
*/
create or replace function ttt.store_pub_rating(
    v_name citext,
    v_rating numeric,
    out v_return uuid
)
returns uuid
language plpgsql
as $$

begin

    if v_name = '' then
        raise exception 'v_name input arg is empty: %', v_name;
    end if;

    if not(v_rating >= 0 and v_rating <= 100) then
        raise exception 'v_rating must be between 0 and 100: %', v_rating;
    end if;

    insert into
        ttt.pubs_reviewer_rating (
            pub_id,
            rating 
        )
        (
            select
                p.id as pub_id,
                v_rating as rating
            from ttt.pubs p
                where p.name = v_name
            limit 1
        )
        returning id into v_return;

    if v_return is null then
        raise exception 'pub v_name doesnt exist: %', v_name;
    end if;

end;

$$;


-- drop function before
drop function if exists ttt.get_highest_rated_pub;

/*
get_highest_rated_pubs is a function to get the pub highest rated 
by our reviewer with one arg:
    v_quantity numeric: the number of pubs retrivied, default is 1
*/
create or replace function ttt.get_highest_rated_pubs(
    v_quantity numeric default 1
)
returns table (
     id uuid,
     pub_id uuid,
     rating numeric,
     created_at timestamp with time zone,
     deleted_at timestamp with time zone
)
language plpgsql
as $$

begin

    if v_quantity <= 0 then
        raise exception 'v_quantity input arg must be greater than 0: %',
        v_quantity;
    end if;


    return query (
        select
            r.id,
            r.pub_id,
            r.rating,
            r.created_at,
            r.deleted_at
        from
            ttt.pubs_reviewer_rating r
        where
            true
            and r.deleted_at is null
        order by
            rating desc
        limit v_quantity
    );

end;

$$;


-- drop function before
drop function if exists ttt.get_highest_rated_pubs_with_cities;

/*
get_highest_rated_pubs_with_cities is a function to get the pub highest rated 
by our reviewer with one arg:
    v_quantity numeric: the number of pubs retrivied, default is 1
*/
create or replace function ttt.get_highest_rated_pubs_with_cities(
    v_quantity numeric default 1
)
returns table (
    id uuid,
    pub_id uuid,
    city_id uuid,
    pub_name citext,
    city_name citext,
    rating numeric,
    created_at timestamp with time zone,
    deleted_at timestamp with time zone
)
language plpgsql
as $$

begin

    if v_quantity <= 0 then
        raise exception 'v_quantity input arg must be greater than 0: %',
        v_quantity;
    end if;


    return query (
        select
            r.id,
            r.pub_id,
            _city.id as city_id,
            p.name as pub_name,
            _city.name as city_name,
            r.rating,
            r.created_at,
            r.deleted_at
        from
            ttt.pubs_reviewer_rating r
        join ttt.pubs p on p.id = r.pub_id
        left join lateral (
            select
                c.id,
                c.name
            from ttt.cities c
            where
                true
                and c.deleted_at is null
            order by
                p.location <-> c.location
            limit 1
        ) as _city on true
        where
            true
            and r.deleted_at is null
        order by
            rating desc
        limit v_quantity
    );

end;

$$;


-- drop function before
drop function if exists ttt.get_highest_pubs_in_a_city;

/*
get_highest_pubs_in_a_city is a function to get the pub highest rated 
by our reviewer in a city with two args:
    v_quantity numeric: the number of pubs retrivied, default is 3
*/
create or replace function ttt.get_highest_pubs_in_a_city(
    v_name citext,
    v_quantity numeric default 3
)
returns table (
    id uuid,
    pub_id uuid,
    city_id uuid,
    pub_name citext,
    city_name citext,
    rating numeric,
    created_at timestamp with time zone,
    deleted_at timestamp with time zone
)
language plpgsql
as $$

begin

    if v_quantity <= 0 then
        raise exception 'v_quantity input arg must be greater than 0: %',
        v_quantity;
    end if;


    return query (
        select
            hpc.id,
            hpc.pub_id,
            hpc.city_id,
            hpc.pub_name,
            hpc.city_name,
            hpc.rating,
            hpc.created_at,
            hpc.deleted_at
        from
            ttt.get_highest_rated_pubs_with_cities(null) hpc
        where
            true
            and hpc.deleted_at is null
            and hpc.city_name = v_name
        order by
            rating desc
        limit v_quantity
    );

end;

$$;
