# NFL Draft: How Different Variables Affect Career Length

Scenario: The NFL wants to identify where to concentrate scouting efforts in order to get players who will have long term careers. They want to see how different variables such as college, state of college, position, round drafted in etc. affects a players career length. 

## 1. Round Selected In

How does the round a player is drafted in affect their career length in the 7 round draft era (1994-present)?

We will use **WHERE** to clean the data by removing _NULL_ values from the _Years_Played_ column, limit draft year to the 7 round draft era (1994-present), and exclude players who are currently active.

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

Based on the Query, the best round to be drafted in for the longest possible career length is the 1st Round. Career length in the 1st round almost 1.4 years longer than players drafted in the 2nd round, and over 4 years longer than players drafted in the last round in the draft. The 2nd round is the next best round to be drafted in. The average career length is 1 year longer than the 3rd round.

**Conclusion:** Being drafted in the 1st round gives you the longest average career length, and the 2nd round is close behind and well ahead of the other rounds. Teams will want to have as many 1st and 2nd round picks as possible and focus their scouting efforts to players projected to be drafted in those rounds.

## 2. College State Location

Since we now know that being drafted in the first round leads to the longest average career, what are the top 5 states to attend college to increase chances of finding a 1st round level talent?

We will use **SELECT TOP 5** to select the first 5 results in the query, **WHERE** to only include players who were taken in the first round, **GROUP BY** to group the data first by state and then by round selected, and use **ORDER BY** to sort by first rounders taken, from most to least. Using **ORDER BY** in this way will make sure the first 5 results are the states with the most 1st round draft picks all time.
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
	--combine data by state and then round
ORDER BY
	Players_Taken DESC;
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

Based on this query, the state to scout for the best chance of finding 1st round level talent is California, followed closely by Florida.

Regardless of round, what are the top 5 states in average career length that have has at least 20 players drafted from a college in that state?

We will use **SELECT TOP 5** to select the first 5 results in the query, **WHERE** to clean the data by removing _NULL_ values in the _Years_Played_ column, **GROUP BY** to combine data into states, **HAVING** to only include states with at least 20 players drafted and **ORDER BY** to sort the data from longest to shortest average career length.

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

Based on this query, the top 5 states to scout regardless of round to find the players with the longest average career length are Massachusetts, Colorado, Pennsylvania, Indiana and New York.

**Conclusion:** If you have a 1st round draft pick, teams should focus their scouting efforts to colleges that are in the states of California, Florida and Texas. For other rounds, teams should focus their scouting efforts to Massachusetts, Colorado or Pennsylvania.

## 3. College Drafted From

If being drafted in the 1st round gives you the longest average career, what are the top 10 colleges base on average career for 1st rounders?

We cannot acheive this analysis with our current dataset, so we will have to create a new table to query from. We will use **SELECT TOP 10** to select the first 10 results, use **INTO** to bring the data from our **SELECT** statement into a new table, use **WHERE** to clean the data by removing _NULL_ values from the _Years_Played_ column, limit draft year to the 7 round draft era and only and include players drafted in the 1st round. We will use **GROUP BY** to group the data by Round and College, and **ORDER BY** to order the colleges by amount of first rounders taken and to make sure our **SELECT TOP 10** select the top 10 colleges by players taken in the 1st round of the draft.

### Create Table

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
	-- combine data on Round and College
ORDER BY
	Players_Taken DESC
	-- sort by amount of players drafted, most to least
```

Now that table is created, we can do the analysis and query the new table called "Top_10_Colleges_First_Rounders_Taken"

### Query:

``` sql
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

For the best chance at getting taken in the first round and having the longest possible career, players should attend Miami (FL) which on average have a career .7 years longer than Texas.

Of the top 10 colleges by total amoun of players drafted, which ones have the longest average career length?

We cannot acheive this analysis with our current dataset, so we will have to create a new table to query from. We will use **SELECT TOP 10** to select the first 10 results, use **INTO** to bring the data from our **SELECT** statement into a new table. We will use **GROUP BY** to group the data by College, and **ORDER BY** to order the colleges by amount of first rounders taken and to make sure our **SELECT TOP 10** select the top 10 colleges by players taken in the draft.


### Create Table:

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
```

Now that a new table is created, we can sort the top 10 colleges by career length

### Query:

```
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

Of the top 10 colleges by players drafted, Miami (FL) again is the best college to attend to get the longest career on average no matter what round you are taken in.

**Conclusion:** With their 1st round pick, NFL teams should focus their scouting efforts to Miami (FL) followed cloesly by Texas, Ohio St. and Tennessee. Regardless of round, NFL teams should focus their scouting effors to Miami (FL), USC, Penn St., Notre Dame and Florida if they wish to get the longest possible career out of the player they draft.

## Final Analysis:

Based on the data from our analysis here are the recommended places to scout.

### NFL Scouts should focus their first round scouting to:

* States
	* California
	* Florida
	* Texas
	* Alabama
	* Ohio

* Colleges
	* Miami (FL)
	* Texas
	* Ohio St.
	* Tennesee
	* USC
	* Florida
	* Florida St.
	* LSU
	* Alabama
	* Georgia

### Regardless of round, NFL scouts should focus their scouting to:

* States
	* Massachusetts
	* Colorado
	* Pennsylvania
	* Idiana
	* New York

* Colleges
	* Miami (FL)
	* USC
	* Penn St.
	* Notre Dame
	* Florida
	* Michigan
	* Ohio St.
	* Nebraska
	* Alabama
	* Oklahoma

**Future questions to answer and other things to consider:** What is the average career by position? Which state/college has the longest average career for each individual position? Does contract structure play a role in average career length? Do NFL teams give players drafted higher more chances than lower drafted players? What is the average career length for undrafted players?
