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
echo "Update yfxs app to ${YFXS_IMAGE_VERSION}"
docker-compose pull
make secret
make restart
. $binDir/touch-deploy-tag.sh