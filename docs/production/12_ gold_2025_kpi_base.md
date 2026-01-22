# 12 — Gold (2025 KPI Base + Helper Flags)

## Goal
Create the KPI-ready 2025 encounters dataset and attach reusable helper flags so KPI models stay small and readable:
- restrict to calendar year 2025
- add LOS + readmission eligibility flags
- add high-acuity and emergency flags

## Inputs
- `{{ ref('silver_encounters_final') }}` (final cleaned encounters table, all years)

## Outputs
- `gold.gold_encounters_final` containing:
  - 2025-only encounters (by `encounter_date`)
  - helper flags:
    - `los_eligible_flag`
    - `readmission_eligible_flag`
    - `is_high_acuity`
    - `is_emergency`

## Commands
```bash
# Build + run model and execute associated tests in one go
dbt build -s gold_encounters_final

# (Equivalent explicit run/test split)
dbt run  -s gold_encounters_final
dbt test -s gold_encounters_final
```
## Guardrails / tests
- Contract tests on the published gold table:
  - `encounter_id` is not null and unique
  - `encounter_date` is not null
- Cohort rule enforced in model SQL:
  - `encounter_date` >= '2025-01-01' AND `encounter_date` < '2026-01-01'
- Helper flags are deterministic and derived only from cleaned silver fields:
  - eligibility flags require `is_admitted` = 1 and valid spell dates (`admission_date`/`discharge_date` present and ordered)
  - `is_high_acuity` derived from `severity_level` IN ('High','Critical')
  - `is_emergency` derived from `encounter_type` = 'Emergency'

## Notes
- Implementation files:

  - `models/gold/gold_encounters_final.sql`
  - `models/gold/gold_schema.yml`

- Gold is the single KPI base contract. All KPI models should source from `gold_encounters_final` (not from Silver or intermediate models).
