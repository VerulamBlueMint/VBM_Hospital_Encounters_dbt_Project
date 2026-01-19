{{ config(materialized='table') }}

select * from {{ ref('kpi_1_total_encounters') }}
union all select * from {{ ref('kpi_2_admission_rate') }}
union all select * from {{ ref('kpi_3_avg_los') }}
union all select * from {{ ref('kpi_4_median_los') }}
union all select * from {{ ref('kpi_5_high_acuity_share') }}
union all select * from {{ ref('kpi_6_emergency_encounter_share') }}
union all select * from {{ ref('kpi_7_dept_highest_avg_los') }}
union all select * from {{ ref('kpi_8_busiest_department_share') }}
union all select * from {{ ref('kpi_9_top_3_primary_diagnoses') }}
union all select * from {{ ref('kpi_10_readmission_30d_rate') }}
