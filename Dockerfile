FROM ubuntu:16.04

RUN export DEBIAN_FRONTEND=noninteractive

# Install PPA for dependencies
RUN apt-get update && apt-get upgrade -y --allow-unauthenticated && \
    apt-get install -y --allow-unauthenticated build-essential software-properties-common apt-utils && \
    add-apt-repository --yes ppa:webupd8team/y-ppa-manager && \
    apt-get update && \
    apt-get install -y y-ppa-manager && \
    add-apt-repository --yes ppa:george-edison55/cmake-3.x && \
    add-apt-repository --yes ppa:beineri/opt-qt571-xenial && \
    add-apt-repository --yes ppa:ubuntu-x-swat/updates && \
    apt-get update

# Install various dependencies
RUN apt-get install -y --allow-unauthenticated \
    clang \
    cmake \
    curl \
    ffmpeg \
    gcc \
    git \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libboost-all-dev \
    libcgal-dev \
    libcgal-qt5-dev \
    libeigen3-dev \
    libfreenect-dev \
    libfreetype6-dev \
    libgdal1-dev \
    libpng12-dev \
    libproj-dev \
    libqt5svg5-dev \
    libqt5opengl5-dev \
    libswscale-dev \
    libtbb-dev \
    libxerces-c-dev \
    libzmq3-dev \
    module-init-tools \
    pkg-config \
    python \
    python-dev \
    python3 \
    # qt5-default \
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

RUN ln -s /usr/lib/x86_64-linux-gnu/libvtkCommonCore-6.2.so /usr/lib/libvtkproj4.so

# Install OpenGL Drivers
RUN apt-get update && \
    apt-get install -y libglu1-mesa-dev freeglut3-dev mesa-common-dev mesa-utils

# GDAL
RUN add-apt-repository --yes ppa:ubuntugis/ppa && \
    apt-get update && \
    apt-get install -y libgdal-dev libgdal1i libgdal1-dev && \
    apt-get upgrade && \
    apt-get install -y gdal-bin python-gdal python3-gdal libgeotiff-dev libjsoncpp-dev python-numpy

#LASZIP
RUN git clone https://github.com/LASzip/LASzip && \
    cd LASzip && \
    git tag && \ 
    git checkout tags/3.2.2 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    #./configure && \
    make && \
    make install

# EIGEN
RUN wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/eigen3/3.3.4-2/eigen3_3.3.4.orig.tar.bz2 && \
    tar xvjf eigen* && \
    cd eigen-eigen* && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
    .. && \
    make && \
    make install
    
#PDAL
RUN wget https://github.com/PDAL/PDAL/releases/download/1.7.2/PDAL-1.7.2-src.tar.gz && \
    tar xvzf PDAL-1.7.2-src.tar.gz && \
    cd PDAL-1.7.2-src && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
    -DWITH_TESTS=OFF \
    -DWITH_LASZIP=ON \
    -DBUILD_PLUGIN_PYTHON=OFF \
    -DBUILD_PLUGIN_PGPOINTCLOUD=OFF \
    .. && \
    make && \
    make install

# PCL
#RUN add-apt-repository --yes ppa:v-launchpad-jochen-sprickerhof-de/pcl && \
#    apt-get update && \
#    apt-get install -y libpcl-all libpcl-dev

RUN /sbin/ldconfig

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
    -DCOMPILE_CC_CORE_LIB_WITH_CGAL=ON \
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
    -DPOISSON_RECON_WITH_OPEN_MP=ON \
    -DINSTALL_QSRA_PLUGIN=ON \
    -DINSTALL_QSSAO_PLUGIN=ON \
    -DWITH_FFMPEG_SUPPORT=ON \
    -DFFMPEG_INCLUDE_DIR=/usr/include/x86_64-linux-gnu \
    -DFFMPEG_LIBRARY_DIR=/usr/lib/x86_64-linux-gnu \
    -DOPTION_USE_GDAL=ON \
    -DOPTION_PDAL_LAS=ON \
    -DJSON_ROOT_DIR=/usr/include/jsoncpp \
    -DOPTION_USE_DXF_LIB=ON \
    -DOPTION_USE_SHAPE_LIB=ON \
    -DOPTION_USE_DXF_LIB=ON \
    #-DINSTALL_QPCL_PLUGIN=ON \
    .. && \
    make && \
    make install

RUN cd && rm -rf eigen3_3.3.4.orig.tar.bz2 && \
    rm -rf PDAL-1.7.2-src.tar.gz

ENV LD_LIBRARY_PATH /opt/qt57/lib/

VOLUME /tmp/.X11-unix

# build info
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt
MAINTAINER Tyson Lee Swetnam <tswetnam@cyverse.org>
