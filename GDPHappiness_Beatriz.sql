USE whreport;

/* Higher GDP per capita is strongly correlated with higher happiness scores. */

SELECT 
    *
FROM
    whr_2022;

/* Checking both parameters by country to get a better insight and broader understanding of it */
SELECT 
    country,
    gdp_per_capita, happiness_score
FROM
    whr_2022;

/* Checking the 10 countries with the highest gdp per capita and their happiness score */
SELECT 
    country, gdp_per_capita, happiness_score
FROM
    whr_2022
ORDER BY gdp_per_capita DESC
LIMIT 10;

/* Checking the 10 countries with the lowest average gdp per capita and their happiness score */
SELECT 
    country, gdp_per_capita, happiness_score
FROM
    whr_2022
ORDER BY gdp_per_capita ASC
LIMIT 10;

/* Calculating the range of the gdp per capita and happiness score */
SELECT 
    MIN(gdp_per_capita) AS min_gdp_per_capita,
    (SELECT AVG(gdp_per_capita) 
     FROM (
        SELECT gdp_per_capita
        FROM whr_2022
        ORDER BY gdp_per_capita
        LIMIT 2 OFFSET 72
     ) AS subquery) AS median_gdp_per_capita,
	MAX(gdp_per_capita) AS max_gdp_per_capita,
    MIN(happiness_score) AS min_happiness_score,
    (SELECT AVG(happiness_score)
     FROM (
        SELECT happiness_score
        FROM whr_2022
        ORDER BY happiness_score
        LIMIT 2 OFFSET 72
     ) AS subquery) AS median_happiness_score,
     MAX(happiness_score) AS max_happiness_score
FROM
    whr_2022;

/* Calculating the range per region */
SELECT 
    MAX(gdp_per_capita) AS max_gdp_per_capita,
    MIN(gdp_per_capita) AS min_gdp_per_capita,
    MAX(happiness_score) AS max_happiness_score,
    MIN(happiness_score) AS min_happiness_score
FROM
    whr_2022;

/* Let's group our data by ranges so we can get a better understanding of the correlation between them */
WITH ranked_data AS (
    SELECT 
        gdp_per_capita,
        happiness_score,
        PERCENT_RANK() OVER (ORDER BY gdp_per_capita) AS percentile_rank
    FROM whr_2022
)
SELECT 
    CASE 
        WHEN percentile_rank < 0.33 THEN 'Low GDP'
        WHEN percentile_rank BETWEEN 0.33 AND 0.66 THEN 'Medium GDP'
        ELSE 'High GDP'
    END AS gdp_group,
    ROUND(AVG(happiness_score), 3) AS avg_happiness_score
FROM ranked_data
GROUP BY gdp_group;
    

/* Pearson Correlation */
WITH stats AS (
    SELECT 
        COUNT(*) AS n,
        SUM(gdp_per_capita) AS sum_x,
        SUM(happiness_score) AS sum_y,
        SUM(gdp_per_capita * happiness_score) AS sum_xy,
        SUM(POW(gdp_per_capita, 2)) AS sum_x2,
        SUM(POW(happiness_score, 2)) AS sum_y2
    FROM whr_2022
)
SELECT 
    ROUND(
        (n * sum_xy - sum_x * sum_y) / 
        (SQRT((n * sum_x2 - POW(sum_x, 2)) * (n * sum_y2 - POW(sum_y, 2)))),
        4
    ) AS pearson_correlation
FROM stats;

