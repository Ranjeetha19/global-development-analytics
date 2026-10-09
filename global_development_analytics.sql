/* ================================================================
   PROJECT : GLOBAL DEVELOPMENT ANALYTICS & PREDICTIVE MODELING
   =================================================================

   Objective:
   Analyze the relationship between socio-economic indicators and
   GDP per capita, and later use statistical and machine-learning
   models to predict GDP per capita.

   Analysis Period:
   2010–2024

   Target Variable:
   GDP per capita (constant 2015 US$)

   Predictor Variables:
   1. Population growth
   2. Life expectancy
   3. Internet usage
   4. Unemployment
   5. Exports (% of GDP)

   SQL is being used for:
   - Data validation
   - Data quality checks
   - Aggregation
   - Country comparisons
   - Trend analysis
   - Ranking
   - Preparing data for later statistical and ML analysis

   Important definition:
   GDP per capita is GDP divided by population. It represents
   economic output per person and should NOT be interpreted as
   an individual's salary or personal income.
   
   The selected GDP indicator is measured in constant 2015 US$,
   which allows better comparison across years by accounting
   for changes in prices.
================================================================ */

/* ================================================================
   DATABASE SETUP
   =================================================================

   Purpose:
   Creating a dedicated database for Project,so that all project
   data and SQL analysis are organized in one place.
================================================================ */

CREATE DATABASE IF NOT EXISTS global_development;

USE global_development;

/* ================================================================
    CREATING ANALYTICAL TABLE
   =================================================================

   Purpose:
   Create the table that will store our clean six-indicator dataset.

   Each row represents:
   One country/economy + one year.

   Therefore, the basic analytical structure is:

   Country + Year + Target + Predictors
================================================================ */

CREATE TABLE IF NOT EXISTS development_data (
    Country_Name VARCHAR(100),
    Country_Code VARCHAR(10),
    Year INT,
    GDP_per_capita DOUBLE,
    Population_growth DOUBLE,
    Life_expectancy DOUBLE,
    Internet_usage DOUBLE,
    Unemployment DOUBLE,
    Exports_pct_GDP DOUBLE
);

/* ================================================================
                          DATA IMPORT
   ================================================================
   I am importing the cleaned dataset covering 2010–2024
   into the development_data table.
   
   
   

/* ================================================================
                    BASIC DATA VALIDATION
   ================================================================*/
   
-- I am checking the total number of records.
SELECT COUNT(*) AS total_records
FROM development_data;


-- I am checking whether the intended analysis period is covered. */
SELECT
    MIN(Year) AS first_year,
    MAX(Year) AS last_year
FROM development_data;

 
-- I am checking how many unique economies are included. 
SELECT
    COUNT(DISTINCT Country_Code) AS total_entities
FROM development_data;


-- I am checking yearly record counts for data coverage. 
SELECT
    Year,
    COUNT(*) AS records
FROM development_data
GROUP BY Year
ORDER BY Year;


/* =================================================
                DATA QUALITY CHECKS 
====================================================*/

-- I am checking missing values across the six indicators. 
SELECT
    COUNT(*) AS total_rows,
    SUM(GDP_per_capita IS NULL) AS missing_gdp,
    SUM(Population_growth IS NULL) AS missing_population,
    SUM(Life_expectancy IS NULL) AS missing_life_expectancy,
    SUM(Internet_usage IS NULL) AS missing_internet,
    SUM(Unemployment IS NULL) AS missing_unemployment,
    SUM(Exports_pct_GDP IS NULL) AS missing_exports
FROM development_data;


-- I am checking for duplicate country-year records. 
SELECT
    Country_Code,
    Year,
    COUNT(*) AS duplicate_count
FROM development_data
GROUP BY Country_Code, Year
HAVING COUNT(*) > 1;


