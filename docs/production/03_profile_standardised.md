# 03 — Profile Standardised

## Goal
Re-profile after text standardisation to confirm:
- standardisation worked (trim/lower, blanks → NULL)
- categorical variants + prevalence are captured to build seed mapping tables
- date patterns, admission flag values, and LOS numeric validity are evidenced before rules

## Inputs
- `dbt_dev_staging.stg_standard_txt` (output of `stg_standard_txt`)

## Outputs
- Profiling queries stored as a dbt analysis:
  - `analyses/profiling_after_standardisation.sql`
- Findings documented in dbt docs:
  - `docs/profiling_findings_standardised.md` (docs block)
- Analysis entry registered in dbt docs:
  - `analyses/profiling_after_standardisation.yml`
- Generated dbt docs site (optional):
  - via `dbt docs generate` / `dbt docs serve`

## Commands
```bash
# Build the upstream standardised staging output (if not already built)
dbt run -s stg_standard_txt

# Generate and view dbt docs (renders the findings doc block)
dbt docs generate
dbt docs serve
```

## Guardrails / tests

- Row counts stable: confirm total rows in `dbt_dev_staging.stg_standard_txt` match expectation (e.g. 103,000 in this dataset).

- Date pattern evidence captured: confirm `encounter_date_txt` follows a single expected pattern (dd-mm-yyyy) and flag any wrong-length values.

- Seed mapping evidence captured: frequency tables (cnt + pct) for:

  - `encounter_type_txt`
  - `department_txt`
  - `severity_level_txt`
  - `primary_diagnosis_txt`

- Fields to override documented: scan `is_admitted_txt` values and document the decision to derive admission status from cleaned encounter type (per brief).

- LOS text not trusted as numeric: run TRY_CAST checks on `length_of_stay_days_txt` and document non-numeric rate; plan to derive LOS later from parsed dates.

## Notes
- This phase uses **Fabric Warehouse T-SQL profiling** against `dbt_dev_staging.stg_standard_txt` and is stored under `analyses/` (multiple standalone SELECT statements, not a single model).

- Findings in `docs/profiling_findings_standardised.md` directly drive:

  - seed mappings (raw_value lists)

  - Unknown/Other handling strategy

  - date parsing strategy

  - decisions to ignore/override unreliable raw fields
