# NFL Draft: How Different Variables Affect Career Length

Scenario: The NFL wants to identify where to concentrate scouting efforts in order to get players who will have long term careers. They want to see how different variables such as college attended, state of college attended, position, and round drafted in affects a player's career length. 

Unless otherwise stated, the analysis does not include active players. We do not want to include players who have not retired as their careers are not over yet, and would influence the career length averages to be shorter. While this analysis covers the draft years from the NFL merger in 1970 to present time, the NFL has changed the amount of rounds in the draft a total of 3 times before settling at 7 rounds in 1994. Therefore, this analysis is limited to 7 rounds of draft picks for consistency.

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

How does the round a player is drafted in affect their career length?

We will use **WHERE** to limit analysis to rounds 1-7, and **GROUP BY** _Round_ and **ORDER BY** _Career_Length_ to organize players from longest career to shortest.

### Query 1:

``` sql
SELECT
	Round,
	ROUND(AVG(Years_Played), 2) AS Career_Length 
	-- average career length
FROM
	NFL_Draft_Cleaned$
WHERE
	Round <= 7
	-- only include players drafted in rounds 1-7
		AND
			Status <> 'Active' 
			-- exclude active players
GROUP BY
	Round 
	-- Group Career_Length by round
ORDER BY
	Career_Length DESC; 
	-- Sort by longest Career_Length to shortest
```
### Results from Query 1:

| Round | Career_Length |
|:-----:|:-------------:|
|   1   |      8.56     |
|   2   |      6.93     |
|   3   |      5.85     |
|   4   |      5.07     |
|   5   |      4.25     |
|   6   |      3.61     |
|   7   |      3.08     |

Based on the Query, the draft round correlated to the longest possible career length is the 1st Round. Career length in the 1st round is over 1.5 years longer than players drafted in the 2nd round, and over 5.4 years longer than players drafted in the last round in the draft (7th).

### Round Selected in Conclusion: 
Being drafted in the 1st round gives you the longest average career length. Teams will want to have as many 1st and 2nd round picks as possible if they are interested in longevity of players, as career length drops off steeply after the 2nd round.

## College State Location

Since we now know that being drafted in the 1st round leads to the longest average career, what are the top 10 states to attend college to increase chances of finding a 1st round level talent? Out of those colleges, which has the longest career length?

We will use **SELECT TOP 10** to select the first 10 results in the query, **WHERE** to only include players who were taken in the first round, **GROUP BY** to group the data first by state and then by round selected, and use **ORDER BY** to sort by first rounders taken, from most to least. Using **ORDER BY** in this way will make sure the first 10 results are the states with the most 1st round draft picks all time.

### Query 2:
 
``` sql
SELECT TOP 10 
-- Select first 10 results
	State,
	COUNT(Round) AS Players_Taken
	-- amount of players taken
FROM
	NFL_Draft_Cleaned$
WHERE
	Round = 1 
	-- only include players who were taken in the 1st round
	AND
			Status <> 'Active' 
			-- exclude active players
GROUP BY
	State,
	Round
	--combine data by state and then round
ORDER BY
	Players_Taken DESC;
	-- sort by amount of players taken, most to least
```

### Results from Query 2:

| Rank |      State     | Career_Length | Players_Taken |
|:----:|:--------------:|:-------------:|:-------------:|
|   1  |   California   |      9.2      |      169      |
|   2  |     Florida    |      9.03     |      147      |
|   3  |      Texas     |      7.6      |      109      |
|   4  |     Alabama    |      8.65     |       66      |
|   5  |      Ohio      |      8.47     |       60      |
|   6  |  Pennsylvania  |      8.59     |       59      |
|   7  |    Michigan    |      8.79     |       56      |
|   8  |    Tennessee   |      8.58     |       53      |
|   9  |    Oklahoma    |      7.36     |       50      |
|  10  | North Carolina |      9.54     |       48      |

Based on this query, the state to scout for the best chance of finding 1st round level talent is California with 169 players taken since 1970, followed closely by Florida with 147 players taken.

Knowing that the 1st round has the highest career lengths and which states are most likely to have players that get drafted 1st round is important. Yet not every player is a 1st round contestant - what are the top 10 states in average career length excluding 1st round draft picks?

