select
  *,
  case
    when admission_date is not null and discharge_date is not null and discharge_date >= admission_date
      then datediff(day, admission_date, discharge_date)
    else null
  end as length_of_stay_days_calc,

  case
    when is_admitted = 1
     and admission_date is not null
     and discharge_date is not null
     and discharge_date >= admission_date
      then 1
    else 0
  end as los_eligible_flag,

  case
    when is_admitted = 1
     and admission_date is not null
     and discharge_date is not null
     and discharge_date >= admission_date
      then 1
    else 0
  end as readmission_eligible_flag

from {{ ref('int_core_clean') }}
