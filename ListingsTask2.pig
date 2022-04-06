Data =LOAD 'listings.csv' using PigStorage(',') AS (id,name,host_id,host_name,neighbourhood_group,neighbourhood,latitude:float,longitude:float,room_type,price:float,minimum_nights,number_of_reviews,last_review,reviews_per_month,calculated_host_listings_count,availability_365);

room_price = foreach Data                    
                                                       
    Generate neighbourhood,room_type,(price * minimum_nights) as real_price; 

room_price_f = filter room_price by room_type=='Private room' or room_type=='Entire home/apt';


Group_Data_proj = group room_price_f by (neighbourhood,room_type);



country_count = foreach Group_Data_proj                 
  {                                                       
    Generate group.neighbourhood,group.room_type,flatten(AVG(room_price_f.real_price)) as avg;
  };   

 
 ordered_country = ORDER country_count BY neighbourhood DESC;

dump ordered_country;
