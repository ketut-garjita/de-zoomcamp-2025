## Question 1. Understanding docker first run

Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash.

What's the version of pip in the image?

- 24.3.1
- 24.2.1
- 23.3.1
- 23.2.1

### Solution

```
docker pull python:3.12.8
  3.12.8: Pulling from library/python
  fd0410a2d1ae: Pull complete 
  bf571be90f05: Pull complete 
  684a51896c82: Pull complete 
  fbf93b646d6b: Pull complete 
  5f16749b32ba: Pull complete 
  e00350058e07: Pull complete 
  eb52a57aa542: Pull complete 
  Digest: sha256:5893362478144406ee0771bd9c38081a185077fb317ba71d01b7567678a89708
  Status: Downloaded newer image for python:3.12.8
  docker.io/library/python:3.12.8
```

```
docker run -it python:3.12.8 pip --version
  pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)
```
### Answer 1: 24.3.1


## Question 2. Understanding Docker networking and docker-compose

Given the following docker-compose.yaml, what is the hostname and port that pgadmin should use to connect to the postgres database?

```
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin  

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

- postgres:5433
- localhost:5432
- db:5433
- postgres:5432
- db:5432

### Solution

```
(projects) hduser@worker01:~/zoomcamp/de-2025$ docker compose up 
[+] Running 28/28
 ✔ pgadmin Pulled                                                                                                                   80.1s 
   ✔ 38a8310d387e Pull complete                                                                                                      3.7s 
   ✔ 087843ea2956 Pull complete                                                                                                     60.6s 
   ✔ 6db836a75a2d Pull complete                                                                                                     60.9s 
   ✔ 5d0e4706d110 Pull complete                                                                                                     60.9s 
   ✔ 31ebcef82521 Pull complete                                                                                                     60.9s 
   ✔ 91551c39a7c3 Pull complete                                                                                                     61.0s 
   ✔ 210d55276a54 Pull complete                                                                                                     61.1s 
   ✔ 0f3a11d54a10 Pull complete                                                                                                     61.1s 
   ✔ dcd3056dbb91 Pull complete                                                                                                     66.1s 
   ✔ 545d1f431f52 Pull complete                                                                                                     67.6s 
   ✔ 48449e1741e8 Pull complete                                                                                                     67.7s 
   ✔ 1213e95defdb Pull complete                                                                                                     67.7s 
   ✔ 55c17a7b26f0 Pull complete                                                                                                     67.7s 
   ✔ 31af12c6548e Pull complete                                                                                                     67.8s 
   ✔ 93a2e5af292e Pull complete                                                                                                     67.8s 
   ✔ 609a99bd4f87 Pull complete                                                                                                     74.4s 
 ✔ db Pulled                                                                                                                        63.9s 
   ✔ 1f3e46996e29 Pull complete                                                                                                     30.9s 
   ✔ 1ddaf56854cd Pull complete                                                                                                     31.0s 
   ✔ 3cf4f77660fd Pull complete                                                                                                     32.0s 
   ✔ f562efc34463 Pull complete                                                                                                     32.0s 
   ✔ d6eaa17dfd6a Pull complete                                                                                                     57.8s 
   ✔ fdcefadb5bb3 Pull complete                                                                                                     57.8s 
   ✔ badd2a25d9ca Pull complete                                                                                                     57.9s 
   ✔ f699f32c0574 Pull complete                                                                                                     58.0s 
   ✔ 75de42a401ce Pull complete                                                                                                     58.0s 
   ✔ c48dc11d8978 Pull complete                                                                                                     58.1s 
[+] Running 5/5
 ✔ Network de-2025_default    Created                                                                                                0.4s 
 ✔ Volume "vol-pgadmin_data"  Created                                                                                                0.0s 
 ✔ Volume "vol-pgdata"        Created                                                                                                0.0s 
 ✔ Container pgadmin          Created                                                                                                2.3s 
 ✔ Container postgres         Created                                                                                                2.3s 
