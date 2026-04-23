--https://www.census.gov/data/datasets/2023/demo/saipe/2023-state-and-county.html

CREATE TABLE saipe19 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\saipe19.csv');

CREATE TABLE saipe22 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\saipe22.csv');

CREATE TABLE saipe23 AS
SELECT *
FROM read_csv_auto('C:\Users\enaho\Downloads\Absenteeism\saipe23.csv');

CREATE TABLE saipe_2019_clean AS
SELECT
  LPAD(CAST("State FIPS Code" AS VARCHAR), 2, '0') ||
  LPAD(CAST("County FIPS Code" AS VARCHAR), 3, '0') AS county_fips,
  2019 AS year,
  "Poverty Percent, Age 5-17 in Families" AS poverty_rate_5_17,
  "Poverty Estimate, Age 5-17 in Families" AS child_poverty_count,
  "Median Household Income" AS median_household_income
FROM saipe19;

CREATE TABLE saipe_2022_clean AS
SELECT
  LPAD(CAST("State FIPS Code" AS VARCHAR), 2, '0') ||
  LPAD(CAST("County FIPS Code" AS VARCHAR), 3, '0') AS county_fips,
  2022 AS year,
  "Poverty Percent, Age 5-17 in Families" AS poverty_rate_5_17,
  "Poverty Estimate, Age 5-17 in Families" AS child_poverty_count,
  "Median Household Income" AS median_household_income
FROM saipe22;

CREATE TABLE saipe_2023_clean AS
SELECT
  LPAD(CAST("State FIPS Code" AS VARCHAR), 2, '0') ||
  LPAD(CAST("County FIPS Code" AS VARCHAR), 3, '0') AS county_fips,
  2023 AS year,
  "Poverty Percent, Age 5-17 in Families" AS poverty_rate_5_17,
  "Poverty Estimate, Age 5-17 in Families" AS child_poverty_count,
  "Median Household Income" AS median_household_income
FROM saipe23;



CREATE TABLE saipe_clean AS
SELECT * from saipe_2019_clean
union all
SELECT * from saipe_2022_clean
union all
SELECT * from saipe_2023_clean
