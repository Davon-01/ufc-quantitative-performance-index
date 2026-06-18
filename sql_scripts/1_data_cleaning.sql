Select *
FROM ufc_intelligence..UFCFighters
ORDER BY 1,2

Select *
FROM ufc_intelligence..UFCFights
ORDER BY 1,2

-- Handle Missing Blank Numerical Values in the Fights Table
-- If theres a missing value we change it to 0

BEGIN TRANSACTION;

UPDATE UFCFights
SET reach_dif = COALESCE(reach_dif, 0),
	sig_str_dif = COALESCE(sig_str_dif, 0),
	age_dif = COALESCE(age_dif, 0),
	R_ev = COALESCE(R_ev, 0),
	B_ev = COALESCE(B_ev, 0);

COMMIT TRANSACTION;
GO

-- Check and Confirm Changes:

Select B_ev
FROM ufc_intelligence..UFCFights
WHERE B_ev is null
GO

Select *
FROM ufc_intelligence..UFCFights

-- Removing Hidden Spaces in Text

BEGIN TRANSACTION;

UPDATE UFCFIGHTS
SET R_fighter = TRIM(R_fighter),
	B_fighter = TRIM(B_fighter),
	Winner = TRIM(Winner);
GO

COMMIT TRANSACTION;

-- Clean up the Fighters Roster Table using the same logic

BEGIN TRANSACTION;

UPDATE UFCFighters
SET height_cm = COALESCE(height_cm, 0),
	reach_in_cm = COALESCE(reach_in_cm, 0),
	name = TRIM(name);

COMMIT TRANSACTION;
GO
