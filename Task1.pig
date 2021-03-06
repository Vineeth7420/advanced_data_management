Data =LOAD 'UN_wage_data_with_currency.csv' using PigStorage(',') AS (CountryArea,Year,Sex,Classification,Subclassification,Coverage,Scope,Source,SourceID,Value,Currency,Value_Footnotes);

CountryArea = FOREACH Data GENERATE CountryArea;

distCountry = DISTINCT CountryArea;

loopdistCountry = group distCountry all;


country_count = foreach loopdistCountry  Generate COUNT(distCountry);

Dump country_count;
