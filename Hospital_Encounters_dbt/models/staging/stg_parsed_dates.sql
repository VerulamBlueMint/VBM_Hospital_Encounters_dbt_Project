with base as (
  select
    *,
    try_convert(date, replace(encounter_date_txt,  '/', '-'), 105)  as encounter_date,
    try_convert(date, replace(admission_date_txt,  '/', '-'), 105)  as admission_date,
    try_convert(date, replace(discharge_date_txt,  '/', '-'), 105)  as discharge_date
  from {{ ref('stg_standard_txt') }}
),
filtered as (
  select *
  from base
  where discharge_date is not null
    and (
      admission_date is null
      or discharge_date >= admission_date
    )
)
select * from filtered
