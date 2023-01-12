-- Checking table to make sure import worked correctly
SELECT 
	*
FROM
	NFL_Draft_Cleaned$
ORDER BY
	Draft_Year;
-- Import Successful





-- Q1: Based on college location, what are the top 5 states for longest average career length?
SELECT TOP 5 -- Select the first 5 results
	State,
	ROUND(AVG(Years_Played), 2) AS Career_Length -- average Years_Played in new column called "Career_Length"
FROM
	NFL_Draft_Cleaned$
WHERE
	Years_Played IS NOT NULL -- exclude empty values in the Years_Played column
GROUP BY
	State
ORDER BY
	Career_Length DESC; -- Sort by longest Career_Length to shortest, top to bottom
-- Based on this analysis, on average, the best state to go to college in for the longest possible career length is Massachusetts





--Q2: How does the round a player is drafted in affect their career length in the 7 round draft era?
SELECT
	Round,
	ROUND(AVG(Years_Played), 2) AS Career_Length -- average Years_Played in new column called "Career_Length"
FROM
	NFL_Draft_Cleaned$
WHERE
	Years_Played IS NOT NULL -- exclude empty values in the Years_Played column
		AND
			Draft_Year >= 1994 -- Only include players drafted in 7 round era (1994-Present)
		AND
			Status = 'Retired' -- Only include 'Retired' players
GROUP BY
	Round -- Group Career_Length by round
ORDER BY
	Career_Length DESC; -- Sort by longest Career_Length to shortest, top to bottom
-- Based on this table, on average, the best round to be drafted in for the longest possible career length is the 1st Round





--Q3: Based on college location, what are the top 5 states for most 1st round players taken?
SELECT TOP 5 -- Select first 5 results
	State,
	Round,
	COUNT(Round) AS Players_Taken, -- amount of players taken
	ROUND(AVG(Years_Played), 2) AS Career_Length -- average career length
FROM
	NFL_Draft_Cleaned$
WHERE
	Round = 1 -- only include players who were taken in the 1st round
GROUP BY
	State,
	Round
ORDER BY
	Players_Taken DESC
-- To have the best chance to be taken in the first round, you should attend college in California





--Q4: Of the top 20 colleges by players drafted, which ones have the longest average career length?
--First we need to create a table of the top 20 colleges
SELECT TOP 10 -- select first 10 results
	College,
	COUNT(College) AS Players_Taken, -- count of each college, put into new column called "Players Taken"
	ROUND(AVG(Years_Played), 2) AS Career_Length, -- average Years_Played in new column called "Career_Length"
	Round
INTO
	Top_10_Colleges_Total_Players_Taken -- Bring the statement into new table "Top_20_Colleges"
FROM
	NFL_Draft_Cleaned$ -- Take from the table "NFL_Draft_Cleaned$"
GROUP BY
	College -- Group results by college
ORDER BY
	Players_Taken DESC; -- Sort by amount of players taken, most to least top to bottom
--Now that a new table is created, we can sort the top 20 colleges by career length
SELECT
	*
FROM
	Top_10_Colleges_Total_Players_Taken
ORDER BY
	Career_Length DESC
-- Of the top 20 colleges by players drafted, Miami (FL) is the best college to attend to get the longest career on average




--Q5: If being in the first round gives you the longest average career, what is the average career by college and round??
--Create a table of top 10 colleges by amount of 1st rounders taken
SELECT TOP 10 -- select first 10 results
	College,
	Round,
	ROUND(AVG(Years_Played), 2) AS Career_Length, -- average career length
	COUNT(College) AS Players_Taken -- players taken by college
INTO
	Top_10_Colleges_First_Rounders_Taken -- bring into new table
FROM
	NFL_Draft_Cleaned$ -- from this table
WHERE
	Years_Played IS NOT NULL -- exclude empty values in the Years_Played column
		AND
			Draft_Year >= 1994 -- Only include players drafted in 7 round era (1994-Present)
		AND
			Status = 'Retired' -- only include players who are retired
		AND
			Round = 1 -- only include players taken in the 1st round
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
--For the best chance at getting taken in the first and having the longest possible career, players should go to Miami (FL)
