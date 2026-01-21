# 07 — Placeholders, Admission Rule & Guardrails

## Goal
Enforce publish-safe constraints by:
- applying controlled placeholders for missing/unmapped categoricals
- deriving `is_admitted` from encounter type (per brief)
- enforcing schema-level guardrails with tests

## Inputs
- `int_norm_categoricals`

## Outputs
- `int_core_clean` (intermediate cleaned model with placeholders + enforced admission rule)

## Commands
```bash
dbt build -s int_core_clean
```

## Guardrails / tests
- Required fields
  - `bronze_row_id` is not null
- Accepted values enforced
  - `encounter_type`: Emergency, Inpatient, Observation, Outpatient, Unknown_Encounter
  - `department`: A&E, Cardiology, Trauma_&_Orthopaedics, General_Medicine, Surgery, Paediatrics, ICU, Unknown_Department
  - `severity_level`: Low, Medium, High, Critical, Unknown_Severity
  - `primary_diagnosis`: Chest_Pain, Heart_Failure, Pneumonia, Hip_Fracture, Diabetes, COPD, Infection, Stroke, Other, Unknown_Diagnosis
  - `is_admitted`: 0 or 1
- Admission rule enforced
  - `is_admitted` = 1 when encounter_type is Inpatient or Observation, else 0

## Notes
- Implementation files:
  - `models/intermediate/int_core_clean.sql`
  - `models/intermediate/_int_core_clean.yml`
- Placeholders are applied here so downstream aggregations do not split on NULLs or silently drop categories during group-bys.
