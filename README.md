# Public Education Benchmarking System: Structural and Institutional Drivers of District Absenteeism (U.S., 2019–2023)

This project presents a **public education benchmarking system** designed to distinguish structural constraints from institutional performance in U.S. school district absenteeism.

Using integrated public datasets, expected absenteeism rates are estimated based on structural factors such as poverty, staffing levels, demographic composition, year effects, and state-level variation. Comparing actual absenteeism to these structural expectations produces an **Institutional Gap** metric that identifies districts performing better or worse than expected given their operating conditions.

The result is a scalable benchmarking framework that supports **state-level monitoring, district-level exploration, and more meaningful performance comparisons across structurally different environments**.

---

## Live Tableau Dashboard

[Tableau Public Dashboard Here](https://public.tableau.com/app/profile/precious.o.enahoro/viz/PublicEducationBenchmarkingSystemDistrictAbsenteeismandStructuralDriversU_S_20192023/State-LevelStructuralBenchmarkingofAbsenteeism)

---

## Why This Matters

Public education systems operate under widely varying structural conditions, including differences in socioeconomic context, staffing capacity, and demographic composition. As a result, direct comparisons of absenteeism rates across districts can be misleading.

A district with higher absenteeism may still be performing relatively well given its structural constraints, while another may underperform despite more favorable conditions.

This project addresses that gap by separating:

- **Structural factors**, which shape expected outcomes  
- **Institutional performance**, which explains variation among districts facing similar conditions  

By establishing a structural baseline first, the system enables **fairer, context-aware evaluation of district performance**.

---

## How This System Helps

This project is designed as a **reusable data infrastructure and decision-support system**, not just a descriptive analysis.

It demonstrates how fragmented public data can be transformed into a structured, scalable framework for:

- Benchmarking performance across heterogeneous systems  
- Identifying districts that outperform or underperform relative to structural expectations  
- Supporting more targeted, data-informed policy and operational decisions  

More broadly, this approach addresses a common “last-mile” public data challenge: transforming widely available but fragmented datasets into **usable, decision-ready systems**.

---

## Key Findings

- Structural factors explain a meaningful share of absenteeism, but do not fully account for differences across districts.  
- Accounting for state-level variation significantly increases explanatory power, highlighting the importance of regional and policy context.  
- Districts with similar structural conditions still exhibit substantial variation in outcomes, indicating that performance differences cannot be explained by context alone.  

---

## Data Sources

All data sources are publicly available and used in accordance with their respective usage policies.

This project integrates multiple federal and public datasets:

- **NCES Common Core of Data (CCD)** – District-level enrollment and demographics  
  https://nces.ed.gov/ccd/files.asp  

- **NCES CCD Staffing Files** – Teacher counts and staffing data  
  https://nces.ed.gov/ccd/pubstaff.asp  

- **EdDataExpress Chronic Absenteeism Data** – District-level absenteeism rates  
  https://eddataexpress.ed.gov/download/data-library  

- **SAIPE (Small Area Income and Poverty Estimates)** – Child poverty rates  
  https://www.census.gov/programs-surveys/saipe.html  

- **NCES EDGE / Geographic Crosswalks** – LEA-to-county mappings  
  https://nces.ed.gov/programs/edge/geographic/relationshipfiles  

---

## Method Overview

The system was developed in two stages:

### Data Integration

- Harmonized district identifiers across multiple datasets  
- Resolved one-to-many county-to-district relationships  
- Constructed a unified district-year analytical table  
- Cleaned and standardized structural variables and rates  

### Modeling and Benchmarking

- Estimated pooled district-level absenteeism models for 2019 and 2023  
- Included interaction terms to capture post-pandemic shifts  
- Added state fixed effects as a robustness check  
- Generated predicted absenteeism rates (“structural expectation”)  
- Calculated an **Institutional Gap** metric  

> **Institutional Gap = Actual Absenteeism − Expected Absenteeism**  
> Positive values indicate higher-than-expected absenteeism, while negative values indicate lower-than-expected absenteeism.

---

## Model Specification and Results

To estimate structural expectations, a pooled regression model was developed using district-level data from 2019 and 2023.

### Core Model

Includes:

- Child poverty rate (`poverty_rate_5_17`)  
- Student–teacher ratio (`student_teacher_ratio_clean`)  
- Student demographic composition (`pct_black`, `pct_hispanic`)  
- Year effects and interaction terms  

This baseline model explains approximately **21% of variation** in district absenteeism.

### State Fixed Effects Model (Robustness Check)

An extended specification incorporates **state fixed effects** to control for regional and policy variation.

This model explains approximately **40% of variation**, indicating that state-level factors play a substantial role in shaping absenteeism outcomes.

Across both models, structural variables remain significant predictors, while meaningful variation persists within structurally similar environments.

Graduation rate variables were tested but excluded from the final specification due to limited availability and consistency across years.

---

## Dashboard Structure

The Tableau dashboard is organized into three views:

1. **State-Level Structural Benchmarking**  
   Highlights the share of districts underperforming relative to structural expectations and tracks changes over time  

2. **Structural Drivers**  
   Visualizes relationships between key structural factors and absenteeism, and compares expected vs. actual outcomes  

3. **District Benchmark Explorer**  
   Enables district-level exploration across performance, structural conditions, and institutional gap metrics  

---

## Files in This Repository

- `sql/` – Data preparation and integration logic  
- `notebooks/` – Modeling, evaluation, and export workflows  
- `outputs/` – Model outputs and Tableau-ready datasets  
- `data_dictionary.md` – Definitions of final variables  

---

## Limitations

- Structural models do not capture all drivers of absenteeism  
- Some datasets have incomplete coverage across years  
- Results are descriptive and predictive, not causal  

---

## Contact and Collaboration

- **Author**: Precious Enahoro  
- **GitHub**: @PreciousEnahoro
- **Linkedin**: (https://www.linkedin.com/in/precious-enahoro/)

This work is part of a broader effort to develop scalable data systems for evaluating and strengthening performance in public-interest institutions.

---

## Future Extensions

- Extend analysis to additional years and post-pandemic trends  
- Incorporate financial and resource allocation variables  
- Apply benchmarking framework to other education outcomes  
- Adapt methodology to other public and nonprofit systems  
