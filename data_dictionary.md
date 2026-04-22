# Data Dictionary

## Core identifiers
- **LEAID:** NCES district identifier
- **state:** U.S. state
- **year:** observation year

## Outcome and model outputs
- **ca_rate:** Actual district absenteeism rate
- **pred_ca_rate:** Predicted absenteeism rate based on structural model
- **residual:** Actual absenteeism minus predicted absenteeism
- **Gap (pp):** Residual expressed in percentage points

## Structural variables
- **poverty_rate_5_17:** Child poverty rate for ages 5–17
- **student_teacher_ratio_clean:** Students per teacher
- **pct_black:** Share of students identified as Black
- **pct_hispanic:** Share of students identified as Hispanic
- **is_urban / urban?:** Urban context indicator

## Dashboard fields
- **Performance vs Expectation:** Categorized benchmark status based on institutional gap
- **Percent Underperforming Districts:** State-level share of districts with positive institutional gap
