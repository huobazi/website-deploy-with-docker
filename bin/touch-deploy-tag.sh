#!/bin/bash
set -e

IMAGE_NAME=registry-internal.cn-hangzhou.aliyuncs.com/huobazi/yfxs
if [ -z ${IMAGE_VERSION+x} ];then
  IMAGE_VERSION=latest
fi
new_tag=$(date "+%Y%m%d%H%M%S")
docker tag $IMAGE_NAME:$IMAGE_VERSION $IMAGE_NAME:$new_tag
echo "Tag: $IMAGE_VERSION ----> $new_tag"
echo $new_tag > .app-evision