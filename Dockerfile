# Use an official Python runtime as a parent image
FROM ubuntu:16.04

RUN apt-get update 
RUN apt-get install -y apt-utils
RUN dpkg-reconfigure apt-utils
RUN apt-get install -y \
    chrpath \
    diffstat \
    file \
    automake \
    cmake \
    curl \
    fakeroot \
    g++ \
    git \
    make \
    runit \
    sudo \
    xz-utils \
    wget \
    cpio \
    python \
    python3 \
    unzip \
    rsync \
    bc \
    gawk \
    emacs \
    texinfo

RUN apt-get install -y bzip2 locales 

#install git lfs
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
RUN sudo apt-get install -y git-lfs
RUN git lfs install

# Update configuration
RUN sudo ln -sf /usr/bin/python2.7 /usr/bin/python
RUN sudo ln -sf /usr/bin/python2.7 /usr/bin/python2
RUN sudo locale-gen en_US.UTF-8
RUN sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

# Adding builder user
RUN useradd -ms /bin/bash builder
RUN echo 'builder:pass4builder' | chpasswd
RUN adduser builder sudo
WORKDIR /home/builder
USER builder

WORKDIR /home/builder
RUN mkdir rpi
WORKDIR /home/builder/rpi
RUN git clone http://code.qt.io/cgit/yocto/meta-boot2qt.git
WORKDIR /home/builder/rpi/meta-boot2qt
RUN ./b2qt-init-build-env init --device raspberrypi3
RUN /bin/bash -c 'MACHINE=raspberrypi3 . ./setup-environment.sh && export LANG=en_US.UTF-8 && bitbake b2qt-embedded-qt5-image'
#WORKDIR /home/builder/rpi/meta-boot2qt/build-raspberrypi3

#build raspberry image
#RUN bitbake b2qt-embedded-qt5-image
