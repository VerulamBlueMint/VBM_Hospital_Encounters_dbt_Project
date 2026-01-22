# 08 — LOS Recalculation & KPI Eligibility Flags

## Goal
Recompute a trustworthy length-of-stay (LOS) from typed dates and create reusable eligibility flags so KPI logic can consistently exclude invalid spells.

## Inputs
- `{{ ref('int_core_clean') }}` (core cleaned layer with placeholders + enforced `is_admitted`)

## Outputs
- `{{ ref('int_los_flags') }}` with:
  - `length_of_stay_days_calc`
  - `los_eligible_flag`
  - `readmission_eligible_flag`

## Commands
```bash
dbt run -s int_los_flags
```
## Guardrails / tests
- `length_of_stay_days_calc` is only populated when:
- `admission_date` and `discharge_date` are present, and
- `discharge_date` >= `admission_date`
- `los_eligible_flag` = 1 only when the spell logic above is valid and is_admitted = 1
- `readmission_eligible_flag` = 1 only when the spell logic above is valid and is_admitted = 1

## Notes

This step ensures KPIs that depend on spell logic (LOS and readmissions) do not accidentally include encounters with missing/invalid admission/discharge dates.

