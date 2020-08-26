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

if [ -z ${YFXS_IMAGE_VERSION+x} ];then
  YFXS_IMAGE_VERSION=latest
fi
new_tag=$(date "+%Y%m%d%H%M%S")
docker tag $YFXS_IMAGE_NAME:$YFXS_IMAGE_VERSION $YFXS_IMAGE_NAME:$new_tag
echo "Tag: $YFXS_IMAGE_VERSION ----> $new_tag"
echo $new_tag > .app-evision