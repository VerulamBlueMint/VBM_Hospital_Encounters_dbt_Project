 
 
with admitted as (
  select
    encounter_id,
    patient_id,
    admission_date,
    discharge_date
  from {{ ref('gold_encounters_final') }}
  where is_admitted = 1 and readmission_eligible_flag = 1
),
sequenced as (
  select
    *,
    lag(discharge_date) over (partition by patient_id order by admission_date) as prev_discharge_date
  from admitted
),
flagged as (
  select
    encounter_id,
    case
      when prev_discharge_date is null then 0
      when datediff(day, prev_discharge_date, admission_date) between 0 and 30 then 1
      else 0
    end as is_30d_readmission
  from sequenced
)
select
  'kpi_10' as kpi_name,
  cast(round(avg(cast(is_30d_readmission as float)), 6) as varchar(50)) as kpi_value,
  cast(null as varchar(200)) as kpi_key
from flagged
