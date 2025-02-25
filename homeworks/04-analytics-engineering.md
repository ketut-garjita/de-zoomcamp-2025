## SOLUTION #1:

1. Understanding the source() Function
   
  The source('raw_nyc_tripdata', 'ext_green_taxi') call references the sources.yaml file:
  
  sources:
    - name: raw_nyc_tripdata
      database: "{{ env_var('DBT_BIGQUERY_PROJECT', 'dtc_zoomcamp_2025') }}"
      schema:   "{{ env_var('DBT_BIGQUERY_SOURCE_DATASET', 'raw_nyc_tripdata') }}"
      tables:
        - name: ext_green_taxi

2. Resolving Environment Variables
The following environment variables are set in the dbt runtime environment:

export DBT_BIGQUERY_PROJECT=myproject
export DBT_BIGQUERY_DATASET=my_nyc_tripdata

- env_var('DBT_BIGQUERY_PROJECT', 'dtc_zoomcamp_2025') → myproject
- env_var('DBT_BIGQUERY_SOURCE_DATASET', 'raw_nyc_tripdata') → raw_nyc_tripdata

3. Final Compilation
When dbt compiles {{ source('raw_nyc_tripdata', 'ext_green_taxi') }}, it expands to:

myproject.raw_nyc_tripdata.ext_green_taxi

4. Correct Answer
✅ select * from myproject.raw_nyc_tripdata.ext_green_taxi

-------------------------------------------------------------------------------------

SOLUTION #2:

To ensure that command-line arguments take precedence over environment variables, which take precedence over the default value, let's analyze each option carefully.

1. Understanding var() and env_var() in dbt
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

2. Evaluating the options
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

3. Final Answer:
✅ Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY

-------------------------------------------------------------------------------------

SOLUTION #3:

To determine which option does NOT apply for materializing fct_taxi_monthly_zone_revenue, let's break this down step by step.

1. Understanding dbt Materialization and Data Lineage
taxi_zone_lookup is a seed file (from .csv), meaning it's materialized with dbt seed.
fct_taxi_monthly_zone_revenue depends on upstream models.
For fct_taxi_monthly_zone_revenue to materialize, all its dependencies must also be built.

2. Evaluating the dbt Commands
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

3. Final Answer:
❌ dbt run --select models/staging/+ does NOT apply.

-------------------------------------------------------------------------------------

SOLUTION #4;

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

Setting a value for DBT_BIGQUERY_TARGET_DATASET env var is mandatory, or it'll fail to compile
When using core, it materializes in the dataset defined in DBT_BIGQUERY_TARGET_DATASET
When using stg, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET
When using staging, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET

-------------------------------------------------------------------------------------

SOLUTION #5:

