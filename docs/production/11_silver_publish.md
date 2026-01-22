# 11 — Silver Publish (Final Cleaned Encounters Table)

## Goal
Publish the final analysis-ready encounters table (all years) with:
- stable encounter grain (one row per encounter)
- correct types for downstream reporting
- enforced contract tests on identifiers and key dates

## Inputs
- `{{ ref('int_with_clean_id') }}` (deduped + cleaned + LOS recomputed + `encounter_id_clean` generated)

## Outputs
- `silver.silver_encounters_final` containing:
  - `encounter_id` (final, non-null, unique)
  - `patient_id`
  - typed dates: `encounter_date`, `admission_date`, `discharge_date`
  - canonical categoricals: `encounter_type`, `department`, `primary_diagnosis`, `severity_level`
  - `is_admitted`
  - `length_of_stay_days` (recomputed LOS)

## Commands
```bash
# Build + run model and execute associated tests in one go
dbt build -s silver_encounters_final

# (Equivalent explicit run/test split)
dbt run  -s silver_encounters_final
dbt test -s silver_encounters_final
```
## Guardrails / tests
- `encounter_id` is enforced as not null and unique
- `patient_id` is not null
- `encounter_date` is not null
- `discharge_date` is not null

## Notes
- Implementation files:

  - `models/silver/silver_encounters_final.sql`
  - `models/silver/silver_final_schema.yml`

- This is the published “cleaned encounters” deliverable. Gold models and KPI models should depend only on `silver_encounters_final`.
