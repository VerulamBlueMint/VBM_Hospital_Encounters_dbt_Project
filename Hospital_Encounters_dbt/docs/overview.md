{% docs healthcare_encounters_overview %}

# Verulam Blue — Hospital Encounters (Fabric SQL + dbt)

## What this project produces

- **silver.silver_encounters_final**: cleaned encounters at encounter grain (one row per encounter)
- **gold.gold_encounters_final**: 2025-only KPI-ready dataset with helper flags
- **gold.kpi_results**: KPI output in (kpi_name, kpi_value, kpi_key)

## Key rules implemented

- Exclude rows missing **discharge_date**
- Enforce **is_admitted** from **encounter_type**
- Canonicalise encounter_type/department/severity/diagnosis via seed mappings
- Deduplicate exact-row duplicates
- Create deterministic synthetic encounter_id when encounter_id is NULL

{% enddocs %}
