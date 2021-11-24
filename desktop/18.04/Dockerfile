FROM tswetnam/xpra:bionic

MAINTAINER Tyson Lee Swetnam <tswetnam@cyverse.org>

USER root
RUN export DEBIAN_FRONTEND=noninteractive

# Install PPA for dependencies
RUN apt-get update && apt-get upgrade -y --allow-unauthenticated && \
    apt-get install -y --allow-unauthenticated build-essential software-properties-common apt-utils && \
    add-apt-repository --yes ppa:webupd8team/y-ppa-manager && \
    apt-get update && \
    apt-get install -y y-ppa-manager && \
    add-apt-repository --yes ppa:beineri/opt-qt-5.11.3-bionic && \
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
    htop \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libboost-all-dev \
    libcgal-dev \
    libcgal-qt5-dev \
    libeigen3-dev \
    libfreenect-dev \
    libfreetype6-dev \
    libgdal-dev \
    libpng-dev \
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
    qt5-default \
    qt511base \
    qttools5-dev \
    rsync \
    unzip \
    zip \
    zlib1g-dev \
    openjdk-8-jdk \
    openjdk-8-jre-headless \
    vim \
    nano \
    wget \
    libxpm-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/lib/x86_64-linux-gnu/libvtkCommonCore-6.2.so /usr/lib/libvtkproj4.so

# Install OpenGL Drivers
RUN apt-get update && \
    apt-get install -y --allow-unauthenticated libglu1-mesa-dev freeglut3-dev mesa-common-dev mesa-utils

# GDAL
RUN add-apt-repository --yes ppa:ubuntugis/ppa && \
    apt-get update && \
    apt-get install -y gdal-bin python-gdal python3-gdal libgeotiff-dev libjsoncpp-dev python-numpy

#LASZIP
RUN cd /opt && git clone https://github.com/LASzip/LASzip && \
    cd LASzip && \
    git tag && \ 
    git checkout tags/3.4.3 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    #./configure && \
    make && \
    make install

# EIGEN
RUN cd /opt && wget https://gitlab.com/libeigen/eigen/-/archive/3.3.7/eigen-3.3.7.tar.bz2 && \
    tar xvjf eigen* && \
    cd eigen-* && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install
    
#PDAL
RUN cd /opt && wget https://github.com/PDAL/PDAL/releases/download/2.0.1/PDAL-2.0.1-src.tar.gz && \
    tar xvzf PDAL-2.0.1-src.tar.gz && \
    cd PDAL-2.0.1-src && \
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

# PCL -- need to test for bionic
#RUN add-apt-repository --yes ppa:v-launchpad-jochen-sprickerhof-de/pcl && \
#    apt-get update && \
#    apt-get install -y libpcl-all libpcl-dev

# CC compiling suggestion
RUN /sbin/ldconfig -v

# Install CloudCompare Trunk from Github
ENV LD_LIBRARY_PATH /opt/qt511/lib/
RUN cd /opt && git clone --recursive https://github.com/cloudcompare/CloudCompare.git  
RUN cd /opt/CloudCompare && git checkout tags/v2.10.1 && git submodule init && \
    git submodule update && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
    -DOPTION_MP_BUILD=ON \
    -DQT5_ROOT_PATH=/opt/qt511/ \	    
    -DEIGEN_ROOT_DIR=/usr/local/include/eigen3/ \
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

RUN cd /tmp && wget https://sourceforge.net/projects/virtualgl/files/2.6.3/virtualgl_2.6.3_amd64.deb/download -O virtualgl_2.6.3_amd64.deb && dpkg -i --force-depends virtualgl_2.6.3_amd64.deb && apt-get -f install

RUN cd /opt && rm -rf *.tar.bz2 && \
    rm -rf *.tar.gz && rm -rf *.deb

WORKDIR /home/user/

USER user

CMD xpra start --bind-tcp=0.0.0.0:9876 --html=on --start-child=CloudCompare --exit-with-children=no --daemon=no --xvfb="/usr/bin/Xvfb +extension Composite -screen 0 1920x1080x24+32 -nolisten tcp -noreset" --pulseaudio=no --notifications=no --bell=no :100  --video-encoders=nvenc


