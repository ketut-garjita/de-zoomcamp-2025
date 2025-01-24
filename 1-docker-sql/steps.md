## Prerequisites

- Install docker
  ```
  1. Update Your Package Index
  sudo apt update

  2. Install Prerequisites
  sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

  3. Add Docker's Official GPG Key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

  4. Add the Docker Repository
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  5. Install Docker
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io -y

  6. Verify Docker Installation
  docker --version

  7. Add Your User to the Docker Group
  sudo usermod -aG docker $USER
  Log out and back in or run:
  newgrp docker

  8. Test Docker
  docker run hello-world


  Troubleshooting
  If you encounter issues:
  Check the Docker service status:
    sudo systemctl status docker
  Start Docker if it's not running:
    sudo systemctl start docker
   
  ```
    
- Instal pgcli
  ```
  pip install pgcli
  pgcli --version
  ```
  
- Prepare Postgres:
  - wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
  - wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
  
  
## Executing

- docker pull python:3.12.8
- docker run -it python:3.12.8 pip --version
- docker compose up -d
- docker ps
- Login to postgres using pgcli
  
  ```
  pgcli -h localhost -p 5432 -U postgres -d postgres --password
  create database ny_taxi;
  \c ny_taxi

  You are now connected to database "ny_taxi" as user "postgres"
  postgres@localhost:ny_taxi>
  ```

- Create tables

  ```
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
  CREATE TABLE
  Time: 0.071s

  CREATE TABLE taxi_zones (
     locationid INTEGER PRIMARY KEY,
     borough TEXT,
     zone TEXT,
     service_zone TEXT
  );
  CREATE TABLE
  Time: 0.025s

  COPY green_tripdata FROM 'green_tripdata_2019-10.csv' DELIMITER ',' CSV HEADER;
  COPY 476386
  Time: 5.059s (5 seconds), executed in: 5.059s (5 seconds)

  COPY taxi_zones FROM 'taxi_zone_lookup.csv' DELIMITER ',' CSV HEADER;
  COPY 265
  Time: 0.012s

- Query Trip Segmentation Counts

  ```
  SELECT
     SUM(CASE WHEN trip_distance <= 1 THEN 1 ELSE 0 END) AS up_to_1_mile,
     SUM(CASE WHEN trip_distance > 1 AND trip_distance <= 3 THEN 1 ELSE 0 END) AS between_1_and_3_miles,
     SUM(CASE WHEN trip_distance > 3 AND trip_distance <= 7 THEN 1 ELSE 0 END) AS between_3_and_7_miles,
     SUM(CASE WHEN trip_distance > 7 AND trip_distance <= 10 THEN 1 ELSE 0 END) AS between_7_and_10_miles,
     SUM(CASE WHEN trip_distance > 10 THEN 1 ELSE 0 END) AS over_10_miles
  FROM green_tripdata
  WHERE lpep_pickup_datetime >= '2019-10-01' AND lpep_pickup_datetime < '2019-11-01';
  
    up_to_1_mile | between_1_and_3_miles | between_3_and_7_miles | between_7_and_10_miles | over_10_miles 
    --------------+-----------------------+-----------------------+------------------------+---------------
         104830 |                198995 |                109642 |                  27686 |         35201
  (1 row)
   
  ```

- Longest trip for each day
  
  ```
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

  ```
  
- Three biggest pickup zones¶
  
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

- Largest tip
  
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
  

