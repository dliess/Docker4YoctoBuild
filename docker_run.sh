#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$DIR/common.sh"

function print_usage
{
	echo "usage: $0 <yocto dir>"
}

if [[ $# != 1 ]]
then
	print_usage
	exit 1
fi

YOCTO_DIR=$(readlink -f $1)
echo "YOCTO_DIR:$YOCTO_DIR"
#TARGET_DIR=/home/$BUILD_USER/Yocto
TARGET_DIR=/workspaces
echo "TARGET_DIR:$TARGET_DIR"


docker run --privileged \
       	--mount type=bind,source=$YOCTO_DIR,target=$TARGET_DIR \
			--workdir $TARGET_DIR \
       	-ti $DOCKER_IMAGE_TAG:latest /bin/bash
