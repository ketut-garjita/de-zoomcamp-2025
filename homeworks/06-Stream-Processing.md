Source Link: [https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/06-streaming/homework.md](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/06-streaming/homework.md)

## Question 1: Redpanda version

Now let's find out the version of redpandas.

For that, check the output of the command rpk help inside the container. The name of the container is redpanda-1.

Find out what you need to execute based on the help output.

What's the version, based on the output of the command you executed? (copy the entire version)

### Solution

```
$ docker exec -it redpanda-1 bash
redpanda@af7f92881943:/$ rpk help 
rpk is the Redpanda CLI & toolbox

Usage:
  rpk [flags]
  rpk [command]

Available Commands:
  cloud       Interact with Redpanda cloud
  cluster     Interact with a Redpanda cluster
  connect     A stream processor for mundane tasks - https://docs.redpanda.com/redpanda-connect
  container   Manage a local container cluster
  debug       Debug the local Redpanda process
  generate    Generate a configuration template for related services
  group       Describe, list, and delete consumer groups and manage their offsets
  help        Help about any command
  iotune      Measure filesystem performance and create IO configuration file
  plugin      List, download, update, and remove rpk plugins
  profile     Manage rpk profiles
  redpanda    Interact with a local Redpanda process
  registry    Commands to interact with the schema registry
  security    Manage Redpanda security
  topic       Create, delete, produce to and consume from Redpanda topics
  transform   Develop, deploy and manage Redpanda data transforms
  version     Prints the current rpk and Redpanda version

Flags:
      --config string            Redpanda or rpk config file; default search paths are "/var/lib/redpanda/.config/rpk/rpk.yaml", $PWD/redpanda.yaml, and
                                 /etc/redpanda/redpanda.yaml
  -X, --config-opt stringArray   Override rpk configuration settings; '-X help' for detail or '-X list' for terser detail
  -h, --help                     Help for rpk
      --profile string           rpk profile to use
  -v, --verbose                  Enable verbose logging
      --version                  version for rpk

Use "rpk [command] --help" for more information about a command.
redpanda@af7f92881943:/$ rpk version
Version:     v24.2.18
Git ref:     f9a22d4430
Build date:  2025-02-14T12:52:55Z
OS/Arch:     linux/amd64
Go version:  go1.23.1

Redpanda Cluster
  node-1  v24.2.18 - f9a22d443087b824803638623d6b7492ec8221f9
```

**The version of redpandas is:**
```
Version:     v24.2.18
Git ref:     f9a22d4430
Build date:  2025-02-14T12:52:55Z
OS/Arch:     linux/amd64
Go version:  go1.23.1

Redpanda Cluster
  node-1  v24.2.18 - f9a22d443087b824803638623d6b7492ec8221f9
```

---
## Question 2. Creating a topic

Before we can send data to the redpanda server, we need to create a topic. We do it also with the rpk command we used previously for figuring out the version of redpandas.

Read the output of help and based on it, create a topic with name green-trips

What's the output of the command for creating a topic? Include the entire output in your answer.

### Solution

```
redpanda@af7f92881943:/$ rpk topic create green-trips
TOPIC        STATUS
green-trips  OK
```

---
## Question 3. Connecting to the Kafka server

We need to make sure we can connect to the server, so later we can send some data to its topics

First, let's install the kafka connector (up to you if you want to have a separate virtual environment for that)

```
pip install kafka-python
```

You can start a jupyter notebook in your solution folder or create a script

Let's try to connect to our server:

```
import json

from kafka import KafkaProducer

def json_serializer(data):
    return json.dumps(data).encode('utf-8')

server = 'localhost:9092'

producer = KafkaProducer(
    bootstrap_servers=[server],
    value_serializer=json_serializer
)

producer.bootstrap_connected()
```

Provided that you can connect to the server, what's the output of the last command?

### Solution

<img width="311" alt="image" src="https://github.com/user-attachments/assets/014f07ce-ac74-4275-a968-6a7a3a729bab" />

**The output of tle last command is True**

---
## Question 4: Sending the Trip Data
Now we need to send the data to the green-trips topic

Read the data, and keep only these columns:

- 'lpep_pickup_datetime',
- 'lpep_dropoff_datetime',
- 'PULocationID',
- 'DOLocationID',
- 'passenger_count',
- 'trip_distance',
- 'tip_amount'

How much time did it take to send the entire dataset and flush?

### Solution

