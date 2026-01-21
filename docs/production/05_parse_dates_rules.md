# 05 — Parse Dates & Apply Rules

## Goal
Safely parse DD-MM-YYYY text dates into typed dates and enforce core spell rules:
- invalid date strings → NULL (no pipeline failure)
- exclude rows with missing `discharge_date`
- for rows with an admission date present: enforce `discharge_date >= admission_date`

## Inputs
- `dbt_dev_staging.stg_standard_txt`  

## Outputs
- `dbt_dev_staging.stg_parsed_dates` containing:
  - typed date fields: `encounter_date`, `admission_date`, `discharge_date`
  - filtered cohort where:
    - `discharge_date` is not null
    - and (`admission_date` is null OR `discharge_date >= admission_date`)

## Commands
```bash
# Build + run model and execute associated tests in one go
dbt build -s stg_parsed_dates

# (Equivalent explicit run/test split)
dbt run  -s stg_parsed_dates
dbt test -s discharge_before_admission
```

## Guardrails / tests
- Safe date parsing: `TRY_CONVERT` returns NULL on parse failure (pipeline does not error).

- Discharge required: `stg_parsed_dates` excludes rows where `discharge_date` is NULL.

- Spell validity: admitted spell ordering enforced (when `admission_date` is present, `discharge_date` >= `admission_date`).

- Singular test (must return 0 rows):

  - `tests/discharge_before_admission.sql`

## Notes
**Implementation files:**

- `models/staging/encounters/stg_parsed_dates.sql`

- `tests/discharge_before_admission.sql`
