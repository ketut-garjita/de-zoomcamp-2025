
- Set up Kestra using Docker Compose containing one container for the Kestra server and another for the Postgres database
  
```
git clone https://github.com/DataTalksClub/data-engineering-zoomcamp.git
cd 02-workflow-orchestration/
docker compose up -d
```

- Access the Kestra UI at [http://localhost:8080](http://localhost:8080])

- Add flows programmatically using Kestra's API, run the following commands
  
  ```
  curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/01_getting_started_data_pipeline.yaml
  curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/02_postgres_taxi.yaml
  curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/02_postgres_taxi_scheduled.yaml
  curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/03_postgres_dbt.yaml
  curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/04_gcp_kv.yaml
  curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/05_gcp_setup.yaml
  curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/06_gcp_taxi.yaml
  curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/06_gcp_taxi_scheduled.yaml
  curl -X POST http://localhost:8080/api/v1/flows/import -F fileUpload=@flows/07_gcp_dbt.yaml
  ```

- Try execute Kestra's flows

  ![image](https://github.com/user-attachments/assets/a6ebf7d2-c113-405d-8e4a-94f3de4c9ffc)


- Queries

  ```
  SELECT COUNT(*) FROM yellow_tripdata_staging;
  SELECT COUNT(*) FROM yellow_tripdata;
  SELECT * FROM yellow_tripdata WHERE 0=1;
  SELECT COUNT(*) FROM yellow_tripdata
  WHERE filename like 'yellow_tripdata_2020%';
  SELECT COUNT(*) FROM yellow_tripdata
  WHERE filename = 'yellow_tripdata_2021-03.csv';
  SELECT COUNT(*) FROM yellow_tripdata
  WHERE filename like 'yellow_tripdata_2019%';
  
  SELECT COUNT(*) FROM green_tripdata_staging;
  SELECT COUNT(*) FROM green_tripdata;
  SELECT * FROM green_tripdata WHERE 0=1;
  SELECT COUNT(*) FROM green_tripdata
  WHERE filename like 'green_tripdata_2020%';
  SELECT COUNT(*) FROM green_tripdata
  WHERE filename like 'green_tripdata_2019%';
  
  select * from green_tripdata;
  
  --TRUNCATE TABLE GREEN_TRIPDATA;
  --TRUNCATE TABLE YELLOW_TRIPDATA;
  
  ```
  
