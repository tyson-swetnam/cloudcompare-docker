# cloudcompare-docker

Docker build for cloudcompare in linux xenial

## Instructions

Pull this container from DockerHub:

```
docker pull tswetnam/cloudcompare-docker:latest
```

Build the container yourself:

```
git clone https://github.com/tyson-swetnam/cloudcompare-docker && \
cd cloudcompare-docker
docker build -t tswetnam/cloudcompare:latest .
```

## Linux

To run a [Docker GUI container](http://wiki.ros.org/docker/Tutorials/GUI#The_simple_way) with OpenGL on Intel graphics (e.g. Atmosphere Virtual Machines, Intel NUCs):

**NOT SECURE**

```
xhost +local:root
docker run -ti --rm -e "DISPLAY=unix$DISPLAY" -v="/tmp/.X11-unix:/tmp/.X11-unix:rw" -v /home/$USER/:/temp --privileged tswetnam/cloudcompare-docker:0.1 CloudCompare
```

## Mac OS X

https://cntnr.io/running-guis-with-docker-on-mac-os-x-a14df6a76efc 

## Singularity

You can run the Docker container with Singularity (for HPC use).

```
singularity exec docker://tswetnam/cloudcompare-docker:latest CloudCompare
```
