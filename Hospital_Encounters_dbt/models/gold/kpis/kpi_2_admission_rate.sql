
 
select
  'kpi_2' as kpi_name,
  cast(
    round(
      sum(case when is_admitted = 1 then 1 else 0 end) * 1.0 / nullif(count(*), 0),
      6
    ) as varchar(50)
  ) as kpi_value,
  cast(null as varchar(200)) as kpi_key
from {{ ref('gold_encounters_final') }}