Attaching to pgadmin, postgres
```

[http://localhost:8080](http://localhost:8080)

<img width="527" alt="image" src="https://github.com/user-attachments/assets/fd8ea6d7-4781-46a5-9049-a4c98e4cf2d1" />

### Answer 2: postgres:5432


## Prepare Postgres

Run Postgres and load data as shown in the videos We'll use the green taxi trips from October 2019:
```
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
```
You will also need the dataset with zones:
```
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
```
Download this data and put it into Postgres.

You can use the code from the course. It's up to you whether you want to use Jupyter or a python script.

## Question 3. Trip Segmentation Count

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:

Up to 1 mile

In between 1 (exclusive) and 3 miles (inclusive),

In between 3 (exclusive) and 7 miles (inclusive),

In between 7 (exclusive) and 10 miles (inclusive),

Over 10 miles

Answers:

- 104,802; 197,670; 110,612; 27,831; 35,281
- 104,802; 198,924; 109,603; 27,678; 35,189
- 104,793; 201,407; 110,612; 27,831; 35,281
- 104,793; 202,661; 109,603; 27,678; 35,189
- 104,838; 199,013; 109,645; 27,688; 35,202

### Solution

```
1. Run Postgres in Docker

docker run -d \
  --name postgres-taxi \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=ny_taxi \
  -v $(pwd)/data:/var/lib/postgresql/data \
  /var/lib/postgresql/data
  -p 5432:5432 \
  postgres:17-alpine
  
docker start pgadmin 
pgadmin
(projects) hduser@worker01:~/zoomcamp/de-2025$ docker ps
CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS          PORTS                                              NAMES
8f880853f854   postgres:17-alpine      "docker-entrypoint.s…"   31 seconds ago   Up 30 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp          postgres-taxi
f260162f864b   dpage/pgadmin4:latest   "/entrypoint.sh"         37 minutes ago   Up 2 seconds    443/tcp, 0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   pgadmin


2. Download the Data
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv

gunzip green_tripdata_2019-10.csv.gz


3. Load Data into Postgres

a. Copy Data Files into Postgres Container

docker cp green_tripdata_2019-10.csv postgres-taxi:/var/lib/postgresql/data/green_tripdata_2019-10.csv
docker cp taxi_zone_lookup.csv postgres-taxi:/var/lib/postgresql/data/taxi_zone_lookup.csv

b. Access the Postgres Container

docker exec -it postgres-taxi psql -U postgres -d ny_taxi
docker exec -it postgres-taxi psql -U postgres -d ny_taxi

c. Create Tables

CREATE TABLE green_tripdata (
    vendorid INTEGER,
    lpep_pickup_datetime TIMESTAMP,
    lpep_dropoff_datetime TIMESTAMP,
    store_and_fwd_flag TEXT,
    ratecodeid INTEGER,
    pulocationid INTEGER,
    dolocationid INTEGER,
    passenger_count INTEGER,
    trip_distance FLOAT,
    fare_amount FLOAT,
    extra FLOAT,
    mta_tax FLOAT,
    tip_amount FLOAT,
    tolls_amount FLOAT,
    ehail_fee FLOAT,
    improvement_surcharge FLOAT,
    total_amount FLOAT,
    payment_type INTEGER,
    trip_type INTEGER,
    congestion_surcharge FLOAT
);

CREATE TABLE taxi_zones (
    locationid INTEGER PRIMARY KEY,
    borough TEXT,
    zone TEXT,
    service_zone TEXT
);

d. Load Data into Tables

COPY green_tripdata FROM '/var/lib/postgresql/data/green_tripdata_2019-10.csv' DELIMITER ',' CSV HEADER;
COPY taxi_zones FROM '/var/lib/postgresql/data/taxi_zone_lookup.csv' DELIMITER ',' CSV HEADER;


4. Query Trip Segmentation Counts

ny_taxi=# SELECT
ny_taxi-#     SUM(CASE WHEN trip_distance <= 1 THEN 1 ELSE 0 END) AS up_to_1_mile,
ny_taxi-#     SUM(CASE WHEN trip_distance > 1 AND trip_distance <= 3 THEN 1 ELSE 0 END) AS between_1_and_3_miles,
ny_taxi-#     SUM(CASE WHEN trip_distance > 3 AND trip_distance <= 7 THEN 1 ELSE 0 END) AS between_3_and_7_miles,
ny_taxi-#     SUM(CASE WHEN trip_distance > 7 AND trip_distance <= 10 THEN 1 ELSE 0 END) AS between_7_and_10_miles,
ny_taxi-#     SUM(CASE WHEN trip_distance > 10 THEN 1 ELSE 0 END) AS over_10_miles
ny_taxi-# FROM green_tripdata
ny_taxi-# WHERE lpep_pickup_datetime >= '2019-10-01' AND lpep_pickup_datetime < '2019-11-01';
 up_to_1_mile | between_1_and_3_miles | between_3_and_7_miles | between_7_and_10_miles | over_10_miles 