-- I am checking indicator ranges for unusual values. 
SELECT
    MIN(GDP_per_capita) AS min_gdp,
    MAX(GDP_per_capita) AS max_gdp,
    MIN(Population_growth) AS min_population_growth,
    MAX(Population_growth) AS max_population_growth,
    MIN(Life_expectancy) AS min_life_expectancy,
    MAX(Life_expectancy) AS max_life_expectancy,
    MIN(Internet_usage) AS min_internet,
    MAX(Internet_usage) AS max_internet,
    MIN(Unemployment) AS min_unemployment,
    MAX(Unemployment) AS max_unemployment,
    MIN(Exports_pct_GDP) AS min_exports,
    MAX(Exports_pct_GDP) AS max_exports
FROM development_data;


/* ===================================================
                UNDERSTANDING ENTITIES
 =====================================================*/

-- I am checking all entities before performing country-level analysis. 
SELECT DISTINCT
    Country_Name,
    Country_Code
FROM development_data
ORDER BY Country_Name;


-- I am checking the number of unique entity names. 
SELECT
    COUNT(DISTINCT Country_Name) AS unique_entity_names
FROM development_data;


/* ======================================================
              2024 GDP PER CAPITA RANKING 
=========================================================*/

-- I am identifying the highest GDP-per-capita observations in 2024. 
SELECT
    Country_Name,
    Country_Code,
    ROUND(GDP_per_capita, 2) AS GDP_per_capita
FROM development_data
WHERE Year = 2024
ORDER BY GDP_per_capita DESC
LIMIT 10;


-- I am identifying the lowest GDP-per-capita observations in 2024. 
SELECT
    Country_Name,
    Country_Code,
    ROUND(GDP_per_capita, 2) AS GDP_per_capita
FROM development_data
WHERE Year = 2024
ORDER BY GDP_per_capita ASC
LIMIT 10;


 /*================================================================
           REFINE COUNTRY-LEVEL RANKING
   ================================================================

   I found that the initial ranking contains aggregate entities
   such as North America and Low income.

   These are not individual countries, so I am refining the ranking
   to make the country-level comparison more meaningful.

   This is an interim filter using the aggregate codes identified so far.
   I will apply a more complete country/economy filter before final
   statistical and machine-learning analysis.
================================================================ */


-- I am refining the ranking to focus on individual economies. 
SELECT
    Country_Name,
    Country_Code,
    ROUND(GDP_per_capita, 2) AS GDP_per_capita
FROM development_data
WHERE Year = 2024
  AND Country_Code NOT IN ('NAC', 'LIC')
ORDER BY GDP_per_capita DESC
LIMIT 10;


-- I am identifying the lowest individual economies in 2024. 
SELECT
    Country_Name,
    Country_Code,
    ROUND(GDP_per_capita, 2) AS GDP_per_capita
FROM development_data
WHERE Year = 2024
  AND Country_Code NOT IN ('NAC', 'LIC')
ORDER BY GDP_per_capita ASC
LIMIT 10;


/* ===================================================
         GDP PER CAPITA CHANGE: 2010 VS 2024
 =====================================================*/

/* I am comparing GDP per capita at the beginning and end of the period.
   This shows how much it changed over 2010–2024. */


WITH gdp_2010 AS (
    SELECT
        Country_Code,
        Country_Name,
        GDP_per_capita AS gdp_2010
    FROM development_data
    WHERE Year = 2010
),

gdp_2024 AS (
    SELECT
        Country_Code,
        Country_Name,
        GDP_per_capita AS gdp_2024
    FROM development_data
    WHERE Year = 2024
)

SELECT
    a.Country_Name,
    a.Country_Code,
    ROUND(a.gdp_2010, 2) AS GDP_2010,
    ROUND(b.gdp_2024, 2) AS GDP_2024
FROM gdp_2010 a
JOIN gdp_2024 b
    ON a.Country_Code = b.Country_Code;
    
 /* ==================================================================================================
  SQL analysis complete: data validated, compared, and prepared for statistical and predictive modeling.
=======================================================================================================*/