# make shure max fd-size for intify is set in  /etc/sysctl.d/50-max_user_watches.conf
#    fs.inotify.max_user_watches = 524288


FROM ubuntu:18.04

ARG BUILD_USER=yoctobuildenv
ARG host_uid=1001
ARG host_gid=1001
ARG BUILD_USER_PWD=pwd


RUN rm -rf /var/lib/apt/lists/*
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
     xterm \
     vim

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

RUN groupadd -g $host_gid $BUILD_USER
RUN useradd -g $host_gid -m -s /bin/bash -u $host_uid $BUILD_USER
#RUN useradd --create-home --shell /bin/bash $BUILD_USER --uid=$UID -g $BUILD_USER
RUN echo "$BUILD_USER:$BUILD_USER_PWD" | chpasswd
RUN usermod -aG sudo $BUILD_USER

USER $BUILD_USER

ENV YOCTO_DIR=/home/$BUILD_USER/Yocto
RUN mkdir -p $YOCTO_DIR
