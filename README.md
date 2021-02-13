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


# Part 2: Ratings

## 1. Store rating
To more details, [check here](https://github.com/willyrgf/ttt-pubs-uk/blob/9b76c7ba6d306041fda47d93a731f553412d0267/sql/part2_create_functions.sql#L5)

```sql
/*
store_pub_rating is a function to store the pub rating by our reviewer with
two input args:
    v_name citext: the name of the pub
    v_rating numeric: the rating to the pub
and one output arg:
    v_return uuid: the uuid of the rating pub inserted
*/

select ttt.store_pub_rating('Simmons', 93);
```

## 2. Highest rated pub with city
To more details, [check here](https://github.com/willyrgf/ttt-pubs-uk/blob/9b76c7ba6d306041fda47d93a731f553412d0267/sql/part2_create_functions.sql#L110)

```sql
/*
get_highest_rated_pubs_with_cities is a function to get the pub highest rated 
by our reviewer with one arg:
    v_quantity numeric: the number of pubs retrivied, default is 1
*/

select * from ttt.get_highest_rated_pubs_with_cities();
```

- A query result example: https://share.sqltabs.com/api/1.0/docs/d8abe2638151b9e09ed86d8ab17c0bcf?echo=true

## 3. Highest rated pubs in a city
To more details, [check here](https://github.com/willyrgf/ttt-pubs-uk/blob/9b76c7ba6d306041fda47d93a731f553412d0267/sql/part2_create_functions.sql#L179)

```sql
/*
get_highest_pubs_in_a_city is a function to get the pub highest rated 
by our reviewer in a city with two args:
    v_name citext: the name of the city of the user
    v_quantity numeric: the number of pubs retrivied, default is 3
*/

select * from ttt.get_highest_pubs_in_a_city('london');
```

- A query result example: https://share.sqltabs.com/api/1.0/docs/cac4574c7e2b777c5b9f4dcf56274351?echo=true


