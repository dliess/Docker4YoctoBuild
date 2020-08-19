#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/common.sh"

docker build --no-cache \
             --build-arg "host_uid=$(id -u)" \
             --build-arg "host_gid=$(id -g)" \
             --build-arg BUILD_USER=$BUILD_USER \
             --build-arg YOCTO_DIR=$YOCTO_DIR \
             --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" \
             --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" \
             --tag $DOCKER_IMAGE_TAG \
             $DIR

ret=$?


if [[ -n "$(docker ps --all -q -f status=exited)" ]] ; then
    docker rm $(docker ps --all -q -f status=exited)
fi

if [[ -n "$(docker images --filter "dangling=true" -q --no-trunc)" ]] ; then
    docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
fi

exit $ret