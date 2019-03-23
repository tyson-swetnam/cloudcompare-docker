# CloudCompare

Docker build for [CloudCompare](https://www.danielgm.net/cc/) Ubuntu Xenial.

[CloudCompare Github](https://github.com/cloudcompare/cloudcompare)

image            | description                               | size   | metrics | build status 
---------------- | ----------------------------------------- | ------ | ------- | --------------
[CloudCompare](https://hub.docker.com/r/tswetnam/cloudcompare) | CloudCompare w/ NVIDIA OpenGL Ubuntu 18.04 base | [![](https://images.microbadger.com/badges/image/tswetnam/cloudcompare.svg)](https://microbadger.com/images/tswetnam/cloudcompare) | [![](https://img.shields.io/docker/pulls/tswetnam/cloudcompare.svg)](https://hub.docker.com/r/tswetnam/cloudcompare)  |  [![](https://img.shields.io/docker/automated/tswetnam/cloudcompare.svg)](https://hub.docker.com/r/tswetnam/cloudcompare/builds)


## Instructions

Pull the latest container from Docker-Hub:

```
docker pull tswetnam/cloudcompare:latest
```

Build the container yourself:

```
git clone https://github.com/tyson-swetnam/cloudcompare-docker && \
cd cloudcompare-docker
docker build -t tswetnam/cloudcompare:latest .
```

## Windows

TBD

## Linux

To run a [Docker GUI container](http://wiki.ros.org/docker/Tutorials/GUI#The_simple_way) with OpenGL on Intel graphics (e.g. Atmosphere Virtual Machines, Intel NUCs):

**NOT SECURE**

```
xhost +local:root
docker run -ti --rm -e "DISPLAY=unix$DISPLAY" -v="/tmp/.X11-unix:/tmp/.X11-unix:rw" -v /home/$USER/:/temp --privileged tswetnam/cloudcompare:latest CloudCompare
```

This method is okay on CyVerse Atmosphere, where you're running in your own Web Desktop environment. 

## Mac OS X

https://cntnr.io/running-guis-with-docker-on-mac-os-x-a14df6a76efc 

## Singularity

You can run the Docker container with Singularity (for HPC use).

```
singularity exec docker://tswetnam/cloudcompare:latest CloudCompare
```

# University of Arizona HPC

Log into the HPC

```
ssh -X $USER@hpc.arizona.edu
```

Select a system from the Bastion

```
ocelote -X
```

Start a GPU node

```
qsub -X -I -N cloudcompare -m bea -W group_list=$GROUP -q windfall -l select=1:ncpus=28:mem=168gb:ngpus=1 -l cput=1:0:0 -l walltime=1:0:0
```

Load Cuda and Singularity

```
module load cuda80/gtk
module load singularity
```

Run the container and start CloudCompare

```
singularity exec --bind /xdisk/$USER docker://tswetnam/cloudcompare:latest CloudCompare
```

If you get an error, you may need to reset the DISPLAY.

Find out what the local display is:

```
echo $DISPLAY
```

Run Docker container as shell

```
singularity shell --bind /xdisk/$USER docker://tswetnam/cloudcompare:latest
```

From the Singularity shell:

```
export DISPLAY=localhost:50.0
```

Start CloudCompare

```
CloudCompare
```
