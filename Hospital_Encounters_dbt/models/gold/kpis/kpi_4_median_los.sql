
 
select
  'kpi_3' as kpi_name,
  cast(round(avg(cast(length_of_stay_days as float)), 3) as varchar(50)) as kpi_value,
  cast(null as varchar(200)) as kpi_key
from {{ ref('gold_encounters_final') }}
where is_admitted = 1 and los_eligible_flag = 1