(dbt_env) dataeng@dataeng-virtual-machine:~/projects/dbt/docker_setup/mydbt/models/core$ dbt run --select fct_taxi_trips_quarterly_revenue.sql --debug
13:24:40  Sending event: {'category': 'dbt', 'action': 'invocation', 'label': 'start', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x7a0591414a70>, <snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x7a059168ba70>, <snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x7a0591291700>]}
13:24:40  Running with dbt=1.9.2
13:24:40  running dbt with arguments {'printer_width': '80', 'indirect_selection': 'eager', 'log_cache_events': 'False', 'write_json': 'True', 'partial_parse': 'True', 'cache_selected_only': 'False', 'warn_error': 'None', 'fail_fast': 'False', 'debug': 'True', 'log_path': '/home/dataeng/projects/dbt/docker_setup/mydbt/logs', 'profiles_dir': '/home/dataeng/.dbt', 'version_check': 'True', 'use_colors': 'True', 'use_experimental_parser': 'False', 'no_print': 'None', 'quiet': 'False', 'empty': 'False', 'warn_error_options': 'WarnErrorOptions(include=[], exclude=[])', 'introspect': 'True', 'invocation_command': 'dbt run --select fct_taxi_trips_quarterly_revenue.sql --debug', 'static_parser': 'True', 'target_path': 'None', 'log_format': 'default', 'send_anonymous_usage_stats': 'True'}
13:24:42  Sending event: {'category': 'dbt', 'action': 'project_id', 'label': 'eac705d9-fcba-4c16-87e3-81c7284bbf1c', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x7a05912d5850>]}
13:24:43  Sending event: {'category': 'dbt', 'action': 'adapter_info', 'label': 'eac705d9-fcba-4c16-87e3-81c7284bbf1c', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x7a0591bda780>]}
13:24:43  Registered adapter: bigquery=1.9.1
13:24:43  checksum: 12b12750b70de726cfd89136b8e24afc3f3e77597a97bff40ab7e5f9b39d5e18, vars: {}, profile: , target: , version: 1.9.2
13:24:44  Partial parsing enabled: 0 files deleted, 0 files added, 1 files changed.
13:24:44  Partial parsing: updated file: mydbt://models/core/fct_taxi_trips_quarterly_revenue.sql
13:24:45  Sending event: {'category': 'dbt', 'action': 'load_project', 'label': 'eac705d9-fcba-4c16-87e3-81c7284bbf1c', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x7a0570cdb080>]}
13:24:45  Wrote artifact WritableManifest to /home/dataeng/projects/dbt/docker_setup/mydbt/target/manifest.json
13:24:45  Wrote artifact SemanticManifest to /home/dataeng/projects/dbt/docker_setup/mydbt/target/semantic_manifest.json
13:24:45  Sending event: {'category': 'dbt', 'action': 'resource_counts', 'label': 'eac705d9-fcba-4c16-87e3-81c7284bbf1c', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x7a0570c7d430>]}
13:24:45  Found 7 models, 1 analysis, 1 seed, 11 data tests, 2 sources, 628 macros
13:24:45  Sending event: {'category': 'dbt', 'action': 'runnable_timing', 'label': 'eac705d9-fcba-4c16-87e3-81c7284bbf1c', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x7a0570cdd7f0>]}
13:24:45  
13:24:45  Concurrency: 1 threads (target='dev')
13:24:45  
13:24:45  Acquiring new bigquery connection 'master'
13:24:45  Acquiring new bigquery connection 'list_de-zoomcamp-2025--id'
13:24:45  Opening a new connection, currently in state init
13:24:46  Re-using an available connection from the pool (formerly list_de-zoomcamp-2025--id, now list_de-zoomcamp-2025--id_zoomcamp)
13:24:46  Opening a new connection, currently in state closed
13:24:46  Sending event: {'category': 'dbt', 'action': 'runnable_timing', 'label': 'eac705d9-fcba-4c16-87e3-81c7284bbf1c', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x7a0570ec0e00>]}
13:24:46  Opening a new connection, currently in state init
13:24:46  Began running node model.mydbt.fct_taxi_trips_quarterly_revenue
13:24:46  1 of 1 START sql table model zoomcamp.fct_taxi_trips_quarterly_revenue ......... [RUN]
13:24:46  Re-using an available connection from the pool (formerly list_de-zoomcamp-2025--id_zoomcamp, now model.mydbt.fct_taxi_trips_quarterly_revenue)
13:24:46  Began compiling node model.mydbt.fct_taxi_trips_quarterly_revenue
13:24:46  Writing injected SQL for node "model.mydbt.fct_taxi_trips_quarterly_revenue"
13:24:46  Began executing node model.mydbt.fct_taxi_trips_quarterly_revenue
13:24:47  Writing runtime sql for node "model.mydbt.fct_taxi_trips_quarterly_revenue"
13:24:47  On model.mydbt.fct_taxi_trips_quarterly_revenue: /* {"app": "dbt", "dbt_version": "1.9.2", "profile_name": "mydbt", "target_name": "dev", "node_id": "model.mydbt.fct_taxi_trips_quarterly_revenue"} */

  
    

    create or replace table `de-zoomcamp-2025--id`.`zoomcamp`.`fct_taxi_trips_quarterly_revenue`
      
    
    

    OPTIONS()
    as (
      WITH quarterly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(QUARTER FROM pickup_datetime) AS quarter,
        trip_type,
        SUM(total_amount) AS revenue
    FROM `de-zoomcamp-2025--id`.`zoomcamp`.`fact_trips`
    GROUP BY 1, 2, 3
),

yoy_growth AS (
    SELECT
        year,
        quarter,
        trip_type,
        revenue,
        LAG(revenue) OVER (PARTITION BY trip_type, quarter ORDER BY year) AS prev_year_revenue,
        ROUND(
            (revenue - LAG(revenue) OVER (PARTITION BY trip_type, quarter ORDER BY year)) / 
            NULLIF(LAG(revenue) OVER (PARTITION BY trip_type, quarter ORDER BY year), 0) * 100, 
            2
        ) AS yoy_growth
    FROM quarterly_revenue
)

