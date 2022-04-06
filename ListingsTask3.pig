Data =LOAD 'listings.csv' using PigStorage(',') AS (id,name,host_id,host_name,neighbourhood_group,neighbourhood,latitude:float,longitude:float,room_type,price:float,minimum_nights,number_of_reviews:int,last_review,reviews_per_month,calculated_host_listings_count,availability_365);

room_price_f = filter Data by room_type=='Private room' or room_type=='Entire home/apt';

 ordered_listings = ORDER room_price_f BY number_of_reviews DESC;


top_ten_ordered = LIMIT ordered_listings  10;


top_ten_ordered_proj =foreach top_ten_ordered                   
                                                 
   Generate name,neighbourhood,room_type,price,minimum_nights,number_of_reviews; 

dump top_ten_ordered_proj;
