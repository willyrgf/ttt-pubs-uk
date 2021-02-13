-- creating some users
select ttt.create_user('willy');
select ttt.create_user('romao');
select ttt.create_user('mauricio');

-- creating some comments
select ttt.store_comment('willy','Duke of cumberland', 'its my comment, idk what i can say, because i never have had');
select ttt.store_comment('romao','King of Prussia', 'its my comment, idk what i can say, because i never have had');
select ttt.store_comment('mauricio','The Catcher in the Rye', 'its my comment, idk what i can say, because i never have had');
select ttt.store_comment('romao','The Tally Ho', 'its my comment, idk what i can say, because i never have had');
select ttt.store_comment('willy','Simmons', 'its my comment, idk what i can say, because i never have had');
select ttt.store_comment('romao','Simmons', 'its my comment, idk what i can say, because i never have had');
select ttt.store_comment('mauricio','Simmons', 'its my comment, idk what i can say, because i never have had');
select ttt.store_comment('mauricio','The White Horse', 'its my comment, idk what i can say, because i never have had');
select ttt.store_comment('willy','Kings Arms', 'its my comment, idk what i can say, because i never have had');
select ttt.store_comment('romao','The Wheatsheaf', 'its my comment, idk what i can say, because i never have had');
select ttt.store_comment('willy','The Flying Bull', 'its my comment, idk what i can say, because i never have had');
select ttt.store_comment('mauricio','Hamilton Arms', 'its my comment, idk what i can say, because i never have had');
