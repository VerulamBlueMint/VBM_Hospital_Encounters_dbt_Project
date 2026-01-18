select
  row_number() over (
    order by
      cast(patient_id as varchar(200)),
      cast(encounter_date as varchar(50)),
      cast(admission_date as varchar(50)),
      cast(discharge_date as varchar(50))
  ) as bronze_row_id,
  *
from {{ source('bronze', 'encounters_raw') }}
