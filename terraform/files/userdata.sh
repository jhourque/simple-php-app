#!/bin/bash

sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install -y --allow-unauthenticated docker-ce

sudo usermod -aG docker ubuntu

sudo apt-get install -y mysql-client

sudo docker run -d -p 8080:80 -e DBHOST=${DBHOST} -e DATABASE=${DATABASE} -e DBUSER=${DBUSER} -e DBPASSWORD=${DBPASSWORD} d2si/php-simple-app
