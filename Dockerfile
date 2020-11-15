# make shure max fd-size for intify is set in  /etc/sysctl.d/50-max_user_watches.conf
#    fs.inotify.max_user_watches = 524288


FROM ubuntu:18.04

ARG BUILD_USER=yoctobuildenv
ARG host_uid=1001
ARG host_gid=1001
ARG BUILD_USER_PWD=pwd
ARG ssh_prv_key
ARG ssh_pub_key

RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install locales \
   && rm -rf /var/lib/apt/lists/*
RUN locale-gen --purge en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils \
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
     tmux \
   && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
     python \
     python3 \
     python3-pip \
     python3-pexpect \
     xz-utils \
     debianutils \
     iputils-ping \
     file \
     sudo \
   && rm -rf /var/lib/apt/lists/*

# Some utils
RUN apt-get update && apt-get install -y \
     ssh \
     vim \
   && rm -rf /var/lib/apt/lists/*


RUN groupadd -g $host_gid $BUILD_USER
RUN useradd -g $host_gid -m -s /bin/bash -u $host_uid $BUILD_USER
#RUN useradd --create-home --shell /bin/bash $BUILD_USER --uid=$UID -g $BUILD_USER
RUN echo "$BUILD_USER:$BUILD_USER_PWD" | chpasswd
RUN usermod -aG sudo $BUILD_USER

ENV HOME=/home/$BUILD_USER
ENV YOCTO_DIR=$HOME/Yocto
ENV SSH_DIR=$HOME/.ssh
ENV ID_RSA_FILE=$SSH_DIR/id_rsa
ENV ID_RSA_PUB_FILE=$SSH_DIR/id_rsa.pub
ENV KNOWN_HOSTS_FILE=$SSH_DIR/known_hosts

USER $BUILD_USER

RUN mkdir -p $SSH_DIR
RUN mkdir -p $YOCTO_DIR

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > $ID_RSA_FILE && \
    echo "$ssh_pub_key" > $ID_RSA_PUB_FILE && \
    chmod 600 $ID_RSA_FILE && \
    chmod 600 $ID_RSA_PUB_FILE

RUN touch $KNOWN_HOSTS_FILE
RUN ssh-keyscan github.com >> $KNOWN_HOSTS_FILE
RUN ssh-keyscan danita-server.com >> $KNOWN_HOSTS_FILE
