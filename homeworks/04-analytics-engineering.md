# Module 4 Homework

[https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/04-analytics-engineering/homework.md](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/04-analytics-engineering/homework.md)

## Solution #1:

- Understanding the source() Function
   
  The source('raw_nyc_tripdata', 'ext_green_taxi') call references the sources.yaml file:
  ```
  sources:
    - name: raw_nyc_tripdata
      database: "{{ env_var('DBT_BIGQUERY_PROJECT', 'dtc_zoomcamp_2025') }}"
      schema:   "{{ env_var('DBT_BIGQUERY_SOURCE_DATASET', 'raw_nyc_tripdata') }}"
      tables:
        - name: ext_green_taxi
  ```
     
- Resolving Environment Variables

  The following environment variables are set in the dbt runtime environment:
  
   ```
   export DBT_BIGQUERY_PROJECT=myproject
   export DBT_BIGQUERY_DATASET=my_nyc_tripdata
   ```
   - env_var('DBT_BIGQUERY_PROJECT', 'dtc_zoomcamp_2025') → myproject
   - env_var('DBT_BIGQUERY_SOURCE_DATASET', 'raw_nyc_tripdata') → raw_nyc_tripdata

- Final Compilation

  When dbt compiles {{ source('raw_nyc_tripdata', 'ext_green_taxi') }}, it expands to:  

  ```
  myproject.raw_nyc_tripdata.ext_green_taxi
  ```
  
- Correct Answer  

   ```
   ✅ select * from myproject.raw_nyc_tripdata.ext_green_taxi
   ```
-------------------------------------------------------------------------------------


## Solution #2:

To ensure that command-line arguments take precedence over environment variables, which take precedence over the default value, let's analyze each option carefully.

- Understanding var() and env_var() in dbt
   
      ```
      var("days_back", 30):
      Uses the variable days_back, defaulting to 30 if not provided.
      Command-line arguments (--vars) override this.
      env_var("DAYS_BACK", "30"):
      Reads the environment variable DAYS_BACK, defaulting to "30" if not found.
      Environment variables override the default but are overridden by command-line arguments.
      Priority order in dbt:
      Command-line argument: dbt run --vars '{"days_back": 7}'
      Environment variable: export DAYS_BACK=7
      Default value: 30
      ```

- Evaluating the options
      ```
      ❌ Incorrect:
      Add ORDER BY pickup_datetime DESC and LIMIT {{ var("days_back", 30) }}
      
      This does not modify the filtering logic based on the date range.
      Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ env_var("DAYS_BACK", "30") }}' DAY
      
      This prioritizes the environment variable but does not check for a command-line argument.
      ✅ Correct:
      Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY
      This ensures the following precedence:
      Command-line argument (var("days_back"))
      Environment variable (env_var("DAYS_BACK"))
      Default value (30)
      ```
      
- Final Answer:
   ```
   ✅ Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY
   ```
-------------------------------------------------------------------------------------


## Solution #3:

To determine which option does NOT apply for materializing fct_taxi_monthly_zone_revenue, let's break this down step by step.

- Understanding dbt Materialization and Data Lineage
   ```
   taxi_zone_lookup is a seed file (from .csv), meaning it's materialized with dbt seed.
   fct_taxi_monthly_zone_revenue depends on upstream models.
   For fct_taxi_monthly_zone_revenue to materialize, all its dependencies must also be built.
   ```
