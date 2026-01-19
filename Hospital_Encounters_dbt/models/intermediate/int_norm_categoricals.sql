select
  e.*,

  et.canonical_value as encounter_type_clean,
  d.canonical_value  as department_clean,
  s.canonical_value  as severity_level_clean,
  pd.canonical_value as primary_diagnosis_clean

from {{ ref('stg_parsed_dates') }} e
left join {{ ref('map_encounter_type') }}      et on e.encounter_type_txt     = et.raw_value
left join {{ ref('map_department') }}          d  on e.department_txt         = d.raw_value
left join {{ ref('map_severity') }}            s  on e.severity_level_txt     = s.raw_value
left join {{ ref('map_primary_diagnosis') }}   pd on e.primary_diagnosis_txt  = pd.raw_value
