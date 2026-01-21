# 00 — Production Overview (Runbook)

## Goal
Provide a replicable, end-to-end setup to run the dbt pipeline and publish:
- `silver_encounters_final`
- `gold_encounters_final`
- `kpi_results`
… and refresh the dashboard outputs.

## Inputs
- Raw encounters dataset (bronze table)
- dbt project repo (this repository)
- Seed mapping csv files (in-repo)

## Outputs
- Warehouse tables/views: `silver_encounters_final`, `gold_encounters_final`, `kpi_results`

## Commands
### Prereqs (local)
- Install Python (3.11+)
- Download and install the Microsoft ODBC Driver 18 for SQL Server.
- Install dbt + Fabric adapter

```bash
python -m pip install --upgrade pip
python -m pip install dbt-core dbt-fabric
```

### Configure credentials (Fabric dbt profile)

This project connects to a **Microsoft Fabric Warehouse** using a **dbt Fabric profile** (Service Principal auth).

> Important: `env_var()` does **not** read from a `.env` file by default.  
> If you are not exporting environment variables in your shell/OS, **replace the `env_var()` values directly** in `profiles.yml`.

#### Step 1 — Copy the template into your dbt profiles directory

1) In this repo, copy:
  `profiles_TEMPLATE.yml`

2) Rename it to:
  `profiles.yml`

3) Save it here:
- **Windows:** `C:\Users\<you>\.dbt\profiles.yml`
- **macOS/Linux:** `~/.dbt/profiles.yml`

#### Step 2 — Replace all `env_var()` placeholders with your Fabric values

Open `C:\Users\<you>\.dbt\profiles.yml` and replace every instance of:

- `{{ env_var('Fabric_Server') }}`
- `{{ env_var('Fabric_Warehouse_Name') }}`
- `{{ env_var('DBT_TARGET_SCHEMA_In_Fabric') }}`
- `{{ env_var('DBT_ENV_SECRET_Azure_Tenant_ID') }}`
- `{{ env_var('DBT_ENV_SECRET_Azure_Client_ID') }}`
- `{{ env_var('DBT_ENV_SECRET_Azure_Client_Secret') }}`

…with your actual Fabric + Entra ID (Azure AD) Service Principal credentials.

**Example (placeholders shown — replace with your real values):**

```yaml
Hospital_Encounters_dbt:
  target: dev
  outputs:
    dev:
      type: fabric
      driver: "ODBC Driver 18 for SQL Server"
      server: "<YOUR_FABRIC_SERVER>"
      port: 1433
      database: "<YOUR_FABRIC_WAREHOUSE_NAME>"
      schema: "<YOUR_TARGET_SCHEMA>"

      authentication: "ServicePrincipal"
      tenant_id: "<YOUR_TENANT_ID>"
      client_id: "<YOUR_CLIENT_ID>"
      client_secret: "<YOUR_CLIENT_SECRET>"

      encrypt: true
      trust_cert: false
```

#### Step 3 — Confirm the connection

```bash
dbt debug
```

## Run order (one command, repeatable)

```bash
dbt deps
dbt seed
dbt build
```

## Guardrails / tests
•	Source row-count checks (raw vs staged)
•	Date parsing validity checks
•	Deduplication integrity checks
•	Not-null / accepted-values tests on key dimensions
•	KPI output shape checks (kpi_results schema + expected KPI set)

## Notes
- The rest of the runbook is split into small, inspectable steps:
  - 01_raw_profile → 13_ kpis_and_kpi_results
- Each step documents: goal, inputs/outputs, exact commands, and the guardrails that prevent silent bad data.