SELECT * FROM yoy_growth
ORDER BY trip_type, year, quarter
    );
  
13:24:47  Opening a new connection, currently in state closed
13:24:47  BigQuery adapter: https://console.cloud.google.com/bigquery?project=de-zoomcamp-2025--id&j=bq:asia-southeast2:48ac96e1-7cd3-45a6-a921-7d1caba83846&page=queryresults
13:24:50  Sending event: {'category': 'dbt', 'action': 'run_model', 'label': 'eac705d9-fcba-4c16-87e3-81c7284bbf1c', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x7a0571383770>]}
13:24:50  1 of 1 OK created sql table model zoomcamp.fct_taxi_trips_quarterly_revenue .... [CREATE TABLE (42.0 rows, 1.8 GiB processed) in 3.77s]
13:24:50  Finished running node model.mydbt.fct_taxi_trips_quarterly_revenue
13:24:50  Opening a new connection, currently in state closed
13:24:50  Connection 'master' was properly closed.
13:24:50  Connection 'model.mydbt.fct_taxi_trips_quarterly_revenue' was properly closed.
13:24:50  
13:24:50  Finished running 1 table model in 0 hours 0 minutes and 5.20 seconds (5.20s).
13:24:50  Command end result
13:24:51  Wrote artifact WritableManifest to /home/dataeng/projects/dbt/docker_setup/mydbt/target/manifest.json
13:24:51  Wrote artifact SemanticManifest to /home/dataeng/projects/dbt/docker_setup/mydbt/target/semantic_manifest.json
13:24:51  Wrote artifact RunExecutionResult to /home/dataeng/projects/dbt/docker_setup/mydbt/target/run_results.json
13:24:51  
13:24:51  Completed successfully
13:24:51  
13:24:51  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
13:24:51  Resource report: {"command_name": "run", "command_success": true, "command_wall_clock_time": 11.62751, "process_in_blocks": "0", "process_kernel_time": 1.7015, "process_mem_max_rss": "221992", "process_out_blocks": "4488", "process_user_time": 10.968739}
13:24:51  Command `dbt run` succeeded at 20:24:51.548185 after 11.65 seconds
13:24:51  Sending event: {'category': 'dbt', 'action': 'invocation', 'label': 'end', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x7a05915775c0>, <snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x7a0591414a70>, <snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x7a0570ea3a10>]}
13:24:51  Flushing usage events
13:24:53  An error was encountered while trying to flush usage events


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
ORDER BY service_type, yoy_growth
--LIMIT 1;

year,quarter,service_type,revenue,prev_year_revenue,yoy_growth
2020,2,Green,1547951.73,21570101.65,-92.82
2020,3,Green,2369654.66,17706590.51,-86.62
2020,4,Green,2449647.14,15729304.84,-84.43
2020,1,Green,11526159.82,26438283.59,-56.4
2020,2,Yellow,15671636.52,210218214.62,-92.55
2020,3,Yellow,41845183.18,196150379.36,-78.67
2020,4,Yellow,56866458.78,199618124.62,-71.51
2020,1,Yellow,150767293.31,188266358.05,-19.92

-------------------------------------------------------------------------------------

SOLUTION #6:

