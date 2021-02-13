# ttt-pubs-uk

# Part 1: Initial

## 1. Create and Populate tables
### For populate from data files
To more details, [check here](https://github.com/willyrgf/ttt-pubs-uk/blob/2fdbdd2fce8a69e56100f0d97db7e64c37c0b0b7/start_all.sh#L43)

```sh
awk -F '\t' '{print $2 "\t" $3}' data/cities.tsv | 
    psql -d ${POSTGRES_DBNAME} \
    -c "copy ttt.cities(location, name) from stdin delimiter E'\t'"

awk -F '\t' '{print $2 "\t" $3}' data/pubs.tsv | 
    psql -d ${POSTGRES_DBNAME} \
    -c "copy ttt.cities(location, name) from stdin delimiter E'\t'"
```

### For create pubs
To more details, [check here](https://github.com/willyrgf/ttt-pubs-uk/blob/2fdbdd2fce8a69e56100f0d97db7e64c37c0b0b7/sql/part1_create_functions.sql#L5)

```sql
/*
create_pub is a function to create a pub in the ttt.pubs table with
two input args:
    v_name citext: the name of the pub
    v_location point: the location in coordinates of the pub

and one output arg:
    v_return uuid: the uuid of the pub inserted
*/
select ttt.create_pub('Wills Pub', '(-0.126666,51.66666)');
```

## 2. For get 5 nearest pubs
To more details, [check here](https://github.com/willyrgf/ttt-pubs-uk/blob/2fdbdd2fce8a69e56100f0d97db7e64c37c0b0b7/sql/part1_create_functions.sql#L46)

```sql
/*
get_nearest_pubs is a function to get the pubs nearest from a location with
two input args:
    v_location point: the base location of the user
    v_quantity numeric: the number of pubs retrivied, default is 5
*/

select * from ttt.get_nearest_pubs('(-0.728899, 51.012099)', 5);
```

- A query result example: https://share.sqltabs.com/api/1.0/docs/0912bbff7ebc29751e379bbe39af53f4?echo=true

## 3. For get 5 nearest pubs with miles (Bonus)
To more details, [check here](https://github.com/willyrgf/ttt-pubs-uk/blob/2fdbdd2fce8a69e56100f0d97db7e64c37c0b0b7/sql/part1_create_functions.sql#L98)

```sql
/*
get_nearest_pubs_with_miles is a function to get the pubs nearest from 
a location and calculate how many miles you are from the pub with
two input args:
    v_location point: the base location of the user
    v_quantity numeric: the number of pubs retrivied, default is 5
*/

select * from ttt.get_nearest_pubs_with_miles('(-0.728899, 51.012099)', 10);
```

- A query result example: https://share.sqltabs.com/api/1.0/docs/142db96cfec289cc11f5e24c6e08d31f?echo=true


# Part 3: Comments

## 1. Store comments
To more details, [check here](https://github.com/willyrgf/ttt-pubs-uk/blob/0eb1f2d8ba8844f038b2ba1d5f7cb76303fc01bd/sql/part3_create_functions.sql#L42)

```sql
/*
store_comment is a function to store a comment from a user 
in the ttt.pubs_user_comments table with three args:
    v_username citext: the username of the user
    v_pub_name citext: the name of the pub
    v_comment character(140): the comment
and one output arg:
    v_return uuid: the uuid of the pub inserted
*/

select ttt.store_comment('willy', 'simmons', 'its my comment, idk what i can say, because i never have had');
```

## 2. Get recent comments of a pub
To more details, [check here](https://github.com/willyrgf/ttt-pubs-uk/blob/0eb1f2d8ba8844f038b2ba1d5f7cb76303fc01bd/sql/part3_create_functions.sql#L110)

```sql
/*
get_recents_comments is a function to get the recent comments of the pubs
by our users with two args:
    v_pub_name citext: the name of the pub
    v_interval interval: the interval of time that we will get comments 
    default is '1 week'
*/

select * from ttt.get_recents_comments('simmons');
```

- A query result example: https://sql.cryp.com.br/api/1.0/docs/a6d8d616a71c3b1d18e30453afba0e39?echo=true
