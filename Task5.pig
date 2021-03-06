Data =LOAD 'UN_wage_data_with_currency.csv' using PigStorage(',') AS (CountryArea,Year,Sex,Classification,Subclassification,Coverage,Scope,Source,SourceID,Value:double,Currency,Value_Footnotes);

filtered_scope_week= FILTER Data by Scope=='Earnings per week';



Data_proj_week = FOREACH filtered_scope_week GENERATE CountryArea, Year,Currency,Value*4;

filtered_scope_e = FILTER Data by Scope=='Earnings per month';
filtered_scope_w= FILTER Data by Scope=='Wage rates per month';

filtered_scope = UNION filtered_scope_e,filtered_scope_w;

Data_proj_m = FOREACH filtered_scope GENERATE CountryArea, Year,Currency,Value;

Data_proj =UNION Data_proj_m,Data_proj_week;



Group_Data_proj = group Data_proj by (CountryArea,Year,Currency);

country_count = foreach Group_Data_proj                    
  {                                                       
    Generate group.CountryArea,group.Year,group.Currency,AVG(Data_proj.Value) as avg;
  };   

 ordered_country = ORDER country_count BY CountryArea ASC,Year DESC;



Group_Data_Country = group ordered_country by (CountryArea,Currency);

country_year = foreach Group_Data_Country                    
  {                                                       
    Generate group.CountryArea,group.Currency,MAX(ordered_country.Year) as max_year,MIN(ordered_country.Year) AS min_year;
  };   

max_year_per_country = JOIN country_year BY (CountryArea,max_year,Currency),country_count by (CountryArea,Year,Currency);

max_year_proj = FOREACH  max_year_per_country GENERATE 
country_year::CountryArea AS CountryArea,country_year::Currency AS Currency, country_year::max_year AS max_year,country_count::avg as max_avg, country_year::min_year AS min_year;

 max_n_min_year_per_country = JOIN max_year_proj BY (CountryArea,min_year,Currency),country_count by (CountryArea,Year,Currency);

result = FOREACH   max_n_min_year_per_country GENERATE 
max_year_proj::CountryArea AS CountryArea,max_year_proj::Currency as Currency, (((max_year_proj::max_avg-country_count::avg)/country_count::avg)/(max_year_proj::max_year-max_year_proj::min_year)) as percentage;

 ordered_result = ORDER result BY percentage  DESC;

 Top10_ordered_result  = LIMIT ordered_result 10;

dump  Top10_ordered_result;
 



