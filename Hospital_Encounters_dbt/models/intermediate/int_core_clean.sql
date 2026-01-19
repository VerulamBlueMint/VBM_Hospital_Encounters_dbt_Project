select
  bronze_row_id,

  encounter_id_txt,
  patient_id_txt,

  encounter_date,
  admission_date,
  discharge_date,

  coalesce(encounter_type_clean,     'Unknown_Encounter')  as encounter_type,
  coalesce(department_clean,         'Unknown_Department') as department,
  coalesce(primary_diagnosis_clean,  'Unknown_Diagnosis')  as primary_diagnosis,
  coalesce(severity_level_clean,     'Unknown_Severity')   as severity_level,

  case when coalesce(encounter_type_clean, 'Unknown_Encounter') in ('Inpatient', 'Observation') then 1 else 0 end
    as is_admitted,

  try_cast(length_of_stay_days_txt as int) as length_of_stay_days_raw

from {{ ref('int_norm_categoricals') }}
