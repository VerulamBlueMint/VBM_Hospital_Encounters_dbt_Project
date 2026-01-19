{% docs profiling_findings_standardised %}

# Data Profiling Findings — After Standardisation

**Data Source**: `dbt_dev_staging.stg_standard_txt`  
**Total Rows**: **103,000**

## 1) Null rates (post-standardisation)
- `encounter_type_txt`: **0 / 103,000 (0.00%)**  
- `department_txt`: **2,061 / 103,000 (2.00%)**  
- `severity_level_txt`: **2,044 / 103,000 (1.98%)**  
- `primary_diagnosis_txt`: **0 / 103,000 (0.00%)**  
- `length_of_stay_days_txt`: **2,045 / 103,000 (1.99%)**
  - `length_of_stay_days_txt` non-numeric: **100,955 / 103,000 (98.01%)** → This effectively unusable as numeric in current text form

## 2) Seed mapping inputs (raw variants observed — high frequency first)

### encounter_type_txt
- outpatient (24,700 / 23.98%)
- emergency (12,956 / 12.58%)
- out patient (12,424 / 12.06%)
- out-patient (12,184 / 11.83%)
- inpatient (11,247 / 10.92%)
- emergancy (6,450 / 6.26%)
- emerg. (6,448 / 6.26%)
- in-patient (5,694 / 5.53%)
- in patient (5,621 / 5.46%)
- observation (4,013 / 3.90%)
- obs (1,263 / 1.23%)

### department_txt
- cardiology (15,257 / 15.12%)
- surgery (7,462 / 7.39%)
- paediatrics (7,511 / 7.44%)
- icu (5,079 / 5.03%)
- general medicine (4,639 / 4.60%)
- gen_med (4,571 / 4.53%)
- gen medicine (4,556 / 4.51%)
- general_medicine (4,509 / 4.47%)
- a & e (4,511 / 4.47%)
- a&e (4,427 / 4.39%)
- ae (4,426 / 4.38%)
- accident & emergency (4,418 / 4.38%)
- accident_and_emergency (4,361 / 4.32%)
- trauma & orthopaedics (3,871 / 3.83%)
- trauma_and_orthopaedics (3,804 / 3.77%)
- t&o (3,744 / 3.71%)
- trauma_&_orthopaedics (3,676 / 3.64%)
- paeds (2,638 / 2.61%)
- general_surgery (2,568 / 2.54%)
- i.c.u. (2,500 / 2.48%)
- critical_care (2,411 / 2.39%)

### severity_level_txt
- low (40,459 / 40.08%)
- high (20,121 / 19.93%)
- medium (17,698 / 17.53%)
- med (17,657 / 17.49%)
- critical (3,751 / 3.72%)
- crit (1,270 / 1.26%)

### primary_diagnosis_txt
- infection (18,663 / 18.12%)
- other (8,828 / 8.57%)
- diabetes (8,237 / 8.00%)
- copd (6,878 / 6.68%)
- chest_pain (6,688 / 6.49%)
- pneumonia (6,663 / 6.47%)
- chest pain (6,481 / 6.29%)
- other_condition (4,404 / 4.28%)
- misc (4,337 / 4.21%)
- heart_failure (4,351 / 4.22%)
- diabetees (4,094 / 3.97%)
- heart failure (4,009 / 3.89%)
- hip_fracture (3,620 / 3.51%)
- hip fracture (3,574 / 3.47%)
- c.o.p.d (3,554 / 3.45%)
- pneumonia typo: pnumonia (3,488 / 3.39%)
- stroke (3,514 / 3.41%)
- cva (1,617 / 1.57%)

## 3) Date patterns (still strings here)
- `encounter_date_txt`: **103,000 / 103,000** match `dd-mm-yyyy` (`__-__-____`)
- slash format: **0**
- wrong length: **0**
→ single consistent format observed: **dd-mm-yyyy**

## 4) Fields to ignore / override
- `is_admitted_txt` values observed:
  - false: 75,162 (72.97%)
  - true: 27,838 (27.03%)
- Action: derive `is_admitted` from `encounter_type` per brief (do not trust raw flag)

## Actions implied
- Build seed CSVs from the observed variant lists above (raw_value → canonical_value).
- Include explicit handling for missing `department_txt` and `severity_level_txt` (~2% each).
- Do not rely on `length_of_stay_days_txt` as numeric (98% non-numeric by TRY_CAST) — derive LOS later from parsed dates per rules.
- Date parsing can be built assuming **dd-mm-yyyy** for `encounter_date_txt` based on observed patterns.

{% enddocs %}
