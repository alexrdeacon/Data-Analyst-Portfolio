# Placeholdertitle

## 1. Q1: Based on college location, what are the top 5 states for longest average career length?

``` ruby
SELECT TOP 5 
	State,
	ROUND(AVG(Years_Played), 2) AS Career_Length 
FROM
	NFL_Draft_Cleaned$
WHERE
	Years_Played IS NOT NULL 
GROUP BY
	State
ORDER BY
	Career_Length DESC; 
```
