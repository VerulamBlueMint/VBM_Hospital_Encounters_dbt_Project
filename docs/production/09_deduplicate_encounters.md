# 09 — Deduplicate Encounters (Exact-Row Duplicates)

## Goal
Remove export-introduced exact-row duplicates so the encounter grain is stable and KPI counts (especially Total Encounters) are not inflated.

## Inputs
- `{{ ref('int_los_flags') }}` (core cleaned layer + LOS recalculation + eligibility flags)

## Outputs
- `{{ ref('int_dedup') }}` with:
  - deterministic duplicate removal using `row_number()` over the business-key signature
  - only `rn = 1` retained (lowest `bronze_row_id`)

## Commands
```bash
dbt run -s int_dedup
```
## Guardrails / tests
- Deduplication is deterministic: the “winner” row is the one with the lowest `bronze_row_id`
- No row multiplication: windowing should only filter rows down
- Encounter grain is stable for downstream KPI logic (one record per exact duplicate set)

## Notes
- This step targets exact-row duplicates introduced during export.
- Partition key matches the full business signature used in the model:
`encounter_id_txt`, `patient_id_txt`, `encounter_date`, `admission_date`, `discharge_date`, `encounter_type`, `department`, `primary_diagnosis`, `severity_level`, `is_admitted`, `length_of_stay_days_calc`.