We will use **SELECT TOP 10** to select the first 10 results in the query, **WHERE** to exclude 1st rounders,  **GROUP BY** to combine data into states and **ORDER BY** to sort the data from longest to shortest career.

### Query 3:

``` sql
SELECT TOP 10
-- Select the first 10 results
	State,
	ROUND(AVG(Years_Played), 2) AS Career_Length,
	-- average career length
	COUNT(State) AS Players_Taken
	-- amount of players drafted from each state
FROM
	NFL_Draft_Cleaned$
WHERE
	Status <> 'Active'
	-- exclude active players
	AND
		Round <> 1
		-- players not selected in the 1st round
GROUP BY
	State
	-- group the data by state
ORDER BY
	Career_Length DESC; 
	-- Sort by longest Career_Length to shortest, top to bottom
```
### Results from Query 3:

| Rank |     State     | Career_Length | Players_Taken |
|:----:|:-------------:|:-------------:|:-------------:|
|   1  |    Maryland   |      4.5      |      318      |
|   2  |  Pennsylvania |      4.43     |      481      |
|   3  |     Nevada    |      4.42     |       78      |
|   4  | Massachusetts |      4.28     |      162      |
|   5  |    Colorado   |      4.18     |      267      |
|   6  | New Hampshire |      4.17     |       18      |
|   7  | West Virginia |      4.15     |      133      |
|   8  |  Rhode Island |      4.13     |       8       |
|   9  |    Indiana    |      4.12     |      251      |
|  10  |  Connecticut  |      4.12     |       57      |

Based on this query, the top state to be drafted from for the longest career length outside of the 1st round picks is Maryland, with an average career length of 4.5 years.

## College State Location Conculsion:
If you have a 1st round draft pick, teams should focus their scouting efforts to colleges that are in the states of California, Florida and Texas. For later rounds, teams should focus their scouting efforts to Maryland, Pennsylvania and Nevada.

## College Drafted From

Concentrating drafting efforts by state can be a broad approach. Scouts therefore can focus efforts on specific colleges. If being drafted in the 1st round gives you the longest average career, what are the top 10 colleges base on average career for 1st rounders?

We cannot acheive this analysis with our current dataset, so we will have to create a new table to query from. We will use **SELECT TOP 10** to select the first 10 results, use **INTO** to bring the data from our **SELECT** statement into a new table and use **WHERE** to only and include players drafted in the 1st round. We will use **GROUP BY** to group the data by Round and College, and **ORDER BY** to order the colleges by amount of first rounders taken and to make sure our **SELECT TOP 10** select the top 10 colleges by players taken in the 1st round of the draft.

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
	Status <> 'Active'
	-- exclude active players
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

| Rank |   College   | Round | Career_Length | Players_Taken |
|:----:|:-----------:|:-----:|:-------------:|:-------------:|
|   1  |  Miami (FL) |   1   |      9.71     |       58      |
|   2  |     USC     |   1   |      9.66     |       58      |
|   3  |    Texas    |   1   |      8.79     |       34      |
|   4  |   Florida   |   1   |      8.61     |       44      |
|   5  |  Tennessee  |   1   |      8.59     |       37      |
|   6  | Florida St. |   1   |      8.53     |       38      |
|   7  |   Alabama   |   1   |      8.32     |       40      |
|   8  |  Notre Dame |   1   |      8.31     |       32      |
|   9  |   Ohio St.  |   1   |      8.29     |       56      |
|  10  |   Penn St.  |   1   |      8.22     |       32      |

For the best chance at getting taken in the 1st round and having the longest possible career, players should attend Miami (FL) which just edges out USC by 0.05 years.

Of the top 10 colleges by total amount of players drafted, which ones have the longest average career length for non 1st rounders?

We cannot acheive this analysis with our current dataset, so we will have to create a new table to query from. We will use **SELECT TOP 10** to select the first 10 results, use **INTO** to bring the data from our **SELECT** statement into a new table and **WHERE** to exclude 1st rounders. We will use **GROUP BY** to group the data by College, and **ORDER BY** to order the colleges by amount of first rounders taken and to make sure our **SELECT TOP 10** select the top 10 colleges by players taken in the draft.


