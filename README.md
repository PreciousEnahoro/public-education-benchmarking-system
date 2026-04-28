# Public Education Benchmarking System: Structural and Institutional Drivers of District Absenteeism (U.S., 2019–2023)
This project presents a public education benchmarking system designed to distinguish structural constraints from institutional performance in U.S. school district absenteeism.

Using integrated public datasets, expected absenteeism rates are estimated based on structural factors such as poverty, staffing levels, demographic composition, year effects, and state fixed effects. Comparing actual absenteeism to these structural expectations produces an **Institutional Gap** metric that helps identify districts performing better or worse than expected given their operating conditions.

The result is a benchmarking framework that supports state-level monitoring, district-level exploration, and more meaningful comparisons across districts facing different structural realities.


## Live Tableau Dashboard

[Tableau Public Dashboard Here](https://public.tableau.com/app/profile/precious.o.enahoro/viz/PublicEducationBenchmarkingSystemDistrictAbsenteeismandStructuralDriversU_S_20192023/State-LevelStructuralBenchmarkingofAbsenteeism)


## Why this matters

Raw absenteeism comparisons can be misleading because districts operate under very different structural conditions. A district with a higher absenteeism rate may still be performing relatively well if it operates under more difficult socioeconomic constraints. This system addresses that problem by estimating structural expectation first, then benchmarking districts against that baseline.

In other words, **structural factors** shape expected outcomes and **institutional variation** explains why districts with similar conditions can still perform very differently.


## How this system helps

This system is designed as a reusable benchmarking framework, not just a descriptive dashboard. It demonstrates how fragmented public data can be transformed into an applied decision-support tool for evaluating public systems under structural constraints.


## Key findings
1. Structural factors explain a meaningful share of absenteeism, but do not fully account for differences across districts.
2. Accounting for state-level variation increases explanatory power, highlighting the importance of regional and policy context.
3. Districts with similar structural conditions still exhibit substantial variation in outcomes. This suggests that performance differences cannot be explained by context alone and that institutional factors play an important role.
   

## Data Sources
All data sources are publicly available and used in accordance with their respective usage policies.
This project integrates multiple public datasets:

- **NCES Common Core of Data (CCD)** – District-level enrollment and demographics  
  https://nces.ed.gov/ccd/files.asp  

- **NCES CCD Staffing Files** – Teacher counts and staffing data  
  https://nces.ed.gov/ccd/pubstaff.asp  

- **EdDataExpress Chronic Absenteeism Data** – District-level absenteeism rates  
  https://eddataexpress.ed.gov/download/data-library

- **SAIPE (Small Area Income and Poverty Estimates)** – Child poverty rates  
  https://www.census.gov/data/datasets/2023/demo/saipe/2023-state-and-county.html
  https://www.census.gov/programs-surveys/saipe.html  

- **NCES EDGE / Geographic Crosswalks** – LEA-to-county mappings  
  https://nces.ed.gov/programs/edge/Geographic/SchoolLocations
  https://nces.ed.gov/programs/edge/geographic/relationshipfiles

  
## Method Overview

The project was built in two stages:

*Data integration*
1. Harmonized district identifiers across datasets
2. Resolved one-to-many county-to-district joins
3. Built a district-year analytical table
4. Cleaned rate formatting, missing values, and structural variables

*Modeling and benchmarking*
1. Estimated pooled district-level absenteeism models for 2019 and 2023
2. Included interactions to test post-pandemic shifts
3. Added state fixed effects as a robustness check
4. Generated predicted absenteeism rates (“structural expectation”)
5. Calculated an **Institutional Gap** metric
   - The Institutional Gap is the difference between a district’s actual absenteeism rate and the absenteeism rate predicted by structural conditions. This helps    distinguish performance differences from structural disadvantage. Positive gap = higher absenteeism than expected; Negative gap = lower absenteeism than expected

## Model Specification and Results

To estimate structural expectations for district absenteeism, a pooled regression model was developed using district-level data from 2019 and 2023.

The core model includes:

- Child poverty rate (poverty_rate_5_17)
- Student–teacher ratio (student_teacher_ratio_clean)
- Student demographic composition (pct_black, pct_hispanic)
- Year effects and interaction terms to capture changes over time

This baseline model explains approximately **21% of variation** in district absenteeism, indicating that structural conditions account for a meaningful, but incomplete, portion of observed differences.

To assess robustness and account for geographic and policy variation, an extended specification includes **state fixed effects**. This model explains approximately **40% of variation**, suggesting that state-level factors — such as policy environments, funding structures, and regional conditions — play a substantial role in shaping absenteeism outcomes.

Across both specifications, structural variables remain significant predictors, but substantial variation persists across districts operating under similar conditions.

Graduation rate variables were tested but excluded from the final specification due to limited availability and to preserve consistency across years.


## Dashboard Structure

The Tableau dashboard is organized into three views:

1. **State-Level Structural Benchmarking:** Shows the share of districts underperforming relative to structural expectation and highlights state-level shifts since 2019.

2. **Structural Drivers:** Uses scatterplots to show the relationship between poverty and absenteeism, and the difference between expected and actual absenteeism.

3. **District Benchmark Explorer:** Allows users to search and compare districts by: actual absenteeism, structural expectation, institutional gap, poverty, staffing, and demographic context.


## Files in this repo
- ```sql/``` contains data preparation and table-building logic
- ```notebooks/``` contains modeling and export workflows
- ```outputs/``` contains model outputs and dashboard-ready files
- ```data_dictionary.md``` explains the final variables


## Limitations
1. Structural models do not capture all factors influencing absenteeism.
2. Some state and district data are incomplete across years.
3. Benchmarking results depend on the available structural variables and should not be interpreted as causal proof of institutional effectiveness.

## Contact and Collaboration
- **Author**: Precious Enahoro
- **GitHub**: @PreciousEnahoro
- **Linkedin**: (https://www.linkedin.com/in/precious-enahoro/)

## Future extensions
1. Add additional years
2. Extend benchmarking to more education outcomes
3. Incorporate finance and resource allocation variables
4. Adapt the framework for other public-interest systems
