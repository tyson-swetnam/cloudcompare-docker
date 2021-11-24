FROM tswetnam/xpra:cudagl-20.04

USER root

RUN export DEBIAN_FRONTEND=noninteractive

# Install PPA for various CloudCompare dependencies

RUN apt-get update && apt-get upgrade -y --allow-unauthenticated && \
    apt-get update && apt-get install -y --allow-unauthenticated build-essential software-properties-common apt-utils && \
    add-apt-repository --yes ppa:webupd8team/y-ppa-manager && \
    apt-get update && \
    apt-get install -y y-ppa-manager && \
    add-apt-repository --yes ppa:beineri/opt-qt-5.12.10-focal && \
    add-apt-repository --yes ppa:ubuntu-x-swat/updates && \
    apt-get update

# Install various dependencies
RUN apt-get update && apt-get install -y --allow-unauthenticated \
    clang \
    cmake \
    curl \
    ffmpeg \
    gcc \
    git \
    htop \
    kmod \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libboost-all-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libqt5svg5-dev \
    libcgal-qt5-dev \
    libeigen3-dev \
    libfreenect-dev \
    libfreetype6-dev \
    libgdal-dev \
    libpng-dev \
    libproj-dev \
    libswscale-dev \
    libtbb-dev \
    libxerces-c-dev \
    libzmq3-dev \
    #module-init-tools \
    pkg-config \
    python \
    python-dev \
    qt5-default \
    qt512base \
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
    apt-get install -y build-essential gdal-bin python3-gdal libgeotiff-dev libjsoncpp-dev python-numpy

# Compile CGAL
RUN cd /opt && git clone https://github.com/CGAL/cgal && \
    cd cgal && \
    git tag && \
    git checkout tags/v5.2.1 && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_PREFIX_PATH=/usr/lib/x86_64-linux-gnu/cmake/CGAL \
    -DCMAKE_BUILD_TYPE=Release \
    -DWITH_CGAL_Core=ON \
    -DWITH_CGAL_Qt5=ON \
    -DWITH_CGAL_ImageIO=ON .. && \   
    #./configure && \
    make -j48 && \
    make -j48 install
    
# Compile LASZIP
RUN cd /opt && git clone https://github.com/LASzip/LASzip && \
    cd LASzip && \
    git tag && \ 
    git checkout tags/3.4.3 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    #./configure && \
    make -j48 && \
    make -j48 install

# Compile EIGEN
RUN cd /opt && wget https://gitlab.com/libeigen/eigen/-/archive/3.3.7/eigen-3.3.7.tar.bz2 && \
    tar xvjf eigen* && \
    cd eigen-* && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j48 && \
    make -j48 install
    
# Compile PDAL
RUN cd /opt && wget https://github.com/PDAL/PDAL/releases/download/2.2.0/PDAL-2.2.0-src.tar.gz && \
    tar xvzf PDAL-2.2.0-src.tar.gz && \
    cd PDAL-2.2.0-src && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
    -DWITH_TESTS=OFF \
    -DWITH_LASZIP=ON \
    -DBUILD_PLUGIN_PYTHON=OFF \
    -DBUILD_PLUGIN_PGPOINTCLOUD=OFF \
    .. && \
    make -j48 && \
    make -j48 install

# Compile PCL
RUN apt-get update && apt-get install libflann-dev -y
RUN cd /opt && git clone https://github.com/PointCloudLibrary/pcl pcl-trunk && \
    cd /opt/pcl-trunk && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo .. && \
    make -j48 && \
    make -j48 install

# CC suggestion
RUN /sbin/ldconfig -v