### Create Table 2:

``` sql
--First we need to create a table of the top 10 colleges
SELECT TOP 10 
-- select first 10 results
	College,
	ROUND(AVG(Years_Played), 2) AS Career_Length,
	-- average Years_Played in new column called "Career_Length"
	COUNT(College) AS Players_Taken
	-- count of each college, put into new column called "Players Taken"
INTO
	Top_10_Colleges_Non_First_Rounders_Taken
	-- Bring the statement into new table
FROM
	NFL_Draft_Cleaned$ 
	-- Take statement from the table "NFL_Draft_Cleaned$"
WHERE
	Status <> 'Active' 
	-- only include 'Retired' players
	AND
		Round <> 1
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

| Rank |   College  | Career_Length | Players_Taken |
|:----:|:----------:|:-------------:|:-------------:|
|   1  |  Penn St.  |      4.77     |      220      |
|   2  |     USC    |      4.52     |      249      |
|   3  | Notre Dame |      4.51     |      221      |
|   4  |  Tennessee |      4.26     |      187      |
|   5  | Miami (FL) |      4.01     |      202      |
|   6  |   Florida  |      3.93     |      191      |
|   7  |  Michigan  |      3.9      |      206      |
|   8  |  Ohio St.  |      3.9      |      220      |
|   9  |  Nebraska  |      3.78     |      240      |
|  10  |  Oklahoma  |      3.2      |      215      |

Of the top 10 colleges by players drafted in 2nd - 7th rounds, Penn St. takes the lead for longest career length, followed closely by USC.

## College Drafted From Conclusion 
With their 1st round pick, NFL teams should focus their scouting efforts to Miami (FL) followed cloesly by USC, which both last just under a year longer than the next closest school, Florida. In all other rounds, NFL teams should focus their scouting effors to Penn St., USC, Notre Dame and Tennessee if they wish to get the longest possible career out of the player they draft.

## Position Played

Refer to cleaning notes [here](CLEANING_NOTES.md#) for a short summary of how positions were organized prior to analysis.

We have information on how round drafted  and college/state attended affects career length, but we have no data on the numerous positions in the NFL. We know that being drafted in the 1st round gives you the longest average career length. How many, and what percentage of each position are taken in the 1st round? How long is their average career? 

We will use **SELECT** to pick position, career_length and players taken, a **NESTED FUNCTION** using **CAST** in order to get the percentage of total players taken by position, **WHERE** to only include players who were taken in the first round and players who are **RETIRED**, **GROUP BY** to group the data by position, and use **ORDER BY** to sory by career length in descending order.

### Query 6:
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
		Status <> 'Active'
GROUP BY
	Position
ORDER BY
	Career_Length DESC
	-- order by career length
```

### Results from Query 6:

| Rank | Position | Career_Length | Players_Taken | Percentage_of_First_Rounders_Selected |
|:----:|:--------:|:-------------:|:-------------:|:-------------------------------------:|
|   1  |     P    |      11.5     |       2       |                  0.12                 |
|   2  |     K    |     11.33     |       3       |                  0.19                 |
|   3  |    QB    |      9.32     |       99      |                  6.16                 |
|   4  |    TE    |      8.96     |       51      |                  3.18                 |
|   5  |    OL    |      8.9      |      220      |                 13.70                 |
|   6  |    DB    |      8.75     |      205      |                 12.76                 |
|   7  |    LB    |      8.69     |      144      |                  8.97                 |
|   8  |    DL    |      8.61     |      279      |                 17.37                 |
|   9  |    WR    |      7.99     |      152      |                  9.46                 |
|  10  |    FB    |      7.75     |       4       |                  0.25                 |
|  11  |    RB    |      7.6      |      167      |                 10.40                 |

Excluding the three positions from the above table with an insignificant amount of players taken (Punter, Kicker and Full Back), the position with the longest career is QB. There is nearly a two year difference between QB and the shortest length career of RB. If we look at the number of players taken for each position, there is not a correlation between career length and players taken. This may be due to the fact that there are different numbers of players needed to start for every position. For example, teams only need one starting QB but 5 starting OL and 3-4 starting DL. Therefore, more QBs and OLs were drafted in the first round, despite their average career length being slightly less than a QBs.

