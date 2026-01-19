 
 
with dept_los as (
  select
    department,
    avg(cast(length_of_stay_days as float)) as avg_los_days
  from {{ ref('gold_encounters_final') }}
  where is_admitted = 1 and los_eligible_flag = 1
  group by department
)
select top 1
  'kpi_7' as kpi_name,
  cast(round(avg_los_days, 3) as varchar(50)) as kpi_value,
  cast(department as varchar(200)) as kpi_key
from dept_los
order by avg_los_days desc, department
