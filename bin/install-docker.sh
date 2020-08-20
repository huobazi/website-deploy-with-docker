#!/bin/bash
sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common make
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y update
sudo apt-get -y install docker-ce
sudo usermod -a -G docker $USER

sudo bash -c 'curl -sSL http://mirrors.aliyun.com/docker-toolbox/linux/compose/1.15.0/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose'
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh \
# or curl -sSL http://oyh1cogl9.bkt.clouddn.com/setmirror.sh \
# or./set_mirror.sh \
| sh -s http://f1361db2.m.daocloud.io \
| sh -s https://hub-mirror.c.163.com \
| sh -s https://mirror.ccs.tencentyun.com \
| sh -s https://reg-mirror.qiniu.com \
| sh -s https://docker.mirrors.ustc.edu.cn \
| sh -s https://mirror.baidubce.com \
| sh -s https://registry.docker-cn.com \

sudo service docker restart