On average, which drafted position has the longest career when not drafted in the 1st round?

We will use **SELECT** to pick position, career_length and players taken, **WHERE** to only include players who were taken in the first round and players who are **RETIRED**, **GROUP BY** to group the data by position, and use **ORDER BY** to sory by career length in descending order.

### Query 7:

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
	Status <> 'Active'
	-- only include players who are retired
	AND
		Round <> 1	
		-- only include players not drafted in the first round
GROUP BY
	Position
ORDER BY
	Career_Length DESC;
	--sort by career length in descending order
```

### Results from Query 7:

| Rank | Position | Career_Length | Players_Taken |
|:----:|:--------:|:-------------:|:-------------:|
|   1  |    FB    |      5.91     |       81      |
|   2  |     P    |      5.16     |      146      |
|   3  |     K    |      4.56     |      168      |
|   4  |    TE    |      4.2      |      776      |
|   5  |    OL    |       4       |      2237     |
|   6  |    LB    |      3.98     |      1829     |
|   7  |    QB    |      3.96     |      595      |
|   8  |    DL    |      3.95     |      1957     |
|   9  |    DB    |      3.94     |      2361     |
|  10  |    WR    |      3.36     |      1644     |
|  11  |    RB    |      3.13     |      1523     |
|  12  |    LS    |      1.5      |       4       |

Of the 12 general positions in the NFL, the longest career length is Full Back (FB), followed closely by Punter (P). As expected, every postitions' average career length decreases when selected after the 1st round (career length by position in Query 7 compared to Query 6). 

## Position Played Conclusion 
With their 1st round pick, NFL teams should focus their scouting on the positions their team needs rather than a specific position based on career length, since all positions have a significantly longer career simply by being picked in the 1st round. Similarly in further rounds, it appears that there is not a correlation between longevity of careers and number of players drafted for a particular position. This would indicate that a more significant correlation exists between position drafted and the amount of each position needed to start the team compared to position drafted and the average career length of that position. 

## Final Analysis:

### Where NFL scouts should focus their scouting based on States:

| Rank | 1st Round Scouting | All Other Rounds Scouting |
|:----:|:------------------:|:-------------------------:|
|   1  |     California     |          Maryland         |
|   2  |       Florida      |        Pennsylvania       |
|   3  |        Texas       |           Nevada          |
|   4  |       Alabama      |       Massachusetts       |
|   5  |        Ohio        |          Colorado         |
|   6  |    Pennsylvania    |       New Hampshire       |
|   7  |      Michigan      |       West Virginia       |
|   8  |      Tennessee     |        Rhode Island       |
|   9  |      Oklahoma      |          Indiana          |
|  10  |   North Carolina   |        Connecticut        |


### Where NFL scouts should focus their scouting based on College:

| Rank | 1st Round Scouting | All Other Rounds Scouting |
|:----:|:------------------:|:-------------------------:|
|   1  |     Miami (FL)     |          Penn St.         |
|   2  |         USC        |            USC            |
|   3  |        Texas       |         Notre Dame        |
|   4  |       Florida      |         Tennessee         |
|   5  |      Tennessee     |         Miami (FL)        |
|   6  |     Florida St.    |          Florida          |
|   7  |       Alabama      |          Michigan         |
|   8  |     Notre Dame     |          Ohio St.         |
|   9  |      Ohio St.      |          Nebraska         |
|  10  |      Penn St.      |          Oklahoma         |

### Should NFL scouts focus their scouting by position?

Ever NFL team's needs will be different based on roster composition so NFL teams should scout based on positional need. Since players in the 1st round have on average a career three years longer than other rounds, teams should focus more on the state and college the player attended than position they play. Players should be drafter by position as needed by the team, and could potentially focus on having more 1st round picks (teams can trade players/picks prior to drafting).

**Future questions to answer and other things to consider:** Should scouting efforts be concentrated on the number of starting players for each position as indicated in Query 6 and 7? How does contract structure and contract length play a role in average career length? Does higher player compensation correlate to longer career? What is the average career length for undrafted free-agent players that get signed?
