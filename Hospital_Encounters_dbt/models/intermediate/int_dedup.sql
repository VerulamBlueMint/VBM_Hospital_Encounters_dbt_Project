with ranked as (
  select
    *,
    row_number() over (
      partition by
        encounter_id_txt,
        patient_id_txt,
        encounter_date,
        admission_date,
        discharge_date,
        encounter_type,
        department,
        primary_diagnosis,
        severity_level,
        is_admitted,
        length_of_stay_days_calc
      order by bronze_row_id
    ) as rn
  from {{ ref('int_los_flags') }}
)
select *
from ranked
where rn = 1
