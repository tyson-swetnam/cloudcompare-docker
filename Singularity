Bootstrap: docker
From: tswetnam/cloudcompare

%help
  Run CloudCompare: $ CloudCompare
  Run CC viewer: $ ccViewer
  Run PDAL: pdalinfo 

%apprun vncserver
  exec vncserver "${@}"

%apprun vncpasswd
  exec vncpasswd "${@}"

%apprun websockify
  exec /opt/websockify/run "${@}"

%runscript
  exec vncserver "${@}"

%environment
  export PATH=/opt/TurboVNC/bin:/opt/VirtualGL/bin:${PATH}

%post
  # Software versions
  export TURBOVNC_VERSION=2.1.2
  export VIRTUALGL_VERSION=2.5.2
  export LIBJPEG_VERSION=1.5.2

  # Get dependencies
  apt-get update
  apt-get install -y --no-install-recommends \
    emacs \
    vim \
    nano \
    lshw \
    lsb-release \
    bash-completion \
    kmod \
    iputils-ping \
    net-tools \
    ca-certificates \
    locales \
    curl \
    gcc \
    make \
    wget \
    ca-certificates \
    xauth \
    xfonts-base \
    xkb-data \
    x11-xkb-utils \
    xorg \
    openbox \
    libc6-dev \
    libxv1 \
    libxv1:i386 \
    mesa-utils \
    mesa-utils-extra \
    x11-apps \
    dbus-x11 \
    libglib2.0-tests \
    git \
    libxcb-keysyms1-dev \
    apt-transport-https

  # XFCE4 Desktop
  apt-get install -y --no-install-recommends \
    build-essential \
    software-properties-common \
    glib-2.0-dev \
    libgtk2.0-dev \
    libxfce4ui-1-dev \
    xfce4 \
    gtk3-engines-xfce \
    xfce4-notifyd \
    xfce4-taskmanager \
    xfce4-terminal \
    libgtk-3-bin
  add-apt-repository ppa:rebuntu16/other-stuff 
  apt-get update
  apt-get install -y xfce-theme-manager
  

  # Configure default locale
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
  locale-gen en_US.utf8
  /usr/sbin/update-locale LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  export LANG=en_US.UTF-8

  # Install TurboVNC
  wget https://sourceforge.net/projects/turbovnc/files/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb -q
  dpkg -i turbovnc_${TURBOVNC_VERSION}_amd64.deb
  rm turbovnc_${TURBOVNC_VERSION}_amd64.deb
 
  # Install VirtualGL 
  wget https://svwh.dl.sourceforge.net/project/libjpeg-turbo/${LIBJPEG_VERSION}/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb 
  wget https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb 
  wget https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl32_${VIRTUALGL_VERSION}_amd64.deb 
  dpkg -i libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb
  dpkg -i virtualgl_${VIRTUALGL_VERSION}_amd64.deb
  dpkg -i virtualgl32_${VIRTUALGL_VERSION}_amd64.deb
  rm -f *.deb
  
  # Install noVNC
  cd /opt
  git clone https://github.com/novnc/noVNC/

  # Install websockify
  apt-get update
  apt-get install -y --no-install-recommends \
    python \
    python-numpy
  mkdir -p /opt/websockify
  wget https://github.com/novnc/websockify/archive/master.tar.gz -q -O - | tar xzf - -C /opt/websockify --strip-components=1

  # NVIDIA Container Runtime
  apt-get install -y gnupg2
  curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
    apt-key add -
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
  curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | \
    tee /etc/apt/sources.list.d/nvidia-container-runtime.list
  apt-get update  
  apt-get install -y nvidia-container-runtime
  ldconfig
  
  # NVIDIA Drivers
  add-apt-repository ppa:graphics-drivers/ppa
  apt update
  apt install -y nvidia-396 nvidia-modprobe

  # in-container bind points for shared filesystems
  mkdir -p /extra /xdisk /uaopt /cm/shared /rsgrps

  # Clean up
  rm -rf /var/lib/apt/lists/*

%environment
  export DISPLAY=$DISPLAY

%labels
  MAINTAINER Tyson Lee Swetnam <tswetnam@cyverse.org>
  Version v0.1
