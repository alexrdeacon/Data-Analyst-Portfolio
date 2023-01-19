-- load database
use NFLPortfolioProject
--data base loaded



-- test to make sure spreadsheet imported correctly
SELECT TOP 100
	*
FROM
	NFL_Draft_Cleaned$
ORDER BY
	Draft_Year;
-- import successful. beginning analysis



-- 1. Round Selected In
-- How does the round a player is drafted in affect their career length in the 7 round draft era (1994-present)?
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
-- Being drafted in the 1st round gives you the longest average career length



-- 2. College State Location
-- Since we now know that being drafted in the first round leads to the longest average career, what are the top 5 states to attend college to increase chances of finding a 1st round level talent?
SELECT TOP 5 
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
-- Based on this query, the state to scout for the best chance of finding 1st round level talent is California, followed closely by Florida.

-- Regardless of round, what are the top 5 states in average career length that have has at least 20 players drafted from a college in that state
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
	-- Sort by longest Career_Length to shortest, top to bottom
-- the top 5 states to scout regardless of round to find the players with the longest average career length are Massachusetts, Colorado, Pennsylvania, Indiana and New York.



-- 3. College Drafted From
-- If being drafted in the 1st round gives you the longest average career, what are the top 10 colleges base on average career for 1st rounders?

-- Step 1. create a table of top 10 colleges by amount of 1st rounders taken
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
	Players_Taken DESC; 
	-- sort by amount of players drafted, most to least
-- Now that table is created, we can do the analysis and query the new table called "Top_10_Colleges_First_Rounders_Taken"
SELECT
	*
FROM
	Top_10_Colleges_First_Rounders_Taken
ORDER BY
	Career_Length DESC;
-- For the best chance at getting taken in the first round and having the longest possible career, players should attend Miami (FL) 

-- Of the top 10 colleges by total amoun of players drafted, which ones have the longest average career length?
--First we need to create a table of the top 10 colleges
SELECT TOP 10 
-- select first 10 results
	College,
	ROUND(AVG(Years_Played), 2) AS Career_Length,
	-- average Years_Played in new column called "Career_Length"
	COUNT(College) AS Players_Taken
	-- count of each college, put into new column called "Players Taken"

INTO
	Top_10_Colleges_Total_Players_Taken 
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
-- Now that a new table is created, we can sort the top 10 colleges by career length
SELECT
	*
FROM
	Top_10_Colleges_Total_Players_Taken
ORDER BY
	Career_Length DESC;
-- Of the top 10 colleges by players drafted, Miami (FL) again is the best college to attend to get the longest career on average no matter what round you are taken in.



-- 4. Position Played
-- On average, which position has the longest career when not drafted in the 1st round?
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
		-- only include players not drafted in the first round
GROUP BY
	Position
ORDER BY
	Career_Length DESC;
	--sort by career length in descending order
-- The longest career length on average is K and P. The longest offesive career is QB and the shortest is RB. The longest defensive career is DL with the shortest being DB

-- How many and what percentage of each position are taken in the first round?
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

-- percent of population drafted by position
SELECT
	Position,
	COUNT(Position) AS players_taken,
	CAST(ROUND(COUNT(*) * 100.0 / 
		(SELECT 
			COUNT(*) 
		FROM 
			NFL_Draft_Cleaned$), 2) AS NUMERIC(36,2)) AS Percentage_of_Total
FROM
	NFL_Draft_Cleaned$
GROUP BY
	Position;

-- age of players drafted
SELECT
	Age,
	COUNT(Age) AS players_taken,
	CAST(ROUND(COUNT(*) * 100.0 / 
		(SELECT 
			COUNT(*) 
		FROM 
			NFL_Draft_Cleaned$), 2) AS NUMERIC(36,2)) Percentage_of_Total
FROM
	NFL_Draft_Cleaned$
WHERE 
	Age IS NOT NULL
GROUP BY
	Age
ORDER BY
	Age;

