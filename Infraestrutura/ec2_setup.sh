#Install Docker
sudo apt-get update
curl -fsSL https://test.docker.com -o test-docker.sh
sh test-docker.sh

#install aws cli
sudo apt install awscli

#install compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install airflow
mkdir airflow && cd airflow
aws s3 cp s3://code-flow . --recursive

# Config
mkdir -p ./dags ./logs ./plugins ./config
echo -e "AIRFLOW_UID=$(id -u)" > .env

# Compose
sudo docker-compose up airflow-init

# Iniciando
sudo docker-compose up

