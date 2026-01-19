-- Profiling after standardisation (staging view)
-- Source: dbt_dev_staging.stg_standard_txt

/* 1) Distinct values for mapping seeds (cnt + pct) */

SELECT
  encounter_type_txt AS raw_value,
  COUNT(*) AS cnt,
  CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS pct
FROM dbt_dev_staging.stg_standard_txt
WHERE encounter_type_txt IS NOT NULL
GROUP BY encounter_type_txt
ORDER BY raw_value;

SELECT
  department_txt AS raw_value,
  COUNT(*) AS cnt,
  CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS pct
FROM dbt_dev_staging.stg_standard_txt
WHERE department_txt IS NOT NULL
GROUP BY department_txt
ORDER BY raw_value;

SELECT
  severity_level_txt AS raw_value,
  COUNT(*) AS cnt,
  CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS pct
FROM dbt_dev_staging.stg_standard_txt
WHERE severity_level_txt IS NOT NULL
GROUP BY severity_level_txt
ORDER BY raw_value;

SELECT
  primary_diagnosis_txt AS raw_value,
  COUNT(*) AS cnt,
  CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS pct
FROM dbt_dev_staging.stg_standard_txt
WHERE primary_diagnosis_txt IS NOT NULL
GROUP BY primary_diagnosis_txt
ORDER BY raw_value;


/* 2) Date format patterns (still strings at this point) */

SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN encounter_date_txt LIKE '__-__-____' THEN 1 ELSE 0 END) AS dd_mm_yyyy_dash,
  SUM(CASE WHEN encounter_date_txt LIKE '__/__/____' THEN 1 ELSE 0 END) AS dd_mm_yyyy_slash,
  SUM(CASE WHEN encounter_date_txt IS NOT NULL AND LEN(encounter_date_txt) <> 10 THEN 1 ELSE 0 END) AS wrong_length
FROM dbt_dev_staging.stg_standard_txt
WHERE encounter_date_txt IS NOT NULL;


/* 3) Admission flag value scan (as text) */

SELECT
  is_admitted_txt AS raw_value,
  COUNT(*) AS cnt,
  CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5,2)) AS pct
FROM dbt_dev_staging.stg_standard_txt
GROUP BY is_admitted_txt
ORDER BY cnt DESC, raw_value;


/* 4) LOS text numeric check (as text) */

SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN length_of_stay_days_txt IS NULL THEN 1 ELSE 0 END) AS null_los_txt,
  SUM(CASE WHEN TRY_CAST(length_of_stay_days_txt AS int) IS NULL
            AND length_of_stay_days_txt IS NOT NULL THEN 1 ELSE 0 END) AS non_numeric_los_txt,
  MIN(TRY_CAST(length_of_stay_days_txt AS int)) AS min_los_txt,
  MAX(TRY_CAST(length_of_stay_days_txt AS int)) AS max_los_txt
FROM dbt_dev_staging.stg_standard_txt;
