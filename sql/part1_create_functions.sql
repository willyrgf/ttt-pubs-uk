-- drop function before
drop function if exists ttt.create_pub;

/*
create_pub is a function to create a pub in the ttt.pubs table with
two input args:
    v_name citext: the name of the pub
    v_location point: the location in coordinates of the pub

and one output arg:
    v_return uuid: the uuid of the pub inserted
*/
create or replace function ttt.create_pub(
    v_name citext,
    v_location point,
    out v_return uuid
)
returns uuid
language plpgsql
as $$

begin

    if v_name = '' then
        raise exception 'v_name input arg is empty: %', v_name;
    end if;

    insert into
        ttt.pubs (
            name,
            location
        )
        values (
            v_name,
            v_location
        )
        returning id into v_return;
end;

$$;

-- drop function before
drop function if exists ttt.get_nearest_pubs;

/*
get_nearest_pubs is a function to get the pubs nearest from a location with
two input args:
    v_location point: the base location of the user
    v_quantity numeric: the number of pubs retrivied, default is 5
*/
create or replace function ttt.get_nearest_pubs(
    v_location point,
    v_quantity numeric default 5
)
returns table (
     id uuid,
     name citext,
     location point,
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
            p.id,
            p.name,
            p.location,
            p.created_at,
            p.deleted_at
        from
            ttt.pubs p
        where
            true
            and p.deleted_at is null
        order by
            p.location <-> v_location
        limit v_quantity
    );

end;

$$;

-- drop function before
drop function if exists ttt.get_nearest_pubs_with_miles;

/*
get_nearest_pubs_with_miles is a function to get the pubs nearest from 
a location and calculate how many miles you are from the pub with
two input args:
    v_location point: the base location of the user
    v_quantity numeric: the number of pubs retrivied, default is 5
*/
create or replace function ttt.get_nearest_pubs_with_miles(
    v_location point,
    v_quantity numeric default 5
)
returns table (
    id uuid,
    name citext,
    location point,
    approx_miles numeric,
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
        with _inner_pubs as (
            select
                gp.id,
                gp.name,
                gp.location,
                gp.created_at,
                gp.deleted_at
            from
                ttt.get_nearest_pubs(v_location, v_quantity) gp
        )
        select
            ip.id,
            ip.name,
            ip.location,
            (
                st_distancesphere(
                    geometry(v_location),
                    geometry(ip.location)
                ) / 1609 -- meters / 1000 = km; km * 1,609 = miles
            ) :: numeric(8, 2) as approx_miles,
            ip.created_at,
            ip.deleted_at
        from
        _inner_pubs ip
    );

end;

$$;
