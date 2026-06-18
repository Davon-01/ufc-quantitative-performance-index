-- Queries for UFC Portfolio Project

SELECT *
FROM v_FighterValuationModel;
GO

-- Finish rates Given Weight Classes

SELECT 
    weight_class,
    COUNT(*) AS total_fights,
    SUM(CASE WHEN finish NOT IN ('U-DEC', 'S-DEC', 'M-DEC', 'Decision') THEN 1 ELSE 0 END) AS total_finishes,
    ROUND(CAST(SUM(CASE WHEN finish NOT IN ('U-DEC', 'S-DEC', 'M-DEC', 'Decision') THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 1) AS finish_rate_percentage
FROM ufc_intelligence..UFCFights
WHERE weight_class IS NOT NULL
GROUP BY weight_class
ORDER BY finish_rate_percentage DESC;
GO


-- Average significant strikes and Finish Rates landed Given Weight Class

USE ufc_intelligence;
GO

SELECT 
    weight_class,
    COUNT(*) AS total_fights,
    ROUND(AVG(R_avg_SIG_STR_landed + B_avg_SIG_STR_landed), 1) AS avg_total_strikes_landed,
    SUM(CASE WHEN finish NOT IN ('U-DEC', 'S-DEC', 'M-DEC', 'Decision') THEN 1 ELSE 0 END) AS total_finishes,
    ROUND(CAST(SUM(CASE WHEN finish NOT IN ('U-DEC', 'S-DEC', 'M-DEC', 'Decision') THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100, 1) AS finish_rate_percentage
FROM ufc_intelligence..UFCFights
WHERE weight_class IS NOT NULL
GROUP BY weight_class
ORDER BY avg_total_strikes_landed DESC;
GO
