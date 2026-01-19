select
  e.encounter_id,
  e.patient_id,
  e.encounter_date,
  e.admission_date,
  e.discharge_date,
  e.encounter_type,
  e.department,
  e.primary_diagnosis,
  e.severity_level,
  e.is_admitted,
  e.length_of_stay_days,

  case when e.is_admitted = 1 and e.admission_date is not null and e.discharge_date is not null and e.discharge_date >= e.admission_date then 1 else 0 end
    as los_eligible_flag,

  case when e.is_admitted = 1 and e.admission_date is not null and e.discharge_date is not null and e.discharge_date >= e.admission_date then 1 else 0 end
    as readmission_eligible_flag,

  case when e.severity_level in ('High','Critical') then 1 else 0 end as is_high_acuity,
  case when e.encounter_type = 'Emergency' then 1 else 0 end as is_emergency

from {{ ref('silver_encounters_final') }} e
where e.encounter_date >= cast('2025-01-01' as date)
  and e.encounter_date <  cast('2026-01-01' as date)
