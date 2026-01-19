select
  *,
  row_number() over (
    partition by patient_id_txt, encounter_date
    order by bronze_row_id
  ) as seq_for_patient_day,
  count(*) over (
    partition by patient_id_txt, encounter_date
  ) as cnt_for_patient_day
from {{ ref('int_dedup') }}
