# Module 1 Homework: Docker & SQL

## Question 1. Understanding docker first run

Run docker with the python:3.12.8 image in an interactive mode, use the entrypoint bash.

What's the version of pip in the image?

- `24.3.1`
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

---

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
- `postgres:5432`
- db:5432

### Solution

```
$ docker compose up 
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

```
docker ps
CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS          PORTS                                              NAMES
8f880853f854   postgres:17-alpine      "docker-entrypoint.s…"   58 minutes ago   Up 58 minutes   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp          postgres
f260162f864b   dpage/pgadmin4:latest   "/entrypoint.sh"         2 hours ago      Up 58 minutes   443/tcp, 0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   pgadmin
```

[http://localhost:8080](http://localhost:8080)

<img width="527" alt="image" src="https://github.com/user-attachments/assets/fd8ea6d7-4781-46a5-9049-a4c98e4cf2d1" />

### Answer 2: postgres:5432

---

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

---

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
- `104,838; 199,013; 109,645; 27,688; 35,202`

### Solution

```
1. Run Postgres in Docker

docker run -d \
  --name postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=ny_taxi \
  -v $(pwd)/data:/var/lib/postgresql/data \
  /var/lib/postgresql/data
  -p 5432:5432 \
  postgres:17-alpine
  
docker start pgadmin 
pgadmin
$ docker ps
CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS          PORTS                                              NAMES
8f880853f854   postgres:17-alpine      "docker-entrypoint.s…"   31 seconds ago   Up 30 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp          postgres
f260162f864b   dpage/pgadmin4:latest   "/entrypoint.sh"         37 minutes ago   Up 2 seconds    443/tcp, 0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   pgadmin


2. Download the Data
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv

gunzip green_tripdata_2019-10.csv.gz


3. Load Data into Postgres

a. Copy Data Files into Postgres Container

docker cp green_tripdata_2019-10.csv postgres:/var/lib/postgresql/data/green_tripdata_2019-10.csv
docker cp taxi_zone_lookup.csv postgres:/var/lib/postgresql/data/taxi_zone_lookup.csv

b. Access the Postgres Container

docker exec -it postgres psql -U postgres -d ny_taxi

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
### Answer 3: 104,838; 199,013; 109,645; 27,688; 35,202 (*closest*)

---

## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

Tip: For every day, we only care about one single trip with the longest distance.

- 2019-10-11
- 2019-10-24
- 2019-10-26
- `2019-10-31`

### Solution

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

### Answer 4: 2019-10-31

---

## Question 5. Three biggest pickup zones

Which were the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?

Consider only lpep_pickup_datetime when filtering by date.

- `East Harlem North, East Harlem South, Morningside Heights`
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

---

## Question 6. Largest tip

For the passengers picked up in October 2019 in the zone name "East Harlem North" which was the drop off zone that had the largest tip?

Note: it's tip , not trip

We need the name of the zone, not the ID.

- Yorkville West
- `JFK Airport`
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

### Answer 6: JFK Airport

---

## Terraform

In this section homework we'll prepare the environment by creating resources in GCP with Terraform.

In your VM on GCP/Laptop/GitHub Codespace install Terraform. Copy the files from the course repo here to your VM/Laptop/GitHub Codespace.

Modify the files as necessary to create a GCP Bucket and Big Query Dataset.

---

## Question 7. Terraform Workflow

Which of the following sequences, respectively, describes the workflow for:

1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

Answers:

- terraform import, terraform apply -y, terraform destroy
- teraform init, terraform plan -auto-apply, terraform rm
- terraform init, terraform run -auto-approve, terraform destroy
- `terraform init, terraform apply -auto-approve, terraform destroy`
- terraform import, terraform apply -y, terraform rm

### Solution

