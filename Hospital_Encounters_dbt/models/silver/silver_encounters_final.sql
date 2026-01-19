select
  cast(encounter_id_clean as varchar(200)) as encounter_id,
  cast(patient_id_txt as varchar(200))    as patient_id,

  cast(encounter_date as date)   as encounter_date,
  cast(admission_date as date)   as admission_date,
  cast(discharge_date as date)   as discharge_date,

  cast(encounter_type as varchar(50))     as encounter_type,
  cast(department as varchar(200))        as department,
  cast(primary_diagnosis as varchar(200)) as primary_diagnosis,
  cast(severity_level as varchar(50))     as severity_level,

  cast(is_admitted as int) as is_admitted,
  cast(length_of_stay_days_calc as int) as length_of_stay_days

from {{ ref('int_with_clean_id') }}