- Evaluating the dbt Commands
   ```
   ✅ Valid Commands (these will materialize fct_taxi_monthly_zone_revenue):

   dbt run  
   Runs all models, including fct_taxi_monthly_zone_revenue.
   ✅ Valid.

   dbt run --select +models/core/dim_taxi_trips.sql+ --target prod
   + means it selects dim_taxi_trips.sql and all its parents and children.
   If dim_taxi_trips is an upstream dependency of fct_taxi_monthly_zone_revenue, this will work.
   ✅ Valid.

   dbt run --select +models/core/fct_taxi_monthly_zone_revenue.sql
   + means it selects fct_taxi_monthly_zone_revenue.sql and all upstream dependencies.
   ✅ Valid.

   dbt run --select +models/core/
   Runs all models in core/ and their dependencies.
   ✅ Valid.

   ❌ Invalid Command (this will NOT materialize fct_taxi_monthly_zone_revenue):
   
      dbt run --select models/staging/+
      models/staging/+ selects all staging models and their children.
      If fct_taxi_monthly_zone_revenue is in core/, this does NOT select it!
      ❌ This does NOT apply for materializing fct_taxi_monthly_zone_revenue.

- Final Answer:
❌ dbt run --select models/staging/+ does NOT apply.

-------------------------------------------------------------------------------------


## Solution #4:

Analyzing the Macro Behavior
The macro resolve_schema_for(model_type) dynamically determines the schema (dataset) based on the model type.

Breaking Down the Macro Logic

{% macro resolve_schema_for(model_type) -%}

    {%- set target_env_var = 'DBT_BIGQUERY_TARGET_DATASET'  -%}
    {%- set stging_env_var = 'DBT_BIGQUERY_STAGING_DATASET' -%}

    {%- if model_type == 'core' -%} 
        {{- env_var(target_env_var) -}}  
    {%- else -%}                    
        {{- env_var(stging_env_var, env_var(target_env_var)) -}}  
    {%- endif -%}

{%- endmacro %}

- If model_type == 'core', it will use DBT_BIGQUERY_TARGET_DATASET.
- If model_type is anything else, it will use DBT_BIGQUERY_STAGING_DATASET, but if it's not set, it will fall back to DBT_BIGQUERY_TARGET_DATASET.


Evaluating the Statements
Setting a value for DBT_BIGQUERY_TARGET_DATASET env var is mandatory, or it'll fail to compile

✅ True
Since env_var(target_env_var) is used without a default, it must be set, or dbt will fail.
Setting a value for DBT_BIGQUERY_STAGING_DATASET env var is mandatory, or it'll fail to compile

❌ False
If DBT_BIGQUERY_STAGING_DATASET is not set, the macro falls back to DBT_BIGQUERY_TARGET_DATASET, so it won't fail.
When using core, it materializes in the dataset defined in DBT_BIGQUERY_TARGET_DATASET

✅ True
The macro explicitly selects DBT_BIGQUERY_TARGET_DATASET when model_type == 'core'.
When using stg, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET

✅ True
For any model_type other than 'core', it first checks DBT_BIGQUERY_STAGING_DATASET and falls back to DBT_BIGQUERY_TARGET_DATASET.
When using staging, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET

✅ True
staging is not core, so it behaves the same as stg, meaning it uses DBT_BIGQUERY_STAGING_DATASET or falls back.


Final Answer:
✅ The correct statements are:

- Setting a value for DBT_BIGQUERY_TARGET_DATASET env var is mandatory, or it'll fail to compile
- When using core, it materializes in the dataset defined in DBT_BIGQUERY_TARGET_DATASET
- When using stg, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET
- When using staging, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET

-------------------------------------------------------------------------------------


## Solution #5:
```
$ dbt run --select fct_taxi_trips_quarterly_revenue
10:15:17  Running with dbt=1.9.2
10:15:20  Registered adapter: bigquery=1.9.1
10:15:22  Found 10 models, 1 seed, 11 data tests, 3 sources, 628 macros
10:15:22  
10:15:22  Concurrency: 1 threads (target='dev')
10:15:22  
10:15:23  1 of 1 START sql table model zoomcamp.fct_taxi_trips_quarterly_revenue ......... [RUN]
10:15:28  1 of 1 OK created sql table model zoomcamp.fct_taxi_trips_quarterly_revenue .... [CREATE TABLE (42.0 rows, 1.8 GiB processed) in 4.44s]
10:15:28  
10:15:28  Finished running 1 table model in 0 hours 0 minutes and 5.65 seconds (5.65s).
10:15:28  
10:15:28  Completed successfully
10:15:28  
10:15:28  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```

```
WITH quarterly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(QUARTER FROM pickup_datetime) AS quarter,
        service_type,
        SUM(total_amount) AS revenue
    FROM `de-zoomcamp-2025--id.zoomcamp.fact_trips`
    GROUP BY 1, 2, 3
),

yoy_growth AS (
    SELECT
        year,
        quarter,
        service_type,
        revenue,
        LAG(revenue) OVER (PARTITION BY service_type, quarter ORDER BY year) AS prev_year_revenue,
        ROUND(
            (revenue - LAG(revenue) OVER (PARTITION BY service_type, quarter ORDER BY year)) / 
            NULLIF(LAG(revenue) OVER (PARTITION BY service_type, quarter ORDER BY year), 0) * 100, 
            2
        ) AS yoy_growth
    FROM quarterly_revenue
)

