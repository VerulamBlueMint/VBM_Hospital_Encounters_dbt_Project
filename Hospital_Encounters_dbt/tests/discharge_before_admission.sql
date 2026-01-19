select *
from {{ ref('stg_parsed_dates') }}
where admission_date is not null
  and discharge_date is not null
  and discharge_date < admission_date
