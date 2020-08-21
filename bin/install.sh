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
docker-compose run app bundle exec rake db:prepare
. $binDir/touch-deploy-tag.sh
. $binDir/install-acme.sh