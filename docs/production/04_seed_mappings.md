# 04 — Seed Mappings

## Goal
Use seed-driven mapping tables to normalise inconsistent categories into controlled sets:
- `encounter_type`
- `department`
- `severity_level`
- `primary_diagnosis`
- `admitted` flag (text → 0/1)

## Inputs
- `dbt_dev_staging.stg_standard_txt` (standardised `_txt` fields)
- Seed CSVs (in-repo):
  - `seeds/mappings/map_encounter_type.csv`
  - `seeds/mappings/map_department.csv`
  - `seeds/mappings/map_severity.csv`
  - `seeds/mappings/map_primary_diagnosis.csv`
  - `seeds/mappings/map_admitted.csv`
- Seed schema + tests:
  - `seeds/mappings/seed_mappings_schema.yml`
- Seed config (dbt project):
  - `dbt_project.yml` seeds config (schema + column types for `map_admitted`)

## Outputs
- Seed tables created in the target warehouse schema (per project config: `staging`), one per CSV:
  - `map_encounter_type`
  - `map_department`
  - `map_severity`
  - `map_primary_diagnosis`
  - `map_admitted`
- Seed tests registered and runnable from the project:
  - not_null / unique on `raw_value`
  - accepted_values on `canonical_value`

## Commands
```bash
# Load seed CSVs into the Warehouse as tables (under the configured schema)
dbt seed

# Validate seed tables (docs + tests)
dbt test -s map_encounter_type map_department map_severity map_primary_diagnosis map_admitted
```



## Guardrails / tests
- Seed integrity:
  - raw_value is not null and unique in each mapping table.
  - canonical_value is not null.
- Accepted-values enforcement (canonical vocabularies):

  - `map_encounter_type.canonical_value` ∈ {Emergency, Inpatient, Observation, Outpatient}

  - `map_department.canonical_value` ∈ {A&E, Cardiology, Trauma_&_Orthopaedics, General_Medicine, Surgery, Paediatrics, ICU}

  - `map_severity.canonical_value` ∈ {Low, Medium, High, Critical}

  - `map_primary_diagnosis.canonical_value` ∈ {Chest_Pain, Heart_Failure, Pneumonia, Hip_Fracture, Diabetes, COPD, Infection, Stroke, Other}

  - `map_admitted.canonical_value` ∈ {0, 1}

- Load behaviour:

  - Seed tables land in the configured schema (staging) and are recreated deterministically on `dbt seed`.

## Notes
- Seed CSVs are derived from distinct-value profiling of the `standardised _txt` columns, so mappings are grounded in observed raw variants.

- Updating a seed is a controlled change to business meaning: it alters how raw values map into canonical categories.

- `map_admitted` uses explicit column typing via `dbt_project.yml` seed configuration to ensure `canonical_value` loads as a 0/1 text flag.