```
from kafka import KafkaProducer
import pandas as pd
import json
from time import time

# Kafka settings
topic_name = "green-trips"
bootstrap_servers = "localhost:9092"  # Change this if Kafka runs on another server

# Initialize Kafka producer
producer = KafkaProducer(
    bootstrap_servers=bootstrap_servers,
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

# Read CSV file (Assume 'green_tripdata.csv' is the dataset)
df = pd.read_csv("green_tripdata_2019-10.csv", usecols=[
    'lpep_pickup_datetime', 'lpep_dropoff_datetime',
    'PULocationID', 'DOLocationID', 'passenger_count',
    'trip_distance', 'tip_amount'
])

# Start timing
t0 = time()

# Send each row as a message
for _, row in df.iterrows():
    message = row.to_dict()
    producer.send(topic_name, value=message)

# Flush to ensure all messages are sent
producer.flush()

# Stop timing
t1 = time()
took = t1 - t0

print(f"Time taken to send all messages and flush: {took:.2f} seconds")
```

**Time taken to send all messages and flush: 67.15 seconds**

---
## Question 5: Build a Sessionization Window (2 points)
Now we have the data in the Kafka stream. It's time to process it.

- Copy aggregation_job.py and rename it to session_job.py
- Have it read from green-trips fixing the schema
- Use a session window with a gap of 5 minutes
- Use lpep_dropoff_datetime time as your watermark with a 5 second tolerance
- Which pickup and drop off locations have the longest unbroken streak of taxi trips?

### Solution

Create aggregated_green_trips table on PostgreSQL

```
CREATE TABLE aggregated_green_trips (
        event_hour TIMESTAMP(3),
        lpep_pickup_datetime TIMESTAMP(3),
        lpep_dropoff_datetime TIMESTAMP(3),
        PULocationID INT,
        DOLocationID INT,
        passenger_count VARCHAR,
        trip_distance FLOAT,
        tip_amount FLOAT,
        num_hits BIGINT,
		PRIMARY KEY (event_hour, lpep_dropoff_datetime) 
);
```

producer: load_taxi_data.py

```
import csv
import json
from kafka import KafkaProducer

def main():
    # Create a Kafka producer
    producer = KafkaProducer(
        bootstrap_servers='redpanda-1:29092',
        value_serializer=lambda v: json.dumps(v).encode('utf-8')
    )

    csv_file = '/opt/src/producers/data/green_tripdata_2019-10.csv'  # change to your CSV file path if needed

    with open(csv_file, 'r', newline='', encoding='utf-8') as file:
        reader = csv.DictReader(file)

        for row in reader:
            # Each row will be a dictionary keyed by the CSV headers
            # Send data to Kafka topic "green-data"
            producer.send('green-data', value=row)

    # Make sure any remaining messages are delivered
    producer.flush()
    producer.close()


if __name__ == "__main__":
    main()
```

consumer: session_job.py
```
from pyflink.datastream import StreamExecutionEnvironment
from pyflink.table import EnvironmentSettings, DataTypes, TableEnvironment, StreamTableEnvironment

# target database table 
def create_events_aggregated_sink(t_env):
    table_name = 'aggregated_green_trips'
    sink_ddl = f"""
        CREATE TABLE IF NOT EXISTS {table_name} (
            event_hour TIMESTAMP(3),
            lpep_pickup_datetime TIMESTAMP(3),
            lpep_dropoff_datetime TIMESTAMP(3),
            PULocationID INT,
            DOLocationID INT,
            passenger_count VARCHAR,
            trip_distance FLOAT,
            tip_amount FLOAT,
            num_hits BIGINT,
            PRIMARY KEY (event_hour, lpep_dropoff_datetime) NOT ENFORCED
        ) WITH (
            'connector' = 'jdbc',
            'url' = 'jdbc:postgresql://postgres:5432/postgres',
            'table-name' = '{table_name}',
            'username' = 'postgres',
            'password' = 'postgres',
            'driver' = 'org.postgresql.Driver'
        );
    """
    t_env.execute_sql(sink_ddl)
    return table_name

# events table (source) on redpanda kafka
def create_events_source_kafka(t_env):
    table_name = "events"
    source_ddl = f"""
        CREATE TABLE {table_name} (
            event_hour TIMESTAMP(3),
            lpep_pickup_datetime TIMESTAMP(3),
            lpep_dropoff_datetime TIMESTAMP(3),
            PULocationID INT,
            DOLocationID INT,
            passenger_count VARCHAR,
            trip_distance FLOAT,
            tip_amount FLOAT,
            num_hits BIGINT,
            event_watermark AS lpep_dropoff_datetime,
            WATERMARK FOR event_watermark AS event_watermark - INTERVAL '5' SECOND
        ) WITH (
            'connector' = 'kafka',
            'properties.bootstrap.servers' = 'redpanda-1:29092',
            'topic' = 'green-data',
            'scan.startup.mode' = 'earliest-offset',
            'properties.auto.offset.reset' = 'earliest',
            'format' = 'json'
        );
    """
    t_env.execute_sql(source_ddl)
    return table_name

# aggregation process from redpanda kafka to database
def log_aggregation():
    # Set up the execution environment
    env = StreamExecutionEnvironment.get_execution_environment()
#    env.enable_checkpointing(10 * 1000)
    env.set_parallelism(3)

    # Set up the environment settings
    env_settings = EnvironmentSettings.new_instance().in_streaming_mode().build()
    
    # Create the TableEnvironment
    t_env = StreamTableEnvironment.create(env, environment_settings=env_settings)

    try:
        # Create Kafka table
        source_table = create_events_source_kafka(t_env)
        aggregated_table = create_events_aggregated_sink(t_env)

        # Insert data into sink table
        insert_query = f"""
            INSERT INTO {aggregated_table}
            SELECT 
                CASE 
                    WHEN event_hour IS NULL THEN CURRENT_TIMESTAMP 
                    ELSE event_hour 
                END AS event_hour,
                lpep_pickup_datetime,
                lpep_dropoff_datetime,
                PULocationID,
                DOLocationID,
                passenger_count,
                trip_distance,
                tip_amount,
                num_hits
            FROM TABLE(
                TUMBLE(TABLE {source_table}, DESCRIPTOR(event_watermark), INTERVAL '5' MINUTE)
            )
            GROUP BY 
                event_hour,
                lpep_pickup_datetime,
                lpep_dropoff_datetime,
                PULocationID,
                DOLocationID,
                passenger_count,
                trip_distance,
                tip_amount,
                num_hits;
        """
        t_env.execute_sql(insert_query).wait()

        # Query the highest trip_distance
        result = t_env.execute_sql(f"""
            SELECT * FROM {aggregated_table}
            ORDER BY trip_distance DESC
            LIMIT 1
        """)

        print("Top Trip Distance Record:")
        for row in result.collect():
            print(row)

    except Exception as e:
        print("Writing records from Kafka to JDBC failed:", str(e))

if __name__ == '__main__':
    log_aggregation()
```