# REady to install and compile CloudCompare
ENV LD_LIBRARY_PATH /opt/qt512/lib/
RUN apt-get update
RUN cd /opt && git clone --recursive https://github.com/cloudcompare/CloudCompare.git CloudCompare && \
    cd /opt/CloudCompare && git checkout tags/v2.11.3 && \
    cd /opt/CloudCompare/ && mkdir build && \
    cd build && \
    # set release and compiler type
    cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_COMPILER=clang++ \
    # set path for QT 5.12
    -DQT5_ROOT_PATH=/opt/qt512/ \	    
    -DEIGEN_ROOT_DIR=/usr/local/include/eigen3/ \
    -DCOMPILE_CC_CORE_LIB_WITH_TBB=ON \
   # set plugins
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
    # agisoft photoscan (metashape)
    -DINSTALL_QPHOTOSCAN_IO_PLUGIN=ON \
    # poisson recon
    -DINSTALL_QPOISSON_RECON_PLUGIN=ON \
    -DPOISSON_RECON_WITH_OPEN_MP=ON \
    # sra
    -DINSTALL_QSRA_PLUGIN=ON \
    -DINSTALL_QSSAO_PLUGIN=ON \
    # ffmpeg
    -DWITH_FFMPEG_SUPPORT=ON \
    -DFFMPEG_INCLUDE_DIR=/usr/include/x86_64-linux-gnu \
    -DFFMPEG_LIBRARY_DIR=/usr/lib/x86_64-linux-gnu \
    # gdal
    -DOPTION_USE_GDAL=ON \
    # pdal
    -DPLUGIN_IO_QPDAL=TRUE \
    -DOPTION_PDAL_LAS=ON \
    # json
    -DJSON_ROOT_DIR=/usr/include/jsoncpp \
    -DOPTION_USE_DXF_LIB=ON \
    -DOPTION_USE_SHAPE_LIB=ON \
    -DOPTION_USE_DXF_LIB=ON \
    # pcl
    -DINSTALL_QPCL_PLUGIN=ON \
    # build with CGAL - getting an error 2021-05-27
    -DCCCORELIB_USE_CGAL=ON \
    #-DCOMPILE_CC_CORE_LIB_WITH_CGAL=ON \
    .. && \
    make -j48 && \
    make -j48 install

ENV LD_LIBRARY_PATH=/usr/local/bin   

# VirtualGL 
RUN cd /tmp && wget https://sourceforge.net/projects/virtualgl/files/2.6.3/virtualgl_2.6.3_amd64.deb/download -O virtualgl_2.6.3_amd64.deb && dpkg -i --force-depends virtualgl_2.6.3_amd64.deb && apt-get -f install


# Agisoft Metashape
RUN cd /opt && wget https://s3-eu-west-1.amazonaws.com/download.agisoft.com/metashape-pro_1_7_3_amd64.tar.gz && \
    tar xvf metashape-pro_1_7_3_amd64.tar.gz && \
    cd /opt/metashape-pro && wget https://s3-eu-west-1.amazonaws.com/download.agisoft.com/Metashape-1.7.3-cp35.cp36.cp37.cp38-abi3-linux_x86_64.whl && \
    wget https://s3-eu-west-1.amazonaws.com/download.agisoft.com/metashape-java-api-1.7.3.zip && unzip *.zip

# Create Desktop Icons

COPY cc.desktop /usr/share/applications/
COPY metashape.desktop /usr/share/applications/

RUN cd /opt && rm -rf *.tar.bz2 && \
    rm -rf *.tar.gz && rm -rf *.deb

USER user

RUN mkdir /home/user/.irods && echo '{"irods_host": "data.cyverse.org", "irods_port": 1247, "irods_user_name": "$IPLANT_USER", "irods_zone_name": "iplant"}' | tee  > /home/user/.irods/irods_environment.json

VOLUME /tmp/.X11-unix

CMD xpra start :10 --video-encoders=nvenc --bind-tcp=0.0.0.0:9876 --html=on --start-child="vglrun CloudCompare" --exit-with-children=no --daemon=no --xvfb="/usr/bin/Xvfb +extension Composite -screen 0 1920x1080x24+32 -nolisten tcp -noreset" --pulseaudio=no --notifications=no --bell=no 

