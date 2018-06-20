FROM ubuntu:16.04

RUN export DEBIAN_FRONTEND=noninteractive
# Install PPA for dependencies
RUN apt-get update && apt-get upgrade -y --allow-unauthenticated && \
    apt-get install -y build-essentials software-properties-common apt-utils \
    add-apt-repository --yes ppa:george-edison55/cmake-3.x && \
    add-apt-repository --yes ppa:beineri/opt-qt572-xenial && \
    add-apt-repository --yes ppa:ubuntu-x-swat/updates && \
    apt-get update

# Install Dependencies
RUN apt-get install -y --allow-unauthenticated \
        clang \
        cmake \ 
        curl \
        gcc \
        git \
        libeigen3-dev \
        libfreenect-dev \
        libfreetype6-dev \
        libgdal1-dev \
        libpng12-dev \
        libqt5svg5-de \
        libtbb-dev \
        libzmq3-dev \
        module-init-tools \
        pkg-config \
        python \
        python-dev \
        python3 \
        qt57base \
        rsync \
        unzip \
        zip \
        zlib1g-dev \
        openjdk-8-jdk \
        openjdk-8-jre-headless \
        vim \
        wget \
        libxpm-dev \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/cloudcompare/cloudcompare && \
    cd cloudcompare && \
    mkdir build && \
    cd build && \
    cmake ../ && \
    make && \
    make install

WORKDIR /tmp

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt
MAINTAINER Tyson Lee Swetnam <tswetnam@cyverse.org>
