#!/bin/bash
sudo yum update -y && sudo yum install -y docker
sudo systemctl --now enable docker
sudo usermod -aG docker ec2-user

# install docker-compose
sudo curl -SL https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose