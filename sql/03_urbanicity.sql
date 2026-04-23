--https://nces.ed.gov/programs/edge/geographic/relationshipfiles

CREATE TABLE cbsa2223 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\cbsa2223.csv');

CREATE TABLE county2223 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\county2223.csv');


-- Clean LEA -> CBSA (district mapped to a CBSA if metro)
CREATE TABLE lea_cbsa_23 AS
SELECT
  LEAID,
  NULLIF(TRIM(CBSA), '') AS cbsa_code
FROM cbsa2223;   


-- Clean LEA -> County (STCOUNTY is a county FIPS-style code)
CREATE TABLE lea_county_23 AS
SELECT
  LEAID,
  NULLIF(TRIM(STCOUNTY), '') AS county_fips
FROM county2223; 


-- Join + create Urban / Non-Urban
CREATE TABLE lea_urban_nonurban_23 AS
SELECT
  c.LEAID,
  2023 as year,
  c.county_fips,
  b.cbsa_code,
  CASE
    WHEN b.cbsa_code IS NOT NULL THEN 1 ELSE 0
  END AS is_urban_cbsa,
  CASE
    WHEN b.cbsa_code IS NOT NULL THEN 'Urban'
    ELSE 'Non-Urban'
  END AS urbanicity
FROM lea_county_23 c
LEFT JOIN lea_cbsa_23 b
  USING (LEAID);

CREATE TABLE lea_urban_nonurban_22 AS
SELECT
  c.LEAID,
  2022 as year,
  c.county_fips,
  b.cbsa_code,
  CASE
    WHEN b.cbsa_code IS NOT NULL THEN 1 ELSE 0
  END AS is_urban_cbsa,
  CASE
    WHEN b.cbsa_code IS NOT NULL THEN 'Urban'
    ELSE 'Non-Urban'
  END AS urbanicity
FROM lea_county_23 c
LEFT JOIN lea_cbsa_23 b
  USING (LEAID);


select * from lea_urban_nonurban_23 

CREATE TABLE county_urban_nonurban_23 AS
SELECT
  county_fips,
  MAX(is_urban_cbsa) AS county_is_urban_cbsa,
  CASE WHEN MAX(is_urban_cbsa) = 1 THEN 'Urban' ELSE 'Non-Urban' END AS county_urbanicity
FROM lea_urban_nonurban_23
GROUP BY county_fips;



CREATE TABLE cbsa1819 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\cbsa1819.csv');

CREATE TABLE county1819 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\county1819.csv');



-- Clean LEA -> CBSA (district mapped to a CBSA if metro)
CREATE TABLE lea_cbsa_19 AS
SELECT
  LEAID,
  NULLIF(TRIM(CBSA), '') AS cbsa_code
FROM cbsa1819;  


-- Clean LEA -> County (STCOUNTY is a county FIPS-style code)
CREATE TABLE lea_county_19 AS
SELECT
  LEAID,
  NULLIF(TRIM(STCOUNTY), '') AS county_fips
FROM county1819; 


-- Join + create Urban / Non-Urban
CREATE TABLE lea_urban_nonurban_19 AS
SELECT
  c.LEAID,
  2019 as year,
  c.county_fips,
  b.cbsa_code,
  CASE
    WHEN b.cbsa_code IS NOT NULL THEN 1 ELSE 0
  END AS is_urban_cbsa,
  CASE
    WHEN b.cbsa_code IS NOT NULL THEN 'Urban'
    ELSE 'Non-Urban'
  END AS urbanicity
FROM lea_county_19 c
LEFT JOIN lea_cbsa_19 b
  USING (LEAID);


CREATE TABLE lea_urban_nonurban_all_years AS
SELECT *
FROM lea_urban_nonurban_19

union all

SELECT *
FROM lea_urban_nonurban_22

union all

SELECT *
FROM lea_urban_nonurban_23

