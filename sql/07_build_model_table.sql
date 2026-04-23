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

COPY lea_year_master TO 'C:\Users\enaho\Downloads\Absenteeism\lea_year_master.csv' (HEADER, DELIMITER ',');


--Base table used in modelling: lea_year_model_core
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


COPY lea_year_model_core TO 'C:\Users\enaho\Downloads\Absenteeism\lea_year_model_core.csv' (HEADER, DELIMITER ',');


--Making sure grad is full; didn't end up using
create TABLE lea_year_model_with_grad AS
SELECT *
FROM lea_year_model_core
WHERE grad_rate_2019 IS NOT NULL;

COPY lea_year_model_with_grad TO 'C:\Users\enaho\Downloads\Absenteeism\lea_year_model_with_grad.csv' (HEADER, DELIMITER ',');
