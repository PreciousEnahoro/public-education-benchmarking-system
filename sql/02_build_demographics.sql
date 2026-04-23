-- ============================================================
-- CCD demographics (race + enrollment + grade span) for 3 years
-- Tables assumed:
--   d2223      = 2022-2023 membership/demo
--   demo1819   = 2018-2019 membership/demo
--   demo2122   = 2021-2022 membership/demo
--
-- Output:
--   ccd_demo_all_years (stacked long table)
-- ============================================================

CREATE TABLE demo2223 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\2223demo.csv');

CREATE TABLE demo2122 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\2122demo.csv');


CREATE TABLE demo1819 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\1819demo.csv');




-- 1) 2022-2023
CREATE TABLE ccd_demo_2223 AS
WITH totals AS (
   SELECT LEAID, SUM(STUDENT_COUNT) AS total_enrollment
   FROM demo2223
   WHERE TOTAL_INDICATOR = 'Education Unit Total'
   GROUP BY LEAID
),
race AS (
   SELECT LEAID,
          RACE_ETHNICITY,
          SUM(STUDENT_COUNT) AS race_count
   FROM demo2223
   WHERE TOTAL_INDICATOR = 'Category Set A - By Race/Ethnicity; Sex; Grade'
   GROUP BY LEAID, RACE_ETHNICITY
),
grades AS (
   SELECT LEAID, MIN(GRADE) AS mingrade, MAX(GRADE) AS maxgrade
   FROM demo2223
   GROUP BY LEAID
)
SELECT
    r.LEAID,
    2023 AS year,
    r.RACE_ETHNICITY,
    r.race_count,
    t.total_enrollment,
    g.mingrade,
    g.maxgrade,
    r.race_count * 1.0 / NULLIF(t.total_enrollment, 0) AS pct_race
FROM race r
JOIN totals t ON t.LEAID = r.LEAID
JOIN grades g ON g.LEAID = r.LEAID;


-- 2) 2021-2022
CREATE TABLE ccd_demo_2122 AS
WITH totals AS (
   SELECT LEAID, SUM(STUDENT_COUNT) AS total_enrollment
   FROM demo2122
   WHERE TOTAL_INDICATOR = 'Education Unit Total'
   GROUP BY LEAID
),
race AS (
   SELECT LEAID,
          RACE_ETHNICITY,
          SUM(STUDENT_COUNT) AS race_count
   FROM demo2122
   WHERE TOTAL_INDICATOR = 'Category Set A - By Race/Ethnicity; Sex; Grade'
   GROUP BY LEAID, RACE_ETHNICITY
),
grades AS (
   SELECT LEAID, MIN(GRADE) AS mingrade, MAX(GRADE) AS maxgrade
   FROM demo2122
   GROUP BY LEAID
)
SELECT
    r.LEAID,
    2022 AS year,
    r.RACE_ETHNICITY,
    r.race_count,
    t.total_enrollment,
    g.mingrade,
    g.maxgrade,
    r.race_count * 1.0 / NULLIF(t.total_enrollment, 0) AS pct_race
FROM race r
JOIN totals t ON t.LEAID = r.LEAID
JOIN grades g ON g.LEAID = r.LEAID;


-- 3) 2018-2019
CREATE TABLE ccd_demo_1819 AS
WITH totals AS (
   SELECT LEAID, SUM(STUDENT_COUNT) AS total_enrollment
   FROM demo1819
   WHERE TOTAL_INDICATOR = 'Education Unit Total'
   GROUP BY LEAID
),
race AS (
   SELECT LEAID,
          RACE_ETHNICITY,
          SUM(STUDENT_COUNT) AS race_count
   FROM demo1819
   WHERE TOTAL_INDICATOR = 'Category Set A - By Race/Ethnicity; Sex; Grade'
   GROUP BY LEAID, RACE_ETHNICITY
),
grades AS (
   SELECT LEAID, MIN(GRADE) AS mingrade, MAX(GRADE) AS maxgrade
   FROM demo1819
   GROUP BY LEAID
)
SELECT
    r.LEAID,
    2019 AS year,
    r.RACE_ETHNICITY,
    r.race_count,
    t.total_enrollment,
    g.mingrade,
    g.maxgrade,
    r.race_count * 1.0 / NULLIF(t.total_enrollment, 0) AS pct_race
FROM race r
JOIN totals t ON t.LEAID = r.LEAID
JOIN grades g ON g.LEAID = r.LEAID;


-- 4) Conjoined (stacked) table with all years
CREATE TABLE ccd_demo_all_years AS
SELECT * FROM ccd_demo_1819
UNION ALL
SELECT * FROM ccd_demo_2122
UNION ALL
SELECT * FROM ccd_demo_2223;

CREATE TABLE demo_wide_all_years AS
SELECT
    LEAID,
    year,
    MAX(CASE WHEN RACE_ETHNICITY = 'Black or African American' THEN pct_race END) AS pct_black,
    MAX(CASE WHEN RACE_ETHNICITY = 'Hispanic/Latino' THEN pct_race END) AS pct_hispanic,
    MAX(CASE WHEN RACE_ETHNICITY = 'White' THEN pct_race END) AS pct_white,
    MAX(CASE WHEN RACE_ETHNICITY = 'Asian' THEN pct_race END) AS pct_asian,
    MAX(CASE WHEN RACE_ETHNICITY = 'American Indian or Alaska Native' or RACE_ETHNICITY = 'Native Hawaiian or Other Pacific Islander' or RACE_ETHNICITY = 'Not Specified' or RACE_ETHNICITY = 'Two or more races' THEN pct_race END) AS pct_other_race,
    MAX(total_enrollment) AS total_enrollment
FROM ccd_demo_all_years
GROUP BY LEAID, year;
