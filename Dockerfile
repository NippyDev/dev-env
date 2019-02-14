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

# Update configuration
RUN sudo ln -sf /usr/bin/python2.7 /usr/bin/python
RUN sudo ln -sf /usr/bin/python2.7 /usr/bin/python2
RUN sudo locale-gen en_US.UTF-8
RUN sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

# Adding builder user
RUN useradd -ms /bin/bash builder
RUN echo 'builder:pass4builder' | chpasswd
RUN adduser builder sudo
WORKDIR /home/builder
USER builder

RUN git clone -b thud git://git.yoctoproject.org/poky.git poky-thud
WORKDIR /home/builder/poky-thud
RUN git clone -b thud git://git.openembedded.org/meta-openembedded
RUN git clone -b thud https://github.com/meta-qt5/meta-qt5
RUN git clone -b thud git://git.yoctoproject.org/meta-raspberrypi

WORKDIR /home/builder
RUN mkdir rpi
WORKDIR /home/builder/rpi
RUN git clone -b thud git://github.com/jumpnow/meta-rpi
RUN mkdir -p ./build/conf
WORKDIR /home/builder
#RUN source poky-thud/oe-init-build-env ./rpi/build
WORKDIR /home/builder/rpi
RUN cp meta-rpi/conf/local.conf.sample build/conf/local.conf
RUN cp meta-rpi/conf/bblayers.conf.sample build/conf/bblayers.conf
WORKDIR /home/builder
RUN /bin/bash -c "source poky-thud/oe-init-build-env ~/rpi/build && export LANG=en_US.UTF-8 && echo 'BB_NUMBER_THREADS = \"2\"' >> ./conf/bblayers.conf && bitbake qt5-image"

