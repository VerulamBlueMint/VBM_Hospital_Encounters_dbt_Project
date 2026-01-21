# 02 — Standardise Text

## Goal
Standardise raw text fields into consistent “clean text inputs” for downstream parsing and matching, without changing business meaning:
- trim leading/trailing whitespace
- normalise casing (lowercase for categorical/ID text)
- convert empty strings to NULL safely (`nullif(..., '')`)

## Inputs
- `dbt_dev_staging.stg_bronze_rowid` 
  - Source: `{{ ref('stg_bronze_rowid') }}`

## Outputs
- `dbt_dev_staging.stg_standard_txt` (view)
  - Standardised `_txt` columns used by later mapping + date parsing steps:
    - `encounter_id_txt`, `patient_id_txt`
    - `encounter_date_txt`, `admission_date_txt`, `discharge_date_txt`
    - `encounter_type_txt`, `department_txt`, `primary_diagnosis_txt`, `severity_level_txt`
    - `is_admitted_txt`, `length_of_stay_days_txt`

## Commands
```bash
# Build standardised text staging model (ref() chaining from stg_bronze_rowid)
dbt run -s stg_standard_txt
```

## Guardrails / tests
- No unexpected row loss: row count of `stg_standard_txt` should match `stg_bronze_rowid`
- Key columns remain present:
  - `bronze_row_id` retained
  - `expected _txt` columns populated (NULL where source was blank/whitespace)
- Standardisation is “safe”:
  - only trimming, lowercasing, and empty-string-to-NULL are applied
  - no mappings, no type parsing, and no filtering in this step

## Notes
- This step is intentionally reversible/transparent: it produces cleaned text representations of fields, not typed values.
- Lowercasing is applied to identifiers and categorical text columns; date text columns are trimmed but not lowercased (to preserve format for parsing rules later).
