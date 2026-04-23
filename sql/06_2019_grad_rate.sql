CREATE TABLE grad1819 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\graduation1819.csv');

CREATE TABLE graduation1819 AS
SELECT
    "NCES LEA ID" AS LEAID,
    2019 AS year,

    CASE
        -- Top-coded
        WHEN Value LIKE '>=%' THEN 
            CAST(REPLACE(Value, '>=', '') AS DOUBLE)

        -- Bottom-coded
        WHEN Value LIKE '<=%' THEN 
            CAST(REPLACE(Value, '<=', '') AS DOUBLE)

        -- Range values like 90-94
        WHEN Value LIKE '%-%' THEN
            (
                CAST(SPLIT_PART(Value, '-', 1) AS DOUBLE) +
                CAST(SPLIT_PART(Value, '-', 2) AS DOUBLE)
            ) / 2
		WHEN Value LIKE 'S' THEN NULL
        -- Normal numeric
        ELSE CAST(Value AS DOUBLE)
    END AS grad_rate_2019,

    Denominator AS cohort_size_2019,

    CASE
        WHEN Value LIKE '>=%' 
          OR Value LIKE '<=%'
          OR Value LIKE '%-%'
        THEN 1 ELSE 0
    END AS grad_imputed_flag

FROM grad1819
WHERE
    School IS NULL
    AND Subgroup = 'All Students'
    AND "Data Description" = 'Four-Year Adjusted-Cohort Graduation Rates';
