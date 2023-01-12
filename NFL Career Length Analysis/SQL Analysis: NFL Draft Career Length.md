# Placeholdertitle

## 1. Based on college location, what are the top 5 states with at least 20 players drafted for longest average career length?

### Query:

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

## 2. How does the round a player is drafted in affect their career length in the 7 round draft era?

### Query:

``` sql
SELECT
	Round,
	ROUND(AVG(Years_Played), 2) AS Career_Length 
	-- average career length
FROM
	NFL_Draft_Cleaned$
WHERE
	Years_Played IS NOT NULL 
	-- exclude empty values in the Years_Played column
		AND
			Draft_Year >= 1994 
			-- only include players drafted in 7 round era (1994-Present)
		AND
			Status = 'Retired' 
			-- only include 'Retired' players
GROUP BY
	Round 
	-- Group Career_Length by round
ORDER BY
	Career_Length DESC; 
	-- Sort by longest Career_Length to shortest, top to bottom
```
### Results from Query:

| Rank | Round | Career_Length |
|------|-------|---------------|
| 1    | 1     | 7.47          |
| 2    | 2     | 6.09          |
| 3    | 3     | 5.04          |
| 4    | 4     | 4.5           |
| 5    | 5     | 4.05          |
| 6    | 6     | 3.75          |
| 7    | 7     | 3.39          |

Based on this table, on average, the best round to be drafted in for the longest possible career length is the 1st Round

## 3. Based on college location, what are the top 5 states for most 1st round players taken?

### Query:
 
``` sql
SELECT TOP 5 
-- Select first 5 results
	State,
	Round,
	COUNT(Round) AS Players_Taken, 
	-- amount of players taken
	ROUND(AVG(Years_Played), 2) AS Career_Length 
	-- average career length
FROM
	NFL_Draft_Cleaned$
WHERE
	Round = 1 
	-- only include players who were taken in the 1st round
GROUP BY
	State,
	Round
ORDER BY
	Players_Taken DESC
	-- sort by amount of players taken, most to least
```

### Results from Query:

| Rank | State      | Round | Players_Taken | Career_Length |
|------|------------|-------|---------------|---------------|
| 1    | California | 1     | 197           | 8             |
| 2    | Florida    | 1     | 171           | 7.62          |
| 3    | Texas      | 1     | 126           | 6.54          |
| 4    | Alabama    | 1     | 95            | 6.49          |
| 5    | Ohio       | 1     | 77            | 6.75          |

To have the best chance to be taken in the first round, you should attend college in California

## 4. Of the top 10 colleges by players drafted, which ones have the longest average career length?

### Query:

``` sql
--First we need to create a table of the top 10 colleges
SELECT TOP 10 
-- select first 10 results
	College,
	COUNT(College) AS Players_Taken, 
	-- count of each college, put into new column called "Players Taken"
	ROUND(AVG(Years_Played), 2) AS Career_Length, 
	-- average Years_Played in new column called "Career_Length"
INTO
	Top_10_Colleges_Total_Players_Taken 
	-- Bring the statement into new table
FROM
	NFL_Draft_Cleaned$ 
	-- Take statement from the table "NFL_Draft_Cleaned$"
GROUP BY
	College 
	-- Group results by college
ORDER BY
	Players_Taken DESC; 
	-- Sort by amount of players taken, most to least top to bottom
--Now that a new table is created, we can sort the top 10 colleges by career length
SELECT
	*
FROM
	Top_10_Colleges_Total_Players_Taken
ORDER BY
	Career_Length DESC
```

### Results from Query:

| Rank | Coolege    | Players_Taken | Career_Length |
|------|------------|---------------|---------------|
| 1    | Miami (FL) | 284           | 5.49          |
| 2    | USC        | 330           | 5.38          |
| 3    | Penn St.   | 286           | 5.11          |
| 4    | Notre Dame | 282           | 5.07          |
| 5    | Florida    | 269           | 5             |
| 6    | Michigan   | 272           | 4.89          |
| 7    | Ohio St.   | 326           | 4.82          |
| 8    | Nebraska   | 281           | 4.81          |
| 9    | Alabama    | 264           | 4.64          |
| 10   | Oklahoma   | 277           | 4.05          |

Of the top 10 colleges by players drafted, Miami (FL) is the best college to attend to get the longest career on average
 
## 5. If being in the first round gives you the longest average career, what is the average career by college and round?

### Query:

``` sql
--Create a table of top 10 colleges by amount of 1st rounders taken
SELECT TOP 10 
-- select first 10 results
	College,
	Round,
	ROUND(AVG(Years_Played), 2) AS Career_Length, 
	-- average career length
	COUNT(College) AS Players_Taken 
	-- players taken by college
INTO
	Top_10_Colleges_First_Rounders_Taken 
	-- bring into new table
FROM
	NFL_Draft_Cleaned$ 
	-- from this table
WHERE
	Years_Played IS NOT NULL 
	-- exclude empty values in the Years_Played column
		AND
			Draft_Year >= 1994 
			-- Only include players drafted in 7 round era (1994-Present)
		AND
			Status = 'Retired' 
			-- only include players who are retired
		AND
			Round = 1 
			-- only include players taken in the 1st round
GROUP BY
	Round,
	College
ORDER BY
	Players_Taken DESC
--Now that table is created, we can do the analysis
SELECT
	*
FROM
	Top_10_Colleges_First_Rounders_Taken
ORDER BY
	Career_Length DESC
```

### Results from Query:

| Rank | Coolege     | Round | Career_Length | Players_Taken |
|------|-------------|-------|---------------|---------------|
| 1    | Miami (FL)  | 1     | 8.74          | 34            |
| 2    | Texas       | 1     | 8             | 19            |
| 3    | Ohio St.    | 1     | 7.52          | 33            |
| 4    | Tennessee   | 1     | 7.5           | 18            |
| 5    | USC         | 1     | 7.17          | 24            |
| 6    | Florida     | 1     | 7.08          | 25            |
| 7    | Florida St. | 1     | 7.07          | 28            |
| 8    | LSU         | 1     | 6.82          | 17            |
| 9    | Alabama     | 1     | 6.3           | 20            |
| 10   | Georgia     | 1     | 6.28          | 18            |

For the best chance at getting taken in the first and having the longest possible career, players should go to Miami (FL)