~/projects/dbt/docker_setup/mydbt/models/core$ dbt run --select fct_taxi_trips_monthly_fare_p95 --debug
13:01:54  Sending event: {'category': 'dbt', 'action': 'invocation', 'label': 'start', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x700b65c26810>, <snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x700b676f5a60>, <snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x700b662e98b0>]}
13:01:54  Running with dbt=1.9.2
13:01:54  running dbt with arguments {'printer_width': '80', 'indirect_selection': 'eager', 'log_cache_events': 'False', 'write_json': 'True', 'partial_parse': 'True', 'cache_selected_only': 'False', 'profiles_dir': '/home/dataeng/.dbt', 'version_check': 'True', 'fail_fast': 'False', 'log_path': '/home/dataeng/projects/dbt/docker_setup/mydbt/logs', 'warn_error': 'None', 'debug': 'True', 'use_colors': 'True', 'use_experimental_parser': 'False', 'empty': 'False', 'quiet': 'False', 'no_print': 'None', 'log_format': 'default', 'static_parser': 'True', 'invocation_command': 'dbt run --select fct_taxi_trips_monthly_fare_p95 --debug', 'introspect': 'True', 'target_path': 'None', 'warn_error_options': 'WarnErrorOptions(include=[], exclude=[])', 'send_anonymous_usage_stats': 'True'}
13:02:00  Sending event: {'category': 'dbt', 'action': 'project_id', 'label': '82f448ab-d559-491d-919c-098b921ff3a3', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x700b45a85d90>]}
13:02:01  Sending event: {'category': 'dbt', 'action': 'adapter_info', 'label': '82f448ab-d559-491d-919c-098b921ff3a3', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x700b45b1e6c0>]}
13:02:01  Registered adapter: bigquery=1.9.1
13:02:03  checksum: 12b12750b70de726cfd89136b8e24afc3f3e77597a97bff40ab7e5f9b39d5e18, vars: {}, profile: , target: , version: 1.9.2
13:02:03  Partial parsing enabled: 0 files deleted, 0 files added, 1 files changed.
13:02:03  Partial parsing: updated file: mydbt://models/core/fct_taxi_trips_monthly_fare_p95.sql
13:02:05  Sending event: {'category': 'dbt', 'action': 'load_project', 'label': '82f448ab-d559-491d-919c-098b921ff3a3', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x700b452e7230>]}
13:02:05  Wrote artifact WritableManifest to /home/dataeng/projects/dbt/docker_setup/mydbt/target/manifest.json
13:02:05  Wrote artifact SemanticManifest to /home/dataeng/projects/dbt/docker_setup/mydbt/target/semantic_manifest.json
13:02:05  Sending event: {'category': 'dbt', 'action': 'resource_counts', 'label': '82f448ab-d559-491d-919c-098b921ff3a3', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x700b4529d700>]}
13:02:05  Found 6 models, 1 analysis, 1 seed, 11 data tests, 2 sources, 628 macros
13:02:05  Sending event: {'category': 'dbt', 'action': 'runnable_timing', 'label': '82f448ab-d559-491d-919c-098b921ff3a3', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x700b458f9ac0>]}
13:02:05  
13:02:05  Concurrency: 1 threads (target='dev')
13:02:05  
13:02:05  Acquiring new bigquery connection 'master'
13:02:05  Acquiring new bigquery connection 'list_de-zoomcamp-2025--id'
13:02:05  Opening a new connection, currently in state init
13:02:06  Re-using an available connection from the pool (formerly list_de-zoomcamp-2025--id, now list_de-zoomcamp-2025--id_zoomcamp)
13:02:06  Opening a new connection, currently in state closed
13:02:06  Sending event: {'category': 'dbt', 'action': 'runnable_timing', 'label': '82f448ab-d559-491d-919c-098b921ff3a3', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x700b454b3d70>]}
13:02:06  Opening a new connection, currently in state init
13:02:06  Began running node model.mydbt.fct_taxi_trips_monthly_fare_p95
13:02:06  1 of 1 START sql table model zoomcamp.fct_taxi_trips_monthly_fare_p95 .......... [RUN]
13:02:06  Re-using an available connection from the pool (formerly list_de-zoomcamp-2025--id_zoomcamp, now model.mydbt.fct_taxi_trips_monthly_fare_p95)
13:02:06  Began compiling node model.mydbt.fct_taxi_trips_monthly_fare_p95
13:02:06  Writing injected SQL for node "model.mydbt.fct_taxi_trips_monthly_fare_p95"
13:02:06  Began executing node model.mydbt.fct_taxi_trips_monthly_fare_p95
13:02:07  Writing runtime sql for node "model.mydbt.fct_taxi_trips_monthly_fare_p95"
13:02:07  On model.mydbt.fct_taxi_trips_monthly_fare_p95: /* {"app": "dbt", "dbt_version": "1.9.2", "profile_name": "mydbt", "target_name": "dev", "node_id": "model.mydbt.fct_taxi_trips_monthly_fare_p95"} */

  
    

    create or replace table `de-zoomcamp-2025--id`.`zoomcamp`.`fct_taxi_trips_monthly_fare_p95`
      
    
    

    OPTIONS()
    as (
      WITH valid_trips AS (
    SELECT
        service_type,
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(MONTH FROM pickup_datetime) AS month,
        fare_amount
    FROM  `de-zoomcamp-2025--id`.`zoomcamp`.`fact_trips` 
    WHERE 
        fare_amount > 0 
        AND trip_distance > 0 
        AND payment_type_description IN ('Cash', 'Credit Card')
),

percentile_fares AS (
    SELECT
        service_type,
        year,
        month,
        APPROX_QUANTILES(fare_amount, 100)[SAFE_ORDINAL(97)] AS p97,
        APPROX_QUANTILES(fare_amount, 100)[SAFE_ORDINAL(95)] AS p95,
        APPROX_QUANTILES(fare_amount, 100)[SAFE_ORDINAL(90)] AS p90
    FROM valid_trips
    GROUP BY service_type, year, month
)

SELECT * FROM percentile_fares
WHERE year = 2020 AND month = 4
ORDER BY service_type
    );
  
