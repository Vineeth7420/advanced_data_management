Data =LOAD 'UN_wage_data_with_currency.csv' using PigStorage(',') AS (CountryArea,Year,Sex,Classification,Subclassification,Coverage,Scope,Source,SourceID,Value:double,Currency,Value_Footnotes);

filtered_scope_e = FILTER Data by Scope=='Earnings per month';
filtered_scope_w= FILTER Data by Scope=='Wage rates per month';

filtered_scope = UNION filtered_scope_e,filtered_scope_w;

filtered_sex = FILTER filtered_scope by Sex =='Women' OR Sex =='Men';


Data_proj = FOREACH filtered_sex GENERATE CountryArea, Year, Sex, SourceID,Value;

Group_Data_proj = group Data_proj by (CountryArea,Year,SourceID);

country_count = foreach Group_Data_proj                    
  {                                                       
  male= filter Data_proj by Sex =='Men';                  
  female = filter Data_proj by Sex=='Women';              
  Generate group,flatten(female.Value) as female,flatten(male.Value) as male;
  };   

country_div = foreach country_count                   
  {                                                       
         Generate group,(float)(female)/(male) as SexWageRatio;
  };   

 ordered_country = ORDER country_div BY SexWageRatio DESC;

 Top10_ordered_country = LIMIT ordered_country 10;


dump Top10_ordered_country;
