 
select
  'kpi_1' as kpi_name,
  cast(count(*) as varchar(50)) as kpi_value,
  cast(null as varchar(200)) as kpi_key
from {{ ref('gold_encounters_final') }}