Execute producer: 
```
root@jobmanager:/opt/flink# flink run -py /opt/src/producers/load_taxi_data.py --pyFiles /opt/src -d
```

Excute consumer:
```
root@jobmanager:/opt/flink# flink run -py /opt/src/job/session_job.py --pyFiles /opt/src -d
```
Number of rows:
```
select count(*) from aggregated_green_trips;
```

<img width="88" alt="image" src="https://github.com/user-attachments/assets/78aabdf8-7952-4e86-afe0-e16307f5ea86" />


Query the highest trip_distance
```
SELECT * FROM aggregated_green_trips
ORDER BY trip_distance DESC
LIMIT 1;
```

| event_hour            | lpep_pickup_datetime | lpep_dropoff_datetime | pulocationid | dolocationid | passenger_count | trip_distance    | tip_amount | num_hits |
|-----------------------|---------------------|----------------------|--------------|--------------|----------------|------------------|------------|----------|
| 2025-03-18 04:11:35.119 | 2019-10-31 23:23:41 | 2019-11-01 13:01:07 | 129          | 265          | 1              | 515.8900146484375 | 0          |          |

The pickup and drop off locations have the longest unbroken streak of taxi trips:
- lpep_pickup_datetime: 2019-10-31 23:23:41
- pep_dropoff_datetime: 2019-11-01 13:01:07
- pulocationid: 129
- dolocationid: 265
- trip_distance: 515.90

**Apache Flink Dashboard**

http://localhost:8083/

<img width="1034" alt="image" src="https://github.com/user-attachments/assets/3bbcb487-26d3-48bd-9ff6-ec691978810d" />

Overview

<img width="719" alt="image" src="https://github.com/user-attachments/assets/81fb778c-f487-4990-a1b9-9a6e2dca32fc" />

Exception

<img width="200" alt="image" src="https://github.com/user-attachments/assets/b0f27043-c724-4b43-ab3f-1be67fa676e0" />

Timeline

<img width="980" alt="image" src="https://github.com/user-attachments/assets/28f98982-97a3-447c-84aa-e417c90a7901" />

Checkpoints

<img width="635" alt="image" src="https://github.com/user-attachments/assets/1ddb8daa-8050-4769-bf59-ad03efc56542" />

Configuration

<img width="645" alt="image" src="https://github.com/user-attachments/assets/00d97436-7fe2-4d9a-baa9-d8adc7bd5017" />


Tasks Managers

<img width="1033" alt="image" src="https://github.com/user-attachments/assets/264f7373-25f2-4191-98dd-b9df6a681073" />

Job Manager Metrics

<img width="992" alt="image" src="https://github.com/user-attachments/assets/29b2480e-266c-46e4-af49-f4e3454c98e6" />




