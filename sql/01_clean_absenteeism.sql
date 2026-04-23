--Data from https://eddataexpress.ed.gov/download/data-library

CREATE TABLE t1819 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\Highlevel -EdDataExpress\1819data.csv');

CREATE TABLE t1819denom AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\Highlevel -EdDataExpress\1819data_denom.csv');


--Longer way for 18-19 session

CREATE TABLE ccd_2019_enrollment AS
SELECT
  LEAID,
  SUM(STUDENT_COUNT) AS total_enrollment
FROM t1819denom
WHERE TOTAL_INDICATOR = 'Education Unit Total'
GROUP BY LEAID;

CREATE TABLE ca_2019_clean AS
SELECT
  "NCES LEA ID" as LEAID,
  SUM(Value) AS ca_students
FROM t1819
WHERE Subgroup = 'All Students'  -- or whatever the column is called
GROUP BY 1;

CREATE TABLE ca_2019_lea_rates AS
SELECT
  ca.LEAID,
  ca.ca_students,
  enr.total_enrollment,
  ca.ca_students * 1.0 / NULLIF(enr.total_enrollment, 0) AS ca_rate,
  2019 AS year
FROM ca_2019_clean ca
JOIN ccd_2019_enrollment enr
  USING (LEAID)

CREATE TABLE ca_2019_std AS
SELECT
  r.State,
  r.LEA,
  l.LEAID,
  l.year,
  l.ca_rate,
  l.ca_students,
  l.total_enrollment
FROM ca_2019_lea_rates l
JOIN (
    SELECT DISTINCT "NCES LEA ID" as LEAID, State, LEA
    FROM t1819
) r USING (LEAID);


-- For 2021-22 and 2022-23 sessions
CREATE TABLE t2122 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\Highlevel -EdDataExpress\2122data.csv');


CREATE TABLE t2223 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\Highlevel -EdDataExpress\2223data.csv');

CREATE TABLE ca_2022_std AS
SELECT
  STATE_NAME as State,
  LEA_NAME as LEA,
  LEAID,
  2022 as year,
  NUMERIC_VALUE / 100.0 AS ca_rate,
  NUMERATOR as ca_students,
  DENOMINATOR as total_enrollment
FROM t2122 

CREATE TABLE ca_2023_std AS
SELECT
  STATE_NAME as State,
  LEA_NAME as LEA,
  LEAID,
  2023 as year,
  NUMERIC_VALUE / 100.0 AS ca_rate,
  NUMERATOR as ca_students,
  DENOMINATOR as total_enrollment
FROM t2223


CREATE TABLE ca_all_years AS
SELECT
  LEAID,
  State,
  LEA,
  year,
  ca_rate
FROM ca_2019_std

union all

SELECT
  LEAID,
  State,
  LEA,
  year,
  ca_rate
FROM ca_2022_std

union all

SELECT
  LEAID,
  State,
  LEA,
  year,
  ca_rate
FROM ca_2023_std

COPY ca_all_years
TO 'C:\Users\enaho\Downloads\Absenteeism\Highlevel -EdDataExpress\allyeardata.csv'
WITH (HEADER, DELIMITER ',');

order by 6 desc;


select * from t1819denom
where LEAID = '0100002'