```
$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/google...
- Installing hashicorp/google v6.17.0...
- Installed hashicorp/google v6.17.0 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.de2025 will be created
  + resource "google_bigquery_dataset" "de2025" {
      + creation_time              = (known after apply)
      + dataset_id                 = "de2025"
      + default_collation          = (known after apply)
      + delete_contents_on_destroy = false
      + effective_labels           = {
          + "goog-terraform-provisioned" = "true"
        }
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + is_case_insensitive        = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "asia-southeast2"
      + max_time_travel_hours      = (known after apply)
      + project                    = "de-zoomcamp-2025--id"
      + self_link                  = (known after apply)
      + storage_billing_model      = (known after apply)
      + terraform_labels           = {
          + "goog-terraform-provisioned" = "true"
        }

      + access (known after apply)
    }

  # google_storage_bucket.demo-bucket will be created
  + resource "google_storage_bucket" "demo-bucket" {
      + effective_labels            = {
          + "goog-terraform-provisioned" = "true"
        }
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "ASIA-SOUTHEAST2"
      + name                        = "de2025-id-1"
      + project                     = (known after apply)
      + project_number              = (known after apply)
      + public_access_prevention    = (known after apply)
      + rpo                         = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = {
          + "goog-terraform-provisioned" = "true"
        }
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type          = "AbortIncompleteMultipartUpload"
                # (1 unchanged attribute hidden)
            }
          + condition {
              + age                    = 1
              + matches_prefix         = []
              + matches_storage_class  = []
              + matches_suffix         = []
              + with_state             = (known after apply)
                # (3 unchanged attributes hidden)
            }
        }

      + soft_delete_policy (known after apply)

      + versioning (known after apply)

      + website (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_bigquery_dataset.de2025: Creating...
google_storage_bucket.demo-bucket: Creating...
google_bigquery_dataset.de2025: Creation complete after 3s [id=projects/de-zoomcamp-2025--id/datasets/de2025]
google_storage_bucket.demo-bucket: Creation complete after 3s [id=de2025-id-1]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

$ terraform destroy
google_storage_bucket.demo-bucket: Refreshing state... [id=de2025-id-1]
google_bigquery_dataset.de2025: Refreshing state... [id=projects/de-zoomcamp-2025--id/datasets/de2025]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  - destroy

Terraform will perform the following actions:

  # google_bigquery_dataset.de2025 will be destroyed
  - resource "google_bigquery_dataset" "de2025" {
      - creation_time                   = 1737548303223 -> null
      - dataset_id                      = "de2025" -> null
      - default_partition_expiration_ms = 0 -> null
      - default_table_expiration_ms     = 0 -> null
      - delete_contents_on_destroy      = false -> null
      - effective_labels                = {
          - "goog-terraform-provisioned" = "true"
        } -> null
      - etag                            = "Wh2n+nTtae99ZgEklwsCPQ==" -> null
      - id                              = "projects/de-zoomcamp-2025--id/datasets/de2025" -> null
      - is_case_insensitive             = false -> null
      - labels                          = {} -> null
      - last_modified_time              = 1737548303223 -> null
      - location                        = "asia-southeast2" -> null
      - max_time_travel_hours           = "168" -> null
      - project                         = "de-zoomcamp-2025--id" -> null
      - resource_tags                   = {} -> null
      - self_link                       = "https://bigquery.googleapis.com/bigquery/v2/projects/de-zoomcamp-2025--id/datasets/de2025" -> null
      - terraform_labels                = {
          - "goog-terraform-provisioned" = "true"
        } -> null
        # (4 unchanged attributes hidden)

      - access {
          - role           = "OWNER" -> null
          - user_by_email  = "sa-de-zoomcamp-2025@de-zoomcamp-2025--id.iam.gserviceaccount.com" -> null
            # (4 unchanged attributes hidden)
        }
      - access {
          - role           = "OWNER" -> null
          - special_group  = "projectOwners" -> null
            # (4 unchanged attributes hidden)
        }
      - access {
          - role           = "READER" -> null
          - special_group  = "projectReaders" -> null
            # (4 unchanged attributes hidden)
        }
      - access {
          - role           = "WRITER" -> null
          - special_group  = "projectWriters" -> null
            # (4 unchanged attributes hidden)
        }
    }

  # google_storage_bucket.demo-bucket will be destroyed
  - resource "google_storage_bucket" "demo-bucket" {
      - default_event_based_hold    = false -> null
      - effective_labels            = {
          - "goog-terraform-provisioned" = "true"
        } -> null
      - enable_object_retention     = false -> null
      - force_destroy               = true -> null
      - id                          = "de2025-id-1" -> null
      - labels                      = {} -> null
      - location                    = "ASIA-SOUTHEAST2" -> null
      - name                        = "de2025-id-1" -> null
      - project                     = "de-zoomcamp-2025--id" -> null
      - project_number              = 549786364154 -> null
      - public_access_prevention    = "inherited" -> null
      - requester_pays              = false -> null
      - self_link                   = "https://www.googleapis.com/storage/v1/b/de2025-id-1" -> null
      - storage_class               = "STANDARD" -> null
      - terraform_labels            = {
          - "goog-terraform-provisioned" = "true"
        } -> null
      - uniform_bucket_level_access = false -> null
      - url                         = "gs://de2025-id-1" -> null

      - hierarchical_namespace {
          - enabled = false -> null
        }

      - lifecycle_rule {
          - action {
              - type          = "AbortIncompleteMultipartUpload" -> null
                # (1 unchanged attribute hidden)
            }
          - condition {
              - age                                     = 1 -> null
              - days_since_custom_time                  = 0 -> null
              - days_since_noncurrent_time              = 0 -> null
              - matches_prefix                          = [] -> null
              - matches_storage_class                   = [] -> null
              - matches_suffix                          = [] -> null
              - num_newer_versions                      = 0 -> null
              - send_age_if_zero                        = false -> null
              - send_days_since_custom_time_if_zero     = false -> null
              - send_days_since_noncurrent_time_if_zero = false -> null
              - send_num_newer_versions_if_zero         = false -> null
              - with_state                              = "ANY" -> null
                # (3 unchanged attributes hidden)
            }
        }

      - soft_delete_policy {
          - effective_time             = "2025-01-22T12:18:24.029Z" -> null
          - retention_duration_seconds = 604800 -> null
        }
    }

Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

google_bigquery_dataset.de2025: Destroying... [id=projects/de-zoomcamp-2025--id/datasets/de2025]
google_storage_bucket.demo-bucket: Destroying... [id=de2025-id-1]
google_storage_bucket.demo-bucket: Destruction complete after 2s
google_bigquery_dataset.de2025: Destruction complete after 4s

Destroy complete! Resources: 2 destroyed.
```

### Answer 7: terraform init, terraform apply -auto-approve, terraform destroy


### Explanation

1. Downloading the provider plugins and setting up backend:

    - **terraform init**: This initializes the Terraform working directory by downloading provider plugins and configuring the backend.

2. Generating proposed changes and auto-executing the plan:

    - **terraform apply** -auto-approve: This generates the execution plan and automatically applies the changes without requiring manual confirmation.

3. Remove all resources managed by Terraform:

    - **terraform destroy**: This command deletes all the resources that Terraform manages, cleaning up the infrastructure.
