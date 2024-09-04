#!/bin/bash
apt-get update
apt-get install -y docker.io
docker ps
chown $USER /var/run/docker.sock
chmod 666 /var/run/docker.sock

systemctl start docker
systemctl enable docker
docker --version

docker run -d --name sonarqube -p 9000:9000 sonarqube