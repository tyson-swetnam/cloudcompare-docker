# NVIDIA OpenGL drivers for Linux 
FROM nvidia/opengl:1.0-glvnd-devel-ubuntu16.04

RUN export DEBIAN_FRONTEND=noninteractive

# Install PPA for dependencies
RUN apt-get update && apt-get upgrade -y --allow-unauthenticated && \
    apt-get install -y --allow-unauthenticated build-essential software-properties-common apt-utils && \
    add-apt-repository --yes ppa:webupd8team/y-ppa-manager && \
    apt-get update && \
    apt-get install -y y-ppa-manager && \
    add-apt-repository --yes ppa:george-edison55/cmake-3.x && \
    add-apt-repository --yes ppa:beineri/opt-qt-5.11.0-xenial && \
    add-apt-repository --yes ppa:ubuntu-x-swat/updates && \
    apt-get update

# Install various dependencies
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
    qt5-default \
    qt511base \
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

# Install OpenGL Drivers
RUN apt-get update && \
    apt-get install -y libglu1-mesa-dev freeglut3-dev mesa-common-dev mesa-utils

# Install various CloudCompare Plug-in dependencies
# GDAL
RUN add-apt-repository -y ppa:ubuntugis/ppa && \
    apt-get update && \ 
    apt-get install libgdal1i libgdal1-dev && \
    apt-get upgrade && \
    apt-get install -y gdal-bin python-gdal python3-gdal
#LIBLAS & Boost
RUN apt-get install -y liblas-dev liblas-bin \
    libboost-all-dev
#LASZIP
RUN git clone https://github.com/LASzip/LASzip.git && \
    git tag && \ 
    git checkout tags/3.2.2 && \
    ./configure && \
    make && \
    make install

# Install CloudCompare Trunk from Github
RUN git clone https://github.com/cloudcompare/cloudcompare && \
    cd cloudcompare && \
    git submodule init && \
    git submodule update && \
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
    -DINSTALL_QSSAO_PLUGIN=ON \
    # Plugins
    -DOPTION_USE_GDAL=ON \
    #-DLIBLAS_INCLUDE_DIR=/usr/local/lib \
    #-DLIBLAS_RELEASE_LIBRARY_FILE=
    #-DOPTION_USE_LIBLAS=ON \
    .. && \
    make && \
    make install

# Install Blender and Meshlab
#    apt-get update && \
#    apt-get install -y blender meshlab

WORKDIR /tmp

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt
MAINTAINER Tyson Lee Swetnam <tswetnam@cyverse.org>
