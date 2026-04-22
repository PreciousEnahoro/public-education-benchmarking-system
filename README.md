# Public Education Benchmarking System: Structural and Institutional Drivers of District Absenteeism (U.S., 2019–2023)
This project presents a public education benchmarking system designed to distinguish structural constraints from institutional performance in U.S. school district absenteeism.

Using integrated public datasets, expected absenteeism rates are estimated based on structural factors such as poverty, staffing levels, demographic composition, year effects, and state fixed effects. Comparing actual absenteeism to these structural expectations produces an **Institutional Gap** metric that helps identify districts performing better or worse than expected given their operating conditions.

The result is a benchmarking framework that supports state-level monitoring, district-level exploration, and more meaningful comparisons across districts facing different structural realities.

## Live Tableau Dashboard

[Tableau Public Dashboard Here](https://public.tableau.com/app/profile/precious.o.enahoro/viz/PublicEducationBenchmarkingSystemDistrictAbsenteeismandStructuralDriversU_S_20192023/State-LevelStructuralBenchmarkingofAbsenteeism)


## Why this matters

Raw absenteeism comparisons can be misleading because districts operate under very different structural conditions. A district with a higher absenteeism rate may still be performing relatively well if it operates under more difficult socioeconomic constraints. This system addresses that problem by estimating structural expectation first, then benchmarking districts against that baseline.

In other words:

- **Structural factors** shape expected outcomes.
- **Institutional variation** explains why districts with similar conditions can still perform very differently.

  
## Main question

How much of district absenteeism is associated with structural conditions, and where do meaningful performance differences remain after accounting for those conditions?

## Data sources

This project integrates multiple public data sources, including:

- NCES CCD membership and demographics files
- NCES staffing files
- EDFacts chronic absenteeism data
- SAIPE child poverty estimates
- NCES/EDGE geographic crosswalks

  
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


## Key findings
1. Structural factors explain approximately **21% of variation** in district absenteeism.
2. Child poverty remains a strong within-state predictor of absenteeism.
3. The relationship between poverty and absenteeism strengthened in 2023 relative to 2019.
4. Districts with similar structural conditions still exhibit meaningful differences in outcomes. This suggests that structural context matters, but institutional variation also plays an important role.

## Dashboard structure

The Tableau dashboard is organized into three views:

1. State-Level Structural Benchmarking

Shows the share of districts underperforming relative to structural expectation and highlights state-level shifts since 2019.

2. Structural Drivers

Uses scatterplots to show the relationship between poverty and absenteeism, and the difference between expected and actual absenteeism

3. District Benchmark Explorer

Allows users to search and compare districts by: actual absenteeism, structural expectation, institutional gap, poverty, staffing, demographic context


## Why this project is useful

This system is designed as a reusable benchmarking framework, not just a descriptive dashboard. It shows how fragmented public data can be transformed into an applied decision-support tool for evaluating public systems under structural constraint.

## Files in this repo
- sql/ contains data preparation and table-building logic
- notebooks/ contains modeling and export workflows
- outputs/ contains model outputs and dashboard-ready files
- data_dictionary.md explains the final variables


## Limitations
1. Structural models do not capture all factors influencing absenteeism.
2. Some state and district data are incomplete across years.
3. Benchmarking results depend on the available structural variables and should not be interpreted as causal proof of institutional effectiveness.


## Future extensions
1. Add additional years
2. Extend benchmarking to more education outcomes
3. Incorporate finance and resource allocation variables
4. Adapt the framework for other public-interest systems
