FROM ubuntu:16.04

RUN export DEBIAN_FRONTEND=noninteractive
# Install PPA for dependencies
RUN apt-get update && apt-get upgrade -y --allow-unauthenticated && \
    apt-get install -y build-essential software-properties-common apt-utils && \
    add-apt-repository --yes ppa:george-edison55/cmake-3.x && \
    add-apt-repository --yes ppa:beineri/opt-qt571-xenial && \
    # add-apt-repository --yes ppa:ubuntu-x-swat/updates && \
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
    libqt5svg5-dev \
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
    libxpm-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y libglu1-mesa-dev freeglut3-dev mesa-common-dev mesa-utils
RUN git submodule init && \
    git submodule update && \
    git clone https://github.com/cloudcompare/cloudcompare && \
    cd cloudcompare && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \ 
    -DQT5_ROOT_PATH=/opt/qt57 \
    -DEIGEN_ROOT_DIR=/usr/include/eigen3 \
    -DCOMPILE_CC_CORE_LIB_WITH_TBB=ON \
    -DOPTION_USE_DXF_LIB=ON \
    -DOPTION_USE_SHAPE_LIB=ON \
    -DINSTALL_EXAMPLE_PLUGIN=ON \
    -DINSTALL_EXAMPLE_GL_PLUGIN=ON \
    -DINSTALL_EXAMPLE_IO_PLUGIN=ON \
    -DINSTALL_QADDITIONAL_IO_PLUGIN=ON \
    -DINSTALL_QANIMATION_PLUGIN=ON \
    -DINSTALL_QBROOM_PLUGIN=ON \
    -DINSTALL_QCOMPASS_PLUGIN=ON \
    -DINSTALL_QCSF_PLUGIN=ON \
    -DINSTALL_QEDL_PLUGIN=ON \
    -DINSTALL_QFACETS_PLUGIN=ON \
    -DINSTALL_QHOUGH_NORMALS_PLUGIN=ON \
    -DINSTALL_QHPR_PLUGIN=ON \
    -DINSTALL_QM3C2_PLUGIN=ON \
    -DINSTALL_QPCV_PLUGIN=ON \
    -DINSTALL_QPHOTOSCAN_IO_PLUGIN=ON \
    -DINSTALL_QPOISSON_RECON_PLUGIN=ON \
    -DINSTALL_QSRA_PLUGIN=ON \
    -DINSTALL_QSSAO_PLUGIN=ON && \
    make && \
    make install

WORKDIR /tmp

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt
MAINTAINER Tyson Lee Swetnam <tswetnam@cyverse.org>