13:02:07  Opening a new connection, currently in state closed
13:02:07  BigQuery adapter: https://console.cloud.google.com/bigquery?project=de-zoomcamp-2025--id&j=bq:asia-southeast2:cc07ea48-09b0-4f50-8308-f8898bae1f5a&page=queryresults
13:02:11  Sending event: {'category': 'dbt', 'action': 'run_model', 'label': '82f448ab-d559-491d-919c-098b921ff3a3', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x700b459d41d0>]}
13:02:11  1 of 1 OK created sql table model zoomcamp.fct_taxi_trips_monthly_fare_p95 ..... [CREATE TABLE (2.0 rows, 3.4 GiB processed) in 4.53s]
13:02:11  Finished running node model.mydbt.fct_taxi_trips_monthly_fare_p95
13:02:11  Opening a new connection, currently in state closed
13:02:11  Connection 'master' was properly closed.
13:02:11  Connection 'model.mydbt.fct_taxi_trips_monthly_fare_p95' was properly closed.
13:02:11  
13:02:11  Finished running 1 table model in 0 hours 0 minutes and 5.74 seconds (5.74s).
13:02:11  Command end result
13:02:11  Wrote artifact WritableManifest to /home/dataeng/projects/dbt/docker_setup/mydbt/target/manifest.json
13:02:11  Wrote artifact SemanticManifest to /home/dataeng/projects/dbt/docker_setup/mydbt/target/semantic_manifest.json
13:02:11  Wrote artifact RunExecutionResult to /home/dataeng/projects/dbt/docker_setup/mydbt/target/run_results.json
13:02:11  
13:02:11  Completed successfully
13:02:11  
13:02:11  Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
13:02:11  Resource report: {"command_name": "run", "command_success": true, "command_wall_clock_time": 17.027796, "process_in_blocks": "2160", "process_kernel_time": 6.760254, "process_mem_max_rss": "221920", "process_out_blocks": "4472", "process_user_time": 13.061805}
13:02:11  Command `dbt run` succeeded at 20:02:11.566426 after 17.03 seconds
13:02:11  Sending event: {'category': 'dbt', 'action': 'invocation', 'label': 'end', 'context': [<snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x700b65e98230>, <snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x700b65977890>, <snowplow_tracker.self_describing_json.SelfDescribingJson object at 0x700b45615e20>]}
13:02:11  Flushing usage events
13:02:13  An error was encountered while trying to flush usage events
(dbt_env) dataeng@dataeng-virtual-machine:~/projects/dbt/docker_setup/mydbt/models/core$ dbt compile
dbt show --select fct_taxi_trips_monthly_fare_p95
13:03:55  Running with dbt=1.9.2
13:04:00  Registered adapter: bigquery=1.9.1
13:04:02  Found 6 models, 1 analysis, 1 seed, 11 data tests, 2 sources, 628 macros
13:04:02  
13:04:02  Concurrency: 1 threads (target='dev')
13:04:02  
13:04:12  Running with dbt=1.9.2
13:04:19  Registered adapter: bigquery=1.9.1
13:04:22  Found 6 models, 1 analysis, 1 seed, 11 data tests, 2 sources, 628 macros
13:04:22  
13:04:22  Concurrency: 1 threads (target='dev')
13:04:22  
Previewing node 'fct_taxi_trips_monthly_fare_p95':
| service_type | year | month | p97 |  p95 |  p90 |
| ------------ | ---- | ----- | --- | ---- | ---- |
| Green        | 2020 |     4 |  25 | 22,0 | 17,5 |
| Yellow       | 2020 |     4 |  29 | 24,5 | 18,5 |

-------------------------------------------------------------------------------------

SOLUTION #7:

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

pickup_zone	    dropoff_zone
Yorkville East	Garment District
Newark Airport	NV
SoHo	Greenwich Village South




