 

with dept_counts as (
  select department, count(*) as dept_encounters
  from {{ ref('gold_encounters_final') }}
  group by department
),
tot as (
  select sum(dept_encounters) as total_encounters
  from dept_counts
),
ranked as (
  select
    d.department,
    d.dept_encounters,
    d.dept_encounters * 1.0 / nullif(t.total_encounters, 0) as dept_share,
    row_number() over (order by d.dept_encounters desc, d.department) as rn
  from dept_counts d
  cross join tot t
)
select
  'kpi_8' as kpi_name,
  cast(round(dept_share, 6) as varchar(50)) as kpi_value,
  cast(department as varchar(200)) as kpi_key
from ranked
where rn = 1
