-- Creating a Fighters Valuation Model

DROP VIEW IF EXISTS v_FighterValuationModel;
GO

CREATE VIEW v_FighterValuationModel AS
WITH RawMetrics AS (
	SELECT
		name,
		COUNT(*) AS total_fights,

	-- Win Rate Score (First KPI that scales their win percentage to a maximum of 50 total points)
	ROUND(
		(CAST(SUM(CASE WHEN Winner = 'Red' AND R_fighter = name THEN 1
				WHEN Winner = 'Blue' AND B_fighter = name THEN 1 ELSE 0 END) AS FLOAT)
				/ Count(*)) * 50, 2
    ) AS win_score,

	-- Striking Score (Second KPI that scales their striking differential to a maximum of 50 points)
	ROUND(
		CASE
		WHEN AVG(CASE WHEN R_fighter = name THEN sig_str_dif ELSE (sig_str_dif * -1) END) > 40 THEN 50
		WHEN AVG(CASE WHEN R_fighter = name THEN sig_str_dif ELSE (sig_str_dif * -1) END) < -40 THEN 0
		ELSE ((AVG(CASE WHEN R_fighter = name THEN sig_str_dif ELSE (sig_str_dif * -1) END) + 40) /80) * 50
	END, 2
    ) AS striking_score,

    -- Market Price Percentage From Betting Odds (0% to 100%)
    -- Used a formula of Market Price % = (Odds / Odds + 100) * 100 for Betting Favorite
    -- Used a formula of Market Price % = (100 / Odds + 100) * 100 for Underdog
    CAST(AVG(CASE 
                WHEN R_fighter = name AND R_odds < 0 THEN (ABS(R_odds) / (ABS(R_odds) + 100.0)) * 100
                WHEN R_fighter = name AND R_odds > 0 THEN (100.0 / (R_odds + 100.0)) * 100
                WHEN B_fighter = name AND B_odds < 0 THEN (ABS(B_odds) / (ABS(B_odds) + 100.0)) * 100
                WHEN B_fighter = name AND B_odds > 0 THEN (100.0 / (B_odds + 100.0)) * 100
                ELSE NULL 
            END) AS DECIMAL(10,1)) AS market_price_percentage

	FROM ufc_intelligence..UFCFighters
	JOIN ufc_intelligence..UFCFights ON name = R_fighter or name = B_fighter
	GROUP BY name
	HAVING COUNT(*) >= 3 -- We filter out fighters with fewer than 3 fights for better data consistency
)
SELECT
	name AS fighter_name,
	total_fights,
	ROUND(win_score + striking_score, 1) AS fighter_performance_score,
	ROUND(market_price_percentage, 1) AS market_price_percentage
FROM RawMetrics;
GO


-- Check the Fighters Valuation Model
SELECT * FROM v_FighterValuationModel
ORDER BY fighter_performance_score DESC;
GO


-- Query to Check Top 15 most Undervalued Fighters
USE ufc_intelligence;
GO

SELECT TOP 15
	fighter_name,
	total_fights,
	fighter_performance_score,
	market_price_percentage,
	ROUND(fighter_performance_score - market_price_percentage, 1) AS undervaluation_gap
FROM v_FighterValuationModel
WHERE total_fights >= 3
-- The higher positive numbers mean more undervalued
ORDER BY undervaluation_gap DESC;
GO


-- Query to Find Top 15 most Overvalued Fighters
SELECT TOP 15
	fighter_name,
	total_fights,
	fighter_performance_score,
	market_price_percentage,
	ROUND(fighter_performance_score - market_price_percentage, 1) AS overvaluation_gap
FROM v_FighterValuationModel
WHERE total_fights >= 3
ORDER BY overvaluation_gap ASC;
GO


-- Query to Check the finishing rate of each Weight Class in the UFC
USE ufc_intelligence;
GO

SELECT 
	weight_class,
	COUNT(*) AS total_fights,

	-- Count the number of times a fight ends in a finish (KO, TKO, or Submission)
	SUM(CASE WHEN finish NOT in ('U-DEC', 'S-DEC', 'M-DEC', 'Decision') THEN 1 ELSE 0 END) AS total_finishes,

	-- Calculating the Finish Rate Percentage
	ROUND(
		CAST(SUM(CASE WHEN finish NOT IN ('U-DEC', 'S-DEC', 'M-DEC', 'Decision') THEN 1 ELSE 0 END) AS FLOAT)
		/ COUNT(*) *100, 1
	) AS finish_rate_percentage
FROM ufc_intelligence..UFCFights
WHERE weight_class IS NOT NULL
GROUP BY weight_class
ORDER BY finish_rate_percentage DESC;
GO


--------------------------------------------------------------------

SELECT *
FROM v_FighterValuationModel;
GO