SELECT *
FROM yoy_growth
WHERE year = 2020
ORDER BY service_type, yoy_growth;
```

<img width="734" alt="image" src="https://github.com/user-attachments/assets/bab532f8-e182-46d2-81a5-6deb8cb9aaf8" />

-------------------------------------------------------------------------------------


## Solution #6:
```
$  dbt run --select fct_taxi_trips_monthly_fare_p95
10:25:36  Running with dbt=1.9.2
10:25:39  Registered adapter: bigquery=1.9.1
10:25:41  Found 10 models, 1 seed, 11 data tests, 3 sources, 628 macros
10:25:41  
10:25:41  Concurrency: 1 threads (target='dev')
10:25:41  
10:25:42  1 of 1 START sql table model zoomcamp.fct_taxi_trips_monthly_fare_p95 .......... [RUN]
10:25:46  1 of 1 OK created sql table model zoomcamp.fct_taxi_trips_monthly_fare_p95 ..... [CREATE TABLE (2.0 rows, 3.4 GiB processed) in 3.48s]
10:25:46  
10:25:46  Finished running 1 table model in 0 hours 0 minutes and 4.81 seconds (4.81s).
10:25:46  
10:25:46  Completed successfully
10:25:46  
10:25:46  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```

```
$ dbt show --select fct_taxi_trips_monthly_fare_p95
10:27:51  Running with dbt=1.9.2
10:27:54  Registered adapter: bigquery=1.9.1
10:27:56  Found 10 models, 1 seed, 11 data tests, 3 sources, 628 macros
10:27:56  
10:27:56  Concurrency: 1 threads (target='dev')
10:27:56  
Previewing node 'fct_taxi_trips_monthly_fare_p95':
| service_type | year | month | p97 |  p95 |  p90 |
| ------------ | ---- | ----- | --- | ---- | ---- |
| Green        | 2020 |     4 |  28 | 23,0 | 18,0 |
| Yellow       | 2020 |     4 |  32 | 26,5 | 19,5 |

```
-------------------------------------------------------------------------------------


## Solution #7:

```
Step 1: Create a Staging Model (stg_fhv_trips.sql)
Filter out records where dispatching_base_num is NULL:

SELECT *
FROM {{ source('staging','fhv_tripdata') }}
WHERE dispatching_base_num IS NOT NULL


Step 2: Create the Core Model (dim_fhv_trips.sql)
Join with dim_zones and add year/month columns:

SELECT 
    f.*,
    z_pickup.zone AS pickup_zone,
    z_dropoff.zone AS dropoff_zone,
    EXTRACT(YEAR FROM f.pickup_datetime) AS year,
    EXTRACT(MONTH FROM f.pickup_datetime) AS month
FROM {{ ref('stg_fhv_trips') }} f
LEFT JOIN {{ ref('dim_zones') }} z_pickup 
    ON f.PULocationID = z_pickup.locationid
LEFT JOIN {{ ref('dim_zones') }} z_dropoff 
    ON f.DOLocationID = z_dropoff.locationid


Step 3: Create the Fact Model (fct_fhv_monthly_zone_traveltime_p90.sql)
Compute trip_duration and P90 trip_duration

WITH trip_durations AS (
    SELECT
        year,
        month,
        PULocationID,
        DOLocationID,
        pickup_zone,
        dropoff_zone,
        TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) AS trip_duration
    FROM {{ ref('dim_fhv_trips') }}
),
p90_durations AS (
    SELECT
        year,
        month,
        PULocationID,
        DOLocationID,
        pickup_zone,
        dropoff_zone,
        APPROX_QUANTILES(trip_duration, 100)[OFFSET(90)] AS p90_trip_duration
    FROM trip_durations
    GROUP BY 1, 2, 3, 4, 5, 6
)
SELECT * FROM p90_durations


Step 4: Query for the Required Answer
Find the 2nd longest P90 travel time drop-off zones for trips starting from Newark Airport, SoHo, and Yorkville East in November 2019:

WITH ranked_trips AS (
    SELECT 
        pickup_zone, 
        dropoff_zone, 
        p90_trip_duration,
        RANK() OVER (PARTITION BY pickup_zone ORDER BY p90_trip_duration DESC) AS trip_rank
    FROM `de-zoomcamp-2025--id.zoomcamp.fct_fhv_monthly_zone_traveltime_p90`
    WHERE 
        year = 2019 
        AND month = 11
        AND pickup_zone IN ('Newark Airport', 'SoHo', 'Yorkville East')
)
SELECT pickup_zone, dropoff_zone
FROM ranked_trips
WHERE trip_rank = 2;

pickup_zone         dropoff_zone
-----------         ------------
Yorkville East      Garment District
Newark Airport      NV
SoHo                Greenwich Village South
```

<img width="386" alt="image" src="https://github.com/user-attachments/assets/96767a81-a95d-454f-8757-a0e18397e472" />

-------------------------------------------------------------------------------------

<img width="1128" alt="image" src="https://github.com/user-attachments/assets/e8a20514-f208-4a9d-8a6c-076ce27843ec" />


