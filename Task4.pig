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
    Generate group.CountryArea,group.Year,group.Currency,flatten(AVG(Data_proj.Value)) as avg;
  };   

 ordered_country = ORDER country_count BY CountryArea ASC,Year DESC;

Store ordered_country into 'Task4';
