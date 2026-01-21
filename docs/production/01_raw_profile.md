 # 01 — Raw Profile

## Goal
Quantify what arrives in raw: volume, nulls, duplicates, and date-text patterns, before any transformations.

## Inputs
- Raw encounters source table (Fabric Warehouse) declared as a dbt `source()`:
  - `{{ source('bronze', 'encounters_raw') }}` (configured in `models/bronze/_bronze_sources.yml`)
- Staging model that adds a deterministic technical row id:
  - `models/staging/stg_bronze_rowid.sql`

## Outputs
- `dbt_dev_staging.stg_bronze_rowid` (view/table depending on your dbt defaults)
  - Adds `bronze_row_id` for deterministic ordering and later deduplication / audit checks
- Baseline profiling metrics (row counts, null rates, date-text patterns) used later as integrity checks

## Commands
```bash
# Build the first staging output with deterministic row id
dbt run -s stg_bronze_rowid

# (Optional) validate connection + config first
# dbt debug
```


## Guardrails / tests
- Baseline row count captured from `stg_bronze_rowid` (used later to detect unexpected row loss)
- Null-rate checks for key fields (e.g., `patient_id`, `encounter_date`, `admission_date`, `discharge_date`, and categories)
- Date-as-text pattern distribution captured (e.g., expected DD-MM-YYYY patterns vs unexpected formats)
- Duplicate candidate rate measured using a business-key signature (note: `bronze_row_id` is used only for deterministic tie-breaking later, not as a business key)

## Notes
- This step is intentionally “read-only”: it makes the raw table a governed source() and adds a deterministic `bronze_row_id`, but it does not clean or filter records yet.

- `bronze_row_id` ordering is derived from the raw text/date columns as provided, to ensure repeatability across runs.
