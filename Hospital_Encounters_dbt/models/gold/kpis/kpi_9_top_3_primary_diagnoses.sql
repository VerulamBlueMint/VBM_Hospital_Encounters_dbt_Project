
with diag_counts as (
  select primary_diagnosis, count(*) as encounter_count
  from {{ ref('gold_encounters_final') }}
  group by primary_diagnosis
)
select top 3
  'kpi_9' as kpi_name,
  cast(encounter_count as varchar(50)) as kpi_value,
  cast(primary_diagnosis as varchar(200)) as kpi_key
from diag_counts
order by encounter_count desc, primary_diagnosis
