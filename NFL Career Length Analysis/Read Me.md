# Placeholdertitle

## 1. Q1: Based on college location, what are the top 5 states for longest average career length?

``` sql
SELECT TOP 5 
-- select the first 5 results
	State,
	ROUND(AVG(Years_Played), 2) AS Career_Length 
	-- average years played
FROM
	NFL_Draft_Cleaned$
WHERE
	Years_Played IS NOT NULL 
	-- exclude rows that have empty/NULL values in Years_Played column
GROUP BY
	State
	-- group table by state
ORDER BY
	Career_Length DESC; 
	-- Sort by longest Career_Length to shortest in descending order
```
