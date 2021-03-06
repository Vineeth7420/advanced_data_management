Data =LOAD 'UN_wage_data_with_currency.csv' using PigStorage(',') AS (CountryArea,Year,Sex,Classification,Subclassification,Coverage,Scope,Source,SourceID,Value,Currency,Value_Footnotes);

CountryAreaCur = FOREACH Data GENERATE CountryArea,Currency;

distCountryCur = DISTINCT CountryAreaCur;


countryGroup = group distCountryCur by CountryArea;


country_count = foreach  countryGroup  Generate group,COUNT(distCountryCur.CountryArea) as count;

filter_country = FILTER country_count by count>1;

Dump filter_country;
