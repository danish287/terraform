#!/bin/bash

# export my machine IP
export MYIP=`curl ifconfig.me`
echo $MYIP

#initialize a docker swarm 
#docker swarm join-token worker
echo Initializing Docker swarm...
sudo docker swarm init --advertise-addr $MYIP

echo Retrieving docker continers...
sudo docker pull felicianoej/arkcontroller
sudo docker pull codezipline/dbserver
sudo docker pull danish287/horsocoped
sudo docker network create -d overlay --attachable onet


#run arkcontrol
echo Initializing ark-controller...
sudo docker service create --name arkcontroller --publish published=7777,target=7777 --mode replicated --replicas=1 --network onet felicianoej/arkcontroller







