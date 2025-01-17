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

### Anser 2: postgres:5432
