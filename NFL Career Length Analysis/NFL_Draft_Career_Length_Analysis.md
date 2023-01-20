# NFL Draft: How Different Variables Affect Career Length

Scenario: The NFL wants to identify where to concentrate scouting efforts in order to get players who will have long term careers. They want to see how different variables such as college, state of college, position, round drafted in etc. affects a players career length. 

Unless otherwise stated, the analysis includes only players who have retired. We don't want to include players who have not retired as their careers are not over yet, and would influence the career length averages to be shorter based on including rookies and other players who have been in the league a short time but may play long careers.

For a short summary of the pre-cleaning steps taken in Excel, click [here](CLEANING_NOTES.md#).


## Table of Contents:

* [Round Selected In](NFL_Draft_Career_Length_Analysis.md#round-selected-in)
	* [Query 1](NFL_Draft_Career_Length_Analysis.md#query-1)
	* [Results from Query 1](NFL_Draft_Career_Length_Analysis.md#results-from-query-1)
	* [Conclusion](NFL_Draft_Career_Length_Analysis.md#round-selected-in-conclusion)
* [College State Location](NFL_Draft_Career_Length_Analysis.md#college-state-location)
	* [Query 2](NFL_Draft_Career_Length_Analysis.md#query-2)
	* [Results from Query 2](NFL_Draft_Career_Length_Analysis.md#results-from-query-2)
	* [Query 3](NFL_Draft_Career_Length_Analysis.md#query-3)
	* [Results from Query 3](NFL_Draft_Career_Length_Analysis.md#results-from-query-3)
	* [Conclusion](NFL_Draft_Career_Length_Analysis.md#college-state-location-conclusion)
* [College Drafted From](NFL_Draft_Career_Length_Analysis.md#college-drafted-from)
	* [Create Table 1](NFL_Draft_Career_Length_Analysis.md#create-table-1)
	* [Query 4](NFL_Draft_Career_Length_Analysis.md#query-4)
	* [Results from Query 4](NFL_Draft_Career_Length_Analysis.md#results-from-query-4)
	* [Create Table 2](NFL_Draft_Career_Length_Analysis.md#create-table-2)
	* [Query 5](NFL_Draft_Career_Length_Analysis.md#query-5)
	* [Results from Query 5](NFL_Draft_Career_Length_Analysis.md#results-from-query-5)
	* [Conclusion](NFL_Draft_Career_Length_Analysis.md#college-drafted-from-conclusion)
* [Position Played](NFL_Draft_Career_Length_Analysis.md#position-played)
	* [Query 6](NFL_Draft_Career_Length_Analysis.md#query-6)
	* [Results from Query 6](NFL_Draft_Career_Length_Analysis.md#results-from-query-6)
	* [Query 7](NFL_Draft_Career_Length_Analysis.md#query-7)
	* [Results from Query 7](NFL_Draft_Career_Length_Analysis.md#results-from-query-7)
	* [Conclusion](NFL_Draft_Career_Length_Analysis.md#position-played-conclusion)
* [Final Analysis](NFL_Draft_Career_Length_Analysis.md#final-analysis)

## Round Selected In

How does the round a player is drafted in affect their career length in the 7 round draft era (1994-present)?

We will use **WHERE** to clean the data by removing _NULL_ values from the _Years_Played_ column, limit draft year to the 7 round draft era (1994-present), and exclude players who are currently active.

### Query 1:

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
### Results from Query 1:

| Rank | Round | Career_Length |
|------|-------|---------------|
| 1    | 1     | 8.46          |
| 2    | 2     | 7.07          |
| 3    | 3     | 6             |
| 4    | 4     | 5.41          |
| 5    | 5     | 4.92          |
| 6    | 6     | 4.59          |
| 7    | 7     | 4.23          |

Based on the Query, the best round to be drafted in for the longest possible career length is the 1st Round. Career length in the 1st round over 1.2 years longer than players drafted in the 2nd round, and over 4 years longer than players drafted in the last round in the draft. The 2nd round is the next best round to be drafted in.

### Round Selected in Conclusion: 
Being drafted in the 1st round gives you the longest average career length, and the 2nd round is close behind and well ahead of the other rounds. Teams will want to have as many 1st and 2nd round picks as possible and focus their scouting efforts to players projected to be drafted in those rounds.

## College State Location

Since we now know that being drafted in the first round leads to the longest average career, what are the top 5 states to attend college to increase chances of finding a 1st round level talent?

We will use **SELECT TOP 5** to select the first 5 results in the query, **WHERE** to only include players who were taken in the first round, **GROUP BY** to group the data first by state and then by round selected, and use **ORDER BY** to sort by first rounders taken, from most to least. Using **ORDER BY** in this way will make sure the first 5 results are the states with the most 1st round draft picks all time.
### Query 2:
 
``` sql
-- Select first 5 results
	State,
	Round,
	ROUND(AVG(Years_Played), 2) AS Career_Length,
	-- average career length
	COUNT(Round) AS Players_Taken
	-- amount of players taken

FROM
	NFL_Draft_Cleaned$
WHERE
	Round = 1 
	-- only include players who were taken in the 1st round
	AND
			Status = 'Retired' 
			-- only include 'Retired' players
GROUP BY
	State,
	Round
	--combine data by state and then round
ORDER BY
	Players_Taken DESC;
	-- sort by amount of players taken, most to least
```

### Results from Query 2:

| Rank | State      | Round | Career_Length | Players_Taken |
|------|------------|-------|---------------|---------------|
| 1    | California | 1     | 9.26          | 168           |
| 2    | Florida    | 1     | 9.1           | 146           |
| 3    | Texas      | 1     | 7.67          | 108           |
| 4    | Alabama    | 1     | 8.65          | 66            |
| 5    | Ohio       | 1     | 8.47          | 60            |

Based on this query, the state to scout for the best chance of finding 1st round level talent is California, followed closely by Florida.

Regardless of round, what are the top 5 states in average career length that have has at least 20 players drafted from a college in that state?

We will use **SELECT TOP 5** to select the first 5 results in the query, **WHERE** to clean the data by removing _NULL_ values in the _Years_Played_ column, **GROUP BY** to combine data into states, **HAVING** to only include states with at least 20 players drafted and **ORDER BY** to sort the data from longest to shortest average career length.

### Query 3:

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
	AND
			Status = 'Retired' 
			-- only include 'Retired' players
GROUP BY
	State
	-- group the data by state
HAVING
	COUNT(State) > 20
	-- include states with at least 20 players drafted
ORDER BY
	Career_Length DESC; 
```
### Results from Query 3:

| Rank | State         | Career_Length | Players_Taken |
|------|---------------|---------------|---------------|
| 1    | Massachusetts | 6.69          | 122           |
| 2    | Pennsylvania  | 6.34          | 416           |
| 3    | Colorado      | 6.24          | 213           |
| 4    | Indiana       | 6.19          | 189           |
| 5    | Iowa          | 6.19          | 170           |

Based on this query, the top 5 states to scout regardless of round to find the players with the longest average career length are Massachusetts, Colorado, Pennsylvania, Indiana and New York.

## College State Location Conculsion:
If you have a 1st round draft pick, teams should focus their scouting efforts to colleges that are in the states of California, Florida and Texas. For other rounds, teams should focus their scouting efforts to Massachusetts, Colorado or Pennsylvania.

## College Drafted From

If being drafted in the 1st round gives you the longest average career, what are the top 10 colleges base on average career for 1st rounders?

We cannot acheive this analysis with our current dataset, so we will have to create a new table to query from. We will use **SELECT TOP 10** to select the first 10 results, use **INTO** to bring the data from our **SELECT** statement into a new table, use **WHERE** to clean the data by removing _NULL_ values from the _Years_Played_ column, limit draft year to the 7 round draft era and only and include players drafted in the 1st round. We will use **GROUP BY** to group the data by Round and College, and **ORDER BY** to order the colleges by amount of first rounders taken and to make sure our **SELECT TOP 10** select the top 10 colleges by players taken in the 1st round of the draft.

### Create Table 1

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
	Players_Taken DESC;
	-- sort by amount of players drafted, most to least
```

Now that table is created, we can do the analysis and query the new table called "Top_10_Colleges_First_Rounders_Taken"

### Query 4:

``` sql
SELECT
	*
FROM
	Top_10_Colleges_First_Rounders_Taken
ORDER BY
	Career_Length DESC;
```

### Results from Query 4:

| Rank | State       | Round | Career_Length | Players_Taken |
|------|-------------|-------|---------------|---------------|
| 1    | Miami (FL)  | 1     | 9.71          | 58            |
| 2    | USC         | 1     | 9.66          | 58            |
| 3    | Florida     | 1     | 8.81          | 43            |
| 4    | Texas       | 1     | 8.79          | 34            |
| 5    | Tennessee   | 1     | 8.59          | 37            |
| 6    | Florida St. | 1     | 8.53          | 38            |
| 7    | Alabama     | 1     | 8.32          | 40            |
| 8    | Notre Dame  | 1     | 8.31          | 32            |
| 9    | Ohio St.    | 1     | 8.29          | 56            |
| 10   | Penn St.    | 1     | 8.22          | 32            |

For the best chance at getting taken in the first round and having the longest possible career, players should attend Miami (FL) which just edges out USC by 0.05 years.

Of the top 10 colleges by total amount of players drafted, which ones have the longest average career length for non first rounders?

We cannot acheive this analysis with our current dataset, so we will have to create a new table to query from. We will use **SELECT TOP 10** to select the first 10 results, use **INTO** to bring the data from our **SELECT** statement into a new table. We will use **GROUP BY** to group the data by College, and **ORDER BY** to order the colleges by amount of first rounders taken and to make sure our **SELECT TOP 10** select the top 10 colleges by players taken in the draft.


### Create Table 2:

``` sql
--First we need to create a table of the top 10 colleges
SELECT TOP 10 
-- select first 10 results
	College,
	COUNT(College) AS Players_Taken, 
	-- count of each college, put into new column called "Players Taken"
	ROUND(AVG(Years_Played), 2) AS Career_Length
	-- average Years_Played in new column called "Career_Length"
INTO
	Top_10_Colleges_Non_First_Rounders_Taken
	-- Bring the statement into new table
FROM
	NFL_Draft_Cleaned$ 
	-- Take statement from the table "NFL_Draft_Cleaned$"
WHERE
	Status = 'Retired' 
	-- only include 'Retired' players
GROUP BY
	College 
	-- Group results by college
ORDER BY
	Players_Taken DESC; 
	-- Sort by amount of players taken, most to least top to bottom
```

Now that a new table is created, we can sort the top 10 colleges by career length

### Query 5:

```
SELECT
	*
FROM
	Top_10_Colleges_Non_First_Rounders_Taken
ORDER BY
	Career_Length DESC;
```

### Results from Query 5:

| Rank | State       | Career_Length | Players_Taken |
|------|-------------|---------------|---------------|
| 1    | Penn St.    | 6             | 175           |
| 2    | Notre Dame  | 5.83          | 171           |
| 3    | USC         | 5.52          | 204           |
| 4    | Nebraska    | 5.5           | 165           |
| 5    | Florida St. | 5.38          | 147           |
| 6    | Florida     | 5.36          | 140           |
| 7    | Michigan    | 5.35          | 150           |
| 8    | Miami (FL)  | 5.3           | 153           |
| 9    | Ohio St.    | 5.26          | 163           |
| 10   | Oklahoma    | 4.53          | 152           |

Of the top 10 colleges by players drafted not in the first round, Penn St. takes the lead, followed closely by Notre Dame.

## College Drafted From Conclusion 
With their 1st round pick, NFL teams should focus their scouting efforts to Miami (FL) followed cloesly by USC, which both last just under a year longer than the next closest school Florida. In all other rounds, NFL teams should focus their scouting effors to Penn St., Notre Dame, USC, Nebraska and Florida St. if they wish to get the longest possible career out of the player they draft.

## Position Played

Positions have been changed, combined and updated within excel before importing to SQL server management studio. Refer to cleaning notes [here](CLEANING_NOTES.md#) for a short summary of changes.

We have round and college data, but we have no data on the numerous positions in the NFL. On average, which drafted position has the longest career when not drafted in the first round?

We will use **SELECT** to pick position, career_length and players taken, **WHERE** to only include players who were taken in the first round and players who are **RETIRED**, **GROUP BY** to group the data by position, and use **ORDER BY** to sory by career length in descending order.

### Query 6:

``` sql
SELECT
	Position,
	ROUND(AVG(Years_Played), 2) AS Career_Length,
	-- average career length
	COUNT(Position) AS Players_Taken
	-- amount of players taken
FROM
	NFL_Draft_Cleaned$
WHERE
		Status = 'Retired'
		-- only include players who are retired
	AND
		Round <> 1	
GROUP BY
	Position
ORDER BY
	Career_Length DESC;
	--sort by career length in descending order
```

### Results from Query 6:

| Rank | Position | Career_Length | Players_Taken |
|------|----------|---------------|---------------|
| 1    | K        | 7.44          | 103           |
| 2    | P        | 7.32          | 103           |
| 3    | QB       | 6.6           | 357           |
| 4    | FB       | 6.22          | 77            |
| 5    | OL       | 6.2           | 1445          |
| 6    | TE       | 5.75          | 566           |
| 7    | DL       | 5.53          | 1398          |
| 8    | DB       | 5.4           | 1722          |
| 9    | LB       | 5.38          | 1355          |
| 10   | WR       | 4.88          | 1132          |
| 11   | RB       | 4.66          | 1022          |
| 12   | LS       | 3             | 2             |

Of the 12 general positions in the NFL, the longest career length is Kicker, followed closely by Punter. For offense, the longest career is QB and the shortest is RB. For defense, the longest career is DL and the shortest is DB.

We know that being drafted in the first round gives you the longest average career length. How many, and what percentage of each position are taken in the first round? How long is their average career? This will include players who are active.

We will use **SELECT** to pick position, career_length and players taken, a **NESTED FUNCTION** using **CAST** in order to get the percentage of total players taken by position, **WHERE** to only include players who were taken in the first round and players who are **RETIRED**, **GROUP BY** to group the data by position, and use **ORDER BY** to sory by career length in descending order.

### Query 7:
``` sql
SELECT
	Position,
	ROUND(AVG(Years_Played), 2) AS Career_Length,
	--avg career length
	COUNT(Position) AS Players_Taken,
	-- amount of players taken
	CAST(ROUND(COUNT(*) * 100.0 / 
		(SELECT 
			COUNT(*) 
		FROM 
			NFL_Draft_Cleaned$
		WHERE
			Round = 1), 2) AS NUMERIC(36,2)) AS Percentage_of_First_Rounders_Selected
			-- nested function to get percentage of first rounders selected
FROM
	NFL_Draft_Cleaned$
WHERE
		Round = 1
		-- only include first rounders
	AND
		Status = 'Retired'
GROUP BY
	Position
ORDER BY
	Career_Length DESC
	-- order by career length
```

### Results from Query 7:

| Rank | Position | Career_Length | Players_Taken | Percentage_of_First_Rounders_Taken |
|------|----------|---------------|---------------|------------------------------------|
| 1    | P        | 11.5          | 2             | 0.12                               |
| 2    | K        | 11.33         | 3             | 0.19                               |
| 3    | QB       | 9.52          | 97            | 6.04                               |
| 4    | TE       | 9.14          | 50            | 3.11                               |
| 5    | OL       | 8.9           | 220           | 13.70                              |
| 6    | DB       | 8.79          | 204           | 12.70                              |
| 7    | LB       | 8.69          | 144           | 8.97                               |
| 8    | DL       | 8.61          | 279           | 17.37                              |
| 9    | WR       | 8.1           | 150           | 9.34                               |
| 10   | FB       | 7.75          | 4             | 0.25                               |
| 11   | RB       | 7.6           | 167           | 10.40                              |
| 12   | LS       | 3             | 2             |                                    |

Excluding the three positions with an insignificant amount of players taken (Punter, Kicker and Full Back) the position with the longest career is QB, which is over 1.9 years longer than the average first round RB, which comes in last. As expected, every postitions average career length increases when selected in the first round over the overall average career length for the respective position.

## Position Played Conclusion 
With their 1st round pick, NFL teams should focus their first round scouting on any position of need as they will get a significantly longer career than the average player drafted in any other round. However, in the other rounds, NFL teams should focus their scouting on QB, OL and DL for the best ROI. RBs have the shortest career length regardless of round and excluding outliers.

## Final Analysis:

## Where NFL scouts should focus their scouting based on States:

| Rank | 1st Round Scouting | All Other Rounds |
|:----:|:------------------:|:----------------:|
|   1  |     California     |   Massachusetts  |
|   2  |       Florida      |   Pennsylvania   |
|   3  |        Texas       |     Colorado     |
|   4  |       Alabama      |      Indiana     |
|   5  |        Ohio        |       Iowa       |


### Where NFL scouts should focus their scouting based on College:

| Rank | 1st Round Scouting | All Other Rounds |
|:----:|:------------------:|:----------------:|
|   1  |     Miami (FL)     |     Penn St.     |
|   2  |         USC        |    Notre Dame    |
|   3  |       Florida      |        USC       |
|   4  |        Texas       |     Nebraska     |
|   5  |      Tennessee     |    Florida St.   |
|   6  |     Florida St.    |      Florida     |
|   7  |       Alabama      |     Michigan     |
|   8  |     Notre Dame     |    Miami (FL)    |
|   9  |      Ohio St.      |     Ohio St.     |
|  10  |      Penn St.      |     Oklahoma     |


### What positions should NFL teams scout?

Ever NFL team's needs will be different based on roster composition so NFL teams should scout based on positional need. To get the best bang for their buck in terms of career length, teams should scout in the first round and take the player they need most there as they last on average over three years longer than any other round.  

**Future questions to answer and other things to consider:** Does contract structure play a role in average career length? Do NFL teams give players drafted higher more chances than lower drafted players? What is the average career length for undrafted players?
