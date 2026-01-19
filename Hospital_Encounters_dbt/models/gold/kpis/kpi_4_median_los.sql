with base as (
  select cast(length_of_stay_days as float) as los
  from {{ ref('gold_encounters_final') }}
  where is_admitted = 1 and los_eligible_flag = 1
),
med as (
  select
    percentile_cont(0.5) within group (order by los) over () as median_los
  from base
)
select top 1
  'kpi_4' as kpi_name,
  cast(round(median_los, 3) as varchar(50)) as kpi_value,
  cast(null as varchar(200)) as kpi_key
from med

