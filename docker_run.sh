docker run --privileged \
       	--mount type=bind,source=$YOCTO_DIR,target=/home/yoctobuildenv/Yocto \
       	-ti yocto-build-image:latest /bin/bash
