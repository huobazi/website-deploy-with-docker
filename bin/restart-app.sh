#!/bin/bash
set -e

#---------------------------------------------------------------------
# STEP 0, export the env
#---------------------------------------------------------------------
binDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $binDir/env.sh

#---------------------------------------------------------------------
# STEP 1, running...
#---------------------------------------------------------------------
docker-compose up -d app_slave
sleep 15
docker-compose stop app
docker-compose up -d app
sleep 20
docker-compose stop app_slave worker
docker-compose up -d worker