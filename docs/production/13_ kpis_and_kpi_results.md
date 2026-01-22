# 13 — KPI Models (1–10) + Consolidated `kpi_results`

## Goal
Produce the required KPI outputs using small, focused models and publish a single consolidated results table with the exact schema:
- `(kpi_name, kpi_value, kpi_key)`

## Inputs
- `{{ ref('gold_encounters_final') }}` (2025 KPI base with helper flags)

## Outputs
- KPI models under `models/gold/kpis/`:
  - `kpi_1_total_encounters`
  - `kpi_2_admission_rate`
  - `kpi_3_avg_los`
  - `kpi_4_median_los`
  - `kpi_5_high_acuity_share`
  - `kpi_6_emergency_encounter_share`
  - `kpi_7_dept_highest_avg_los`
  - `kpi_8_busiest_department_share`
  - `kpi_9_top_3_primary_diagnoses`
  - `kpi_10_readmission_30d_rate`
- Consolidated table:
  - `gold.kpi_results` (materialized table)

## Commands
```bash
# Build all KPI models (tagged) and then publish the consolidated table
dbt run -s tag:kpis
dbt run -s kpi_results
```
## Guardrails / tests
- Output contract is enforced by design in every KPI model:
  - `kpi_name` is a fixed identifier ('kpi_1' … 'kpi_10')
  - `kpi_value` is cast to varchar(50) for consistent downstream handling
  - `kpi_key` is cast to varchar(200) and is null unless the KPI has a dimension key
- Cohort and eligibility rules are applied where required:
  - LOS KPIs (kpi_3, kpi_4, kpi_7) use is_admitted = 1 AND los_eligible_flag = 1
  - Readmission KPI (kpi_10) uses is_admitted = 1 AND readmission_eligible_flag = 1
- Median LOS implementation:
  - `kpi_4_median_los` uses PERCENTILE_CONT(0.5) (T-SQL) over eligible admitted LOS values
- Expected row shapes:
  - `kpi_results` contains one “block” per KPI, with kpi_9 returning 3 rows by design (top 3 diagnoses)

## Notes
- Implementation files:

  - `models/gold/kpis/kpi_1_total_encounters.sql`
  - `models/gold/kpis/kpi_2_admission_rate.sql`
  - `models/gold/kpis/kpi_3_avg_los.sql`
  - `models/gold/kpis/kpi_4_median_los.sql`
  - `models/gold/kpis/kpi_5_high_acuity_share.sql`
  - `models/gold/kpis/kpi_6_emergency_encounter_share.sql`
  - `models/gold/kpis/kpi_7_dept_highest_avg_los.sql`
  - `models/gold/kpis/kpi_8_busiest_department_share.sql`
  - `models/gold/kpis/kpi_9_top_3_primary_diagnoses.sql`
  - `models/gold/kpis/kpi_10_readmission_30d_rate.sql`
  - `models/gold/kpis/kpi_results.sql`
- `kpi_results` is materialized as a table and unions all KPI model outputs using UNION ALL to preserve multi-row KPIs (notably kpi_9).