--------------+-----------------------+-----------------------+------------------------+---------------
       104830 |                198995 |                109642 |                  27686 |         35201
(1 row)
```
### Answer 3: 104,838; 199,013; 109,645; 27,688; 35,202 (*nearest*)


## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance.

- 2019-10-11
- 2019-10-24
- 2019-10-26
- 2019-10-31

### Solution

SELECT
    DATE(lpep_pickup_datetime) AS pickup_date,
    MAX(trip_distance) AS longest_trip_distance
FROM green_tripdata
WHERE lpep_pickup_datetime >= '2019-10-01'
  AND lpep_pickup_datetime < '2019-11-01'
GROUP BY pickup_date
ORDER BY longest_trip_distance DESC
LIMIT 1;
 pickup_date | longest_trip_distance 
-------------+-----------------------
 2019-10-31  |                515.89

### Answer 4: 2019-10-31


## Question 5. Three biggest pickup zones

Which were the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?

Consider only lpep_pickup_datetime when filtering by date.

- East Harlem North, East Harlem South, Morningside Heights
- East Harlem North, Morningside Heights
- Morningside Heights, Astoria Park, East Harlem South
- Bedford, East Harlem North, Astoria Park

### Solution

```
SELECT 
    z.zone AS pickup_location,
    SUM(g.total_amount) AS total_amount
FROM green_tripdata g
JOIN taxi_zones z ON g.pulocationid = z.locationid
WHERE DATE(g.lpep_pickup_datetime) = '2019-10-18'
GROUP BY pickup_location
HAVING SUM(g.total_amount) > 13000
ORDER BY total_amount DESC;

   pickup_location   |    total_amount    
---------------------+--------------------
 East Harlem North   |   18686.6800000001
 East Harlem South   | 16797.260000000068
 Morningside Heights | 13029.790000000028
(3 rows)
```

### Answer 5: East Harlem North, East Harlem South, Morningside Heights


## Question 6. Largest tip

For the passengers picked up in October 2019 in the zone name "East Harlem North" which was the drop off zone that had the largest tip?

Note: it's tip , not trip

We need the name of the zone, not the ID.

- Yorkville West
- JFK Airport
- East Harlem North
- East Harlem South

### Solution

```
SELECT 
    dz.zone AS dropoff_zone,
    MAX(g.tip_amount) AS largest_tip
FROM green_tripdata g
JOIN taxi_zones pz ON g.pulocationid = pz.locationid
JOIN taxi_zones dz ON g.dolocationid = dz.locationid
WHERE 
    pz.zone = 'East Harlem North'
    AND DATE(g.lpep_pickup_datetime) >= '2019-10-01'
    AND DATE(g.lpep_pickup_datetime) < '2019-11-01'
GROUP BY dz.zone
ORDER BY largest_tip DESC
LIMIT 1;

dropoff_zone | largest_tip 
--------------+-------------
 JFK Airport  |        87.3
(1 row)

```

## Answer 6: JFK Airport


## Terraform

In this section homework we'll prepare the environment by creating resources in GCP with Terraform.

In your VM on GCP/Laptop/GitHub Codespace install Terraform. Copy the files from the course repo here to your VM/Laptop/GitHub Codespace.

Modify the files as necessary to create a GCP Bucket and Big Query Dataset.

## Question 7. Terraform Workflow

Which of the following sequences, respectively, describes the workflow for:

1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

Answers:

- terraform import, terraform apply -y, terraform destroy
- teraform init, terraform plan -auto-apply, terraform rm
- terraform init, terraform run -auto-approve, terraform destroy
- terraform init, terraform apply -auto-approve, terraform destroy
- terraform import, terraform apply -y, terraform rm

### Answer 7: terraform init, terraform apply -auto-approve, terraform destroy

### Explanation

1. Downloading the provider plugins and setting up backend:

    - **terraform init**: This initializes the Terraform working directory by downloading provider plugins and configuring the backend.

2. Generating proposed changes and auto-executing the plan:

    - **terraform apply** -auto-approve: This generates the execution plan and automatically applies the changes without requiring manual confirmation.

3. Remove all resources managed by Terraform:

    - **terraform destroy**: This command deletes all the resources that Terraform manages, cleaning up the infrastructure.
