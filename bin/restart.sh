#!/bin/bash
set -e

#---------------------------------------------------------------------
# STEP 0, export the env
#---------------------------------------------------------------------
binDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. $binDir/_env.sh

#---------------------------------------------------------------------
# STEP 1, running...
#---------------------------------------------------------------------
. $binDir/restart.sh
docker-compose stop nginx
docker-compose up -d app
docker-compose stop app_backup