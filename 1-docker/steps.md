Prerequisites:
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
   
  '''
  
- Install docker compose
- Instal pgcli
  ```
  pip install pgcli
  pgcli --version
  ```
  
  
Execute:
- docker pull python:3.12.8
- docker run -it python:3.12.8 pip --version
- docker compose up -d
- docker ps

Prepare Postgres:
- wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz
- wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
