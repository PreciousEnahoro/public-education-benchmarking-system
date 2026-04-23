--https://nces.ed.gov/ccd/files.asp#Fiscal:2,LevelId:5,Page:3

CREATE TABLE staff19 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\staff2019.csv');

CREATE TABLE staff22 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\staff2022.csv');

CREATE TABLE staff23 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\staff2023.csv');

create TABLE teachers23 AS
SELECT
  LEAID,
  2023 AS year,
  SUM(STAFF_COUNT) AS teacher_fte
FROM staff23
WHERE STAFF = 'Teachers' 
GROUP BY LEAID;

create TABLE teachers22 AS
SELECT
  LEAID,
  2022 AS year,
  SUM(STAFF_COUNT) AS teacher_fte
FROM staff22
WHERE STAFF = 'Teachers' 
GROUP BY LEAID;

create TABLE teachers19 AS
SELECT
  LEAID,
  2019 AS year,
  SUM(STAFF_COUNT) AS teacher_fte
FROM staff19
WHERE STAFF = 'Teachers' 
GROUP BY LEAID;


CREATE table teachers_all_years AS
SELECT * FROM teachers19
UNION ALL
SELECT * FROM teachers22
UNION ALL
SELECT * FROM teachers23;


CREATE TABLE staff_capacity_all_years AS
SELECT
  s.LEAID,
  s.year,
  s.teacher_fte,
  e.total_enrollment,
  e.total_enrollment * 1.0 / NULLIF(s.teacher_fte, 0) AS student_teacher_ratio
FROM teachers_all_years s
LEFT JOIN (
  SELECT DISTINCT LEAID, year, total_enrollment
  FROM ccd_demo_all_years
) e
ON s.LEAID = e.LEAID AND s.year = e.year;



CREATE TABLE staff_capacity_qc AS
SELECT
  LEAID,
  year,
  teacher_fte,
  total_enrollment,
  student_teacher_ratio,

  CASE
    WHEN teacher_fte IS NULL THEN 'missing_teacher'
    WHEN teacher_fte <= 1 THEN 'near_zero_teacher'
    WHEN student_teacher_ratio > 100 THEN 'implausible_ratio'
    ELSE 'ok'
  END AS ratio_qc_flag

FROM staff_capacity_all_years;



CREATE TABLE staff_capacity_final AS
SELECT
  LEAID,
  year,
  teacher_fte,
  total_enrollment,
  student_teacher_ratio,

  CASE
    WHEN student_teacher_ratio BETWEEN 5 AND 60
      THEN student_teacher_ratio
    ELSE NULL
  END AS student_teacher_ratio_clean,

  ratio_qc_flag

FROM staff_capacity_qc;
GROUP BY year
ORDER BY year;
