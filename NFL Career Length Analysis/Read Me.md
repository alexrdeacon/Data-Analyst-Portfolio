# Placeholdertitle

## 1. Based on college location, what are the top 5 states with at least 20 players drafted for longest average career length?

### Code:
``` sql
SELECT TOP 5 
-- Select the first 5 results
	State,
	ROUND(AVG(Years_Played), 2) AS Career_Length,
	-- average career length
	COUNT(State) AS Total_Players
	-- amount of players drafted from each state
FROM
	NFL_Draft_Cleaned$
WHERE
	Years_Played IS NOT NULL 
	-- exclude empty values in the Years_Played column
GROUP BY
	State
	-- group the data by state
HAVING
	COUNT(State) > 20
	-- include states with at least 20 players drafted
ORDER BY
	Career_Length DESC; 
	-- Sort by longest Career_Length to shortest, top to bottom
```
### Results from query:
|Rank|State|Career_Length|Total_Players|
|---|---|---|---|
|1| Massachusetts | 5.56 | 140
|2| Colorado | 5.35 | 223
|3| Pennsylvania | 5.17 | 481
|4| Indiana | 5.16 | 208
|5| New York |	5.14 | 127

Based on the above table, on average, the best state to go to college from for the longest possible career is Massachusetts

## 2. Based on college location, what are the top 5 states for longest average career length?
