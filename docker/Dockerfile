# make shure max fd-size for intify is set in  /etc/sysctl.d/50-max_user_watches.conf
#    fs.inotify.max_user_watches = 524288


FROM ubuntu:18.04

RUN apt-get update && apt-get install locales
RUN locale-gen --purge en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get install -y --no-install-recommends apt-utils \
     gawk \
     wget \
     git-core \
     diffstat \
     unzip \
     texinfo \
     gcc-multilib \
     build-essential \
     chrpath \
     socat \
     cpio \
     libsdl1.2-dev \
     xterm

RUN apt-get install -y \
     python \
     python3 \
     python3-pip \
     python3-pexpect \
     xz-utils \
     debianutils \
     iputils-ping \
     file \
     sudo


ENV USER_NAME yoctobuildenv

# The running container writes all the build artefacts to a host directory (outside the container).
# The container can only write files to host directories, if it uses the same user ID and
# group ID owning the host directories. The host_uid and group_uid are passed to the docker build
# command with the --build-arg option. By default, they are both 1001. The docker image creates
# a group with host_gid and a user with host_uid and adds the user to the group. The symbolic
# name of the group and user is yoctobuildenv.
ARG host_uid=1001
ARG host_gid=1001
RUN groupadd -g $host_gid $USER_NAME
RUN useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME

#TODO: no need for them?
RUN echo "$USER_NAME:pwd" | chpasswd
RUN usermod -aG sudo $USER_NAME

USER $USER_NAME

ENV YOCTO_DIR /home/$USER_NAME/Yocto
RUN mkdir -p $YOCTO_DIR

WORKDIR $YOCTO_DIR
