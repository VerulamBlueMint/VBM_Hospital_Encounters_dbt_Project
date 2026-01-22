# 10 — Synthetic Encounter IDs (Fill Missing `encounter_id`)

## Goal
Guarantee a unique `encounter_id` for every row using a deterministic rule:
- keep the original `encounter_id` where present
- otherwise generate a synthetic ID based on `patient_id` + encounter day (and a 2-digit sequence when needed)

## Inputs
- `{{ ref('int_dedup') }}` (deduplicated encounter grain)

## Outputs
- `{{ ref('int_id_seq') }}` with per-patient-per-day sequencing fields:
  - `seq_for_patient_day`
  - `cnt_for_patient_day`
- `{{ ref('int_with_clean_id') }}` with:
  - `encounter_id_clean`
  - `encounter_id_was_synthetic_flag`

## Commands
```bash
dbt run -s int_id_seq
dbt run -s int_with_clean_id
```
## Guardrails / tests
- `encounter_id_clean` is populated for every row
- Synthetic ID generation is deterministic (stable across reruns given stable inputs)
- Synthetic IDs are only generated when `encounter_id_txt` is NULL
- Per-patient-per-day collisions are resolved by the 2-digit sequence (01, 02, …) when `cnt_for_patient_day` > 1

## Notes
- Synthetic ID format:
  - `patient_id_txt` + `YYYYMMDD` (from `encounter_date`) + optional 2-digit sequence
- The sequence suffix is blank when a patient has only one encounter on that date.
- `encounter_id_was_synthetic_flag` = 1 indicates the ID was generated (useful for auditing and reporting).
