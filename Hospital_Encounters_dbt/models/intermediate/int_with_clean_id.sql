select
  *,
  case
    when encounter_id_txt is not null then encounter_id_txt
    else
      concat(
        patient_id_txt,
        convert(char(8), encounter_date, 112),               -- YYYYMMDD
        case
          when cnt_for_patient_day = 1 then ''
          else right('00' + cast(seq_for_patient_day as varchar(2)), 2)
        end
      )
  end as encounter_id_clean,

  case when encounter_id_txt is null then 1 else 0 end as encounter_id_was_synthetic_flag
from {{ ref('int_id_seq') }}
