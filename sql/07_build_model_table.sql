--Fixing the poverty table
drop table poverty_lea_all_years

CREATE OR REPLACE TABLE poverty_lea_all_years AS
SELECT
  l.LEAID,
  l.year,

  AVG(
    CAST(
      NULLIF(REPLACE(s.poverty_rate_5_17, ',', ''), '.') 
      AS DOUBLE
    )
  ) AS poverty_rate_5_17,

  AVG(
    CAST(
      NULLIF(REPLACE(s.median_household_income, ',', ''), '.') 
      AS DOUBLE
    )
  ) AS median_household_income

FROM lea_urban_nonurban_all_years l
LEFT JOIN saipe_clean s
  ON l.county_fips = s.county_fips
 AND l.year = s.year

GROUP BY 1,2;


--Updating the demo t 



 drop TABLE lea_year_master
 
create TABLE lea_year_master AS
SELECT
    d.LEAID,
    d.year,
    a.state,

    d.total_enrollment,
    d.pct_black,
    d.pct_hispanic,
    d.pct_white,
    d.pct_asian,
    d.pct_other_race,

    p.poverty_rate_5_17,
    p.median_household_income,

    s.student_teacher_ratio_clean,

    (CASE
      WHEN  a.ca_rate > 1 AND a.ca_rate <= 100 THEN a.ca_rate / 100.0
      WHEN a.ca_rate > 100 THEN NULL
      ELSE a.ca_rate
    END
  ) AS ca_rate

    ,case when u.urbanicity is null then 'Non-Urban' else 'Urban' end as urbanicity,

    g.grad_rate_2019

FROM demo_wide_all_years d
LEFT JOIN poverty_lea_all_years p
  ON d.LEAID = p.LEAID AND d.year = p.year
LEFT JOIN staff_capacity_final s
  ON d.LEAID = s.LEAID AND d.year = s.year
LEFT JOIN ca_all_years a
  ON d.LEAID = a.LEAID AND d.year = a.year
LEFT JOIN (select distinct LEAID, urbanicity from lea_urban_nonurban_all_years) u
  ON d.LEAID = u.LEAID 
LEFT JOIN graduation1819 g
  ON d.LEAID = g.LEAID;


SELECT distinct LEAID, count(*)
FROM (
select distinct a.LEAID
, a.LEA as lea_name
--,a.year
, case when u.urbanicity is null then 'Non-Urban' else 'Urban' end as urbanicity
from ca_all_years a
LEFT JOIN (select distinct LEAID, urbanicity from lea_urban_nonurban_all_years) u
  ON a.LEAID = u.LEAID 
where a.year = 2023
order by 1
)
--where LEAID = 0400057
group by 1
order by 2 desc


--0400057, 0400415

select distinct urbanicity from lea_year_master
SELECT
  MIN(n_rows) AS min_rows,
  MAX(n_rows) AS max_rows,
  AVG(n_rows) AS avg_rows
FROM (
  SELECT LEAID, year, COUNT(*) AS n_rows
  FROM lea_year_master
  GROUP BY 1,2
);


SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN poverty_rate_5_17 IS NULL THEN 1 ELSE 0 END) AS miss_poverty,
  SUM(CASE WHEN student_teacher_ratio_clean IS NULL THEN 1 ELSE 0 END) AS miss_ratio,
  SUM(CASE WHEN pct_black IS NULL THEN 1 ELSE 0 END) AS miss_black,
  SUM(CASE WHEN pct_hispanic IS NULL THEN 1 ELSE 0 END) AS miss_hispanic,
  SUM(CASE WHEN urbanicity IS NULL THEN 1 ELSE 0 END) AS miss_urban,
  SUM(CASE WHEN grad_rate_2019 IS NULL THEN 1 ELSE 0 END) AS miss_grad
FROM lea_year_master
WHERE year IN (2019, 2023);




SELECT
    d.LEAID,
    d.year,
    case when u.urbanicity is null then 'Non-Urban' else 'Urban' end as urbanicity,
FROM demo_wide_all_years d
LEFT JOIN (select distinct LEAID, urbanicity from lea_urban_nonurban_all_years) u
  ON d.LEAID = u.LEAID 

SELECT
  year,
  COUNT(*) AS districts,
  AVG(ca_rate),
  AVG(poverty_rate_5_17),
  AVG(student_teacher_ratio_clean)
FROM lea_year_master
GROUP BY year
ORDER BY year;

SELECT
  year,
  CORR(ca_rate, poverty_rate_5_17) AS corr
FROM lea_year_master
WHERE poverty_rate_5_17 IS NOT NULL
GROUP BY year
ORDER BY year;

SELECT
  year,
  CORR(ca_rate, student_teacher_ratio_clean) AS staffing_corr
FROM lea_year_master
WHERE student_teacher_ratio_clean IS NOT NULL
GROUP BY year
ORDER BY year;

SELECT CORR(ca_rate, grad_rate_2019)
FROM lea_year_master
WHERE grad_rate_2019 IS NOT NULL;

SELECT
  year,
  CORR(ca_rate, poverty_rate_5_17) AS corr_poverty,
  CORR(ca_rate, student_teacher_ratio_clean) AS corr_staffing
FROM lea_year_master
WHERE poverty_rate_5_17 IS NOT NULL
  AND student_teacher_ratio_clean IS NOT NULL
GROUP BY year;

COPY lea_year_master TO 'C:\Users\enaho\Downloads\Absenteeism\lea_year_master.csv' (HEADER, DELIMITER ',');

COPY ca_all_years
TO 'C:\Users\enaho\Downloads\Absenteeism\Highlevel -EdDataExpress\allyeardata.csv'
WITH (HEADER, DELIMITER ',');


create TABLE lea_year_model_core AS
SELECT *
FROM lea_year_master
WHERE year IN (2019, 2023)
  AND ca_rate IS NOT NULL
  AND poverty_rate_5_17 IS NOT NULL
  AND student_teacher_ratio_clean IS NOT NULL
  AND pct_black IS NOT NULL
  AND pct_hispanic IS NOT NULL
  AND urbanicity IS NOT NULL;

create TABLE lea_year_model_with_grad AS
SELECT *
FROM lea_year_model_core
WHERE grad_rate_2019 IS NOT NULL;

COPY lea_year_model_core TO 'C:\Users\enaho\Downloads\Absenteeism\lea_year_model_core.csv' (HEADER, DELIMITER ',');

COPY lea_year_model_with_grad TO 'C:\Users\enaho\Downloads\Absenteeism\lea_year_model_with_grad.csv' (HEADER, DELIMITER ',');
