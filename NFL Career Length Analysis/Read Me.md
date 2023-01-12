# Placeholdertitle

## 1. Q1: Based on college location, what are the top 5 states for longest average career length?

''' SELECT TOP 5 
-- Select the first 5 results
	State,
	ROUND(AVG(Years_Played), 2) AS Career_Length 
	-- average Years_Played in new column called "Career_Length"
FROM
	NFL_Draft_Cleaned$
WHERE
	Years_Played IS NOT NULL 
	-- exclude empty values in the Years_Played column
GROUP BY
	State
ORDER BY
	Career_Length DESC; 
	-- Sort by longest Career_Length to shortest, top to bottom
'''
