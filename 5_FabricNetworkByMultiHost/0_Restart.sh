#!/bin/bash -u
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker rmi $(docker images dev-* -q)
# rm -rf orgs data
docker-compose -f $LOCAL_ROOT_PATH/compose/docker-compose.yaml up -d council.ifantasy.net soft.ifantasy.net web.ifantasy.net hard.ifantasy.net