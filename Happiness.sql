USE Happiness;
SELECT * FROM HDI_data LIMIT 10;
SELECT * FROM WHR_2022 LIMIT 10;


SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE '/Users/cha/Documents/Ironhack2/UNIT 3/Project/WHR_2022.csv'
INTO TABLE WHR_2022
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM WHR_2022 LIMIT 10;
SELECT 
    H.Country, 
    H.HDI_Value, 
    W.happiness_score
FROM 
    HDI_data H
JOIN 
    WHR_2022 W
ON 
    H.Country = W.country;
SELECT 
    CASE 
        WHEN H.HDI_Value >= 0.8 THEN 'High HDI'
        WHEN H.HDI_Value >= 0.6 THEN 'Medium HDI'
        ELSE 'Low HDI'
    END AS HDI_Level,
    AVG(W.happiness_score) AS Avg_Happiness_Score
FROM 
    HDI_data H
JOIN 
    WHR_2022 W
ON 
    H.Country = W.country
GROUP BY 
    HDI_Level
ORDER BY 
    HDI_Level DESC;
SELECT 
    H.Country, 
    H.HDI_Value, 
    W.happiness_score, 
    ABS(H.HDI_Value - W.happiness_score) AS Difference
FROM 
    HDI_data H
JOIN 
    WHR_2022 W
ON 
    H.Country = W.country
ORDER BY 
    Difference DESC
LIMIT 10;
