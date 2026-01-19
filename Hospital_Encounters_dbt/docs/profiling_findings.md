{% docs profiling_findings %}

# Data Profiling Findings — Healthcare Encounters (Raw)

**Data Source**: `Hospital_Encounters_Warehouse.bronze.C08_l01_healthcare_encounters_data_table`  
**Total Rows**: **103,000**

## 1) Shape
- Distinct `encounter_id`: **99,024** (→ **3,976** rows are not unique by `encounter_id`, including missing IDs)
- Distinct `patient_id`: **24,541**

## 2) Completeness (null/blank)
Missing counts (and % of 103,000):
- `encounter_id`: **1,002** (**0.97%**)
- `discharge_date`: **1,003** (**0.97%**)
- `department`: **2,061** (**2.00%**)
- `severity_level`: **2,044** (**1.98%**)
- `length_of_stay_days`: **2,045** (**1.99%**)

Zero missing (in this check):
- `patient_id`, `encounter_date`, `encounter_type`, `admission_date`, `primary_diagnosis`, `is_admitted`

## 3) Immediate implications
- `encounter_id` cannot be relied on as a primary key (missing + non-unique); use `bronze_row_id` for deterministic row identity.
- Any LOS / discharge-based logic must safely handle missing `discharge_date` and `length_of_stay_days`.
- Missing `department` / `severity_level` needs an explicit “Unknown/Unassigned” strategy (or controlled filtering) before KPI breakdowns.

{% enddocs %}
