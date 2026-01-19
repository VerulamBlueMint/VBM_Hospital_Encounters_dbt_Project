select
  bronze_row_id,

  nullif(lower(ltrim(rtrim(cast(encounter_id as varchar(200))))), '') as encounter_id_txt,
  nullif(lower(ltrim(rtrim(cast(patient_id as varchar(200))))), '')   as patient_id_txt,

  nullif(ltrim(rtrim(cast(encounter_date as varchar(50)))), '')  as encounter_date_txt,
  nullif(ltrim(rtrim(cast(admission_date as varchar(50)))), '')  as admission_date_txt,
  nullif(ltrim(rtrim(cast(discharge_date as varchar(50)))), '')  as discharge_date_txt,

  nullif(lower(ltrim(rtrim(cast(encounter_type as varchar(100))))), '')     as encounter_type_txt,
  nullif(lower(ltrim(rtrim(cast(department as varchar(200))))), '')         as department_txt,
  nullif(lower(ltrim(rtrim(cast(primary_diagnosis as varchar(200))))), '')  as primary_diagnosis_txt,
  nullif(lower(ltrim(rtrim(cast(severity_level as varchar(100))))), '')     as severity_level_txt,

  nullif(lower(ltrim(rtrim(cast(is_admitted as varchar(20))))), '')         as is_admitted_txt,
  nullif(ltrim(rtrim(cast(length_of_stay_days as varchar(20)))), '')        as length_of_stay_days_txt

from {{ ref('stg_bronze_rowid') }}
