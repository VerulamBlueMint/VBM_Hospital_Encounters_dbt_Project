-- 1 Quick peek at raw data (sample rows only; not representative)

SELECT *
FROM Hospital_Encounters_Warehouse.bronze.C08_l01_healthcare_encounters_data_table
LIMIT 10;

-- 2 Row counts and distinct IDs
-- encounter_id is intended primary key but may be duplicated or null in raw extract.

SELECT
  COUNT(*) AS total_rows,
  COUNT(DISTINCT encounter_id) AS distinct_encounter_ids,
  COUNT(DISTINCT patient_id)   AS distinct_patient_ids
FROM Hospital_Encounters_Warehouse.bronze.C08_l01_healthcare_encounters_data_table;

-- 3 Null/blank baseline for key fields
-- Treat blanks as missing because some raw fields arrive as text and may contain empty strings.

SELECT
  SUM(CASE WHEN encounter_id         IS NULL OR TRIM(encounter_id)         = '' THEN 1 ELSE 0 END) AS null_encounter_id,
  SUM(CASE WHEN patient_id           IS NULL OR TRIM(patient_id)           = '' THEN 1 ELSE 0 END) AS null_patient_id,
  SUM(CASE WHEN encounter_date       IS NULL OR TRIM(encounter_date)       = '' THEN 1 ELSE 0 END) AS null_encounter_date,
  SUM(CASE WHEN encounter_type       IS NULL OR TRIM(encounter_type)       = '' THEN 1 ELSE 0 END) AS null_encounter_type,
  SUM(CASE WHEN admission_date       IS NULL OR TRIM(admission_date)       = '' THEN 1 ELSE 0 END) AS null_admission_date,
  SUM(CASE WHEN discharge_date       IS NULL OR TRIM(discharge_date)       = '' THEN 1 ELSE 0 END) AS null_discharge_date,
  SUM(CASE WHEN department           IS NULL OR TRIM(department)           = '' THEN 1 ELSE 0 END) AS null_department,
  SUM(CASE WHEN severity_level       IS NULL OR TRIM(severity_level)       = '' THEN 1 ELSE 0 END) AS null_severity_level,
  SUM(CASE WHEN primary_diagnosis    IS NULL OR TRIM(primary_diagnosis)    = '' THEN 1 ELSE 0 END) AS null_primary_diagnosis,
  SUM(CASE WHEN length_of_stay_days  IS NULL THEN 1 ELSE 0 END) AS null_length_of_stay_days,
  SUM(CASE WHEN is_admitted          IS NULL THEN 1 ELSE 0 END) AS null_is_admitted
FROM Hospital_Encounters_Warehouse.bronze.C08_l01_healthcare_encounters_data_table;


