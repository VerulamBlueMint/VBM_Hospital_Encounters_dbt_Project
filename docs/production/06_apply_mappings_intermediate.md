# 06 — Apply Mappings (Intermediate)

## Goal
Replace inconsistent categoricals with canonical values using seed mapping tables, producing an intermediate layer suitable for downstream publish logic.

## Inputs
- `dbt_dev_staging.stg_parsed_dates`
- Seed mapping tables (created via `dbt seed`):
  - `map_encounter_type`
  - `map_department`
  - `map_severity`
  - `map_primary_diagnosis`

## Outputs
- `int_norm_categoricals` (intermediate model) with canonical columns:
  - `encounter_type_clean`
  - `department_clean`
  - `severity_level_clean`
  - `primary_diagnosis_clean`

## Commands
```bash
dbt build -s int_norm_categoricals
```

## Guardrails / tests
- **No row multiplication:** left joins to mapping seeds must not create duplicates.

- **Controlled vocabularies enforced (accepted values):**

  - `encounter_type_clean`: Emergency, Inpatient, Observation, Outpatient

  - `department_clean`: A&E, Cardiology, Trauma_&_Orthopaedics, General_Medicine, Surgery, Paediatrics, ICU

  - `severity_level_clean`: Low, Medium, High, Critical

  - `primary_diagnosis_clean`: Chest_Pain, Heart_Failure, Pneumonia, Hip_Fracture, Diabetes, COPD, Infection, Stroke, Other

- **Unmapped handling:** NULLs are allowed at this stage (handled in the next publish step).

## Notes
- **Implementation files:**

  - `models/intermediate/int_norm_categoricals.sql`

  - `models/intermediate/int_norm_categoricals.yml`

- This step applies canonical meaning; it does not impute placeholders yet. Unmapped values remain NULL until the publish/guardrails phase.
