# CloudCompare

Docker build for [CloudCompare](https://www.danielgm.net/cc/) based on [NVIDIA OpenGL Ubuntu](https://hub.docker.com/r/nvidia/opengl) containers.

[CloudCompare GitHub](https://github.com/cloudcompare/cloudcompare)

<<<<<<< HEAD
There are two types of containers here.
=======
image            | description                               | size   | metrics | build status 
---------------- | ----------------------------------------- | ------ | ------- | --------------
[![DockerHub](https://img.shields.io/badge/DockerHub-brightgreen.svg?style=popout&logo=Docker)](https://hub.docker.com/r/tswetnam/cloudcompare)  | CloudCompare w/ NVIDIA OpenGL Ubuntu 22.04 base | [![](https://images.microbadger.com/badges/image/tswetnam/cloudcompare.svg)](https://microbadger.com/images/tswetnam/cloudcompare) | [![](https://img.shields.io/docker/pulls/tswetnam/cloudcompare.svg)](https://hub.docker.com/r/tswetnam/cloudcompare)  |  [![](https://img.shields.io/docker/automated/tswetnam/cloudcompare.svg)](https://hub.docker.com/r/tswetnam/cloudcompare/builds)
>>>>>>> 0672003 (created 22.04)

First, there is an `OpenGL` image tag which uses the [`nvidia/opengl`](https://hub.docker.com/r/nvidia/opengl) docker image

Second, there is a `CudaGL` image tag which uses the [`nvidia/cudagl`](https://hub.docker.com/r/nvidia/cudagl) docker image

The main difference between the two containers is the addition of CUDA

## Instructions

Pull the latest container from Docker-Hub:

```
docker pull harbor.cyverse.org/vice/xpra/cloudcompare:22.04
```

Build the container yourself:

```
git clone https://github.com/tyson-swetnam/cloudcompare-docker && \
cd cloudcompare-docker/desktop/22.04
docker build -t  harbor.cyverse.org/vice/xpra/cloudcompare:22.04
```

## Linux

To run a [Docker GUI container](http://wiki.ros.org/docker/Tutorials/GUI#The_simple_way) with OpenGL on Intel graphics (e.g. Atmosphere Virtual Machines, Intel NUCs):

To run Xpra on a machine with an NVIDIA GPU installed: 

```
docker run --gpus all --rm -it -p 9876:9876 -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY -e XAUTHORITY -e NVIDIA_DRIVER_CAPABILITIES=all harbor.cyverse.org/vice/xpra/cloudcompare:22.04 
```

## Singularity

You can run the Docker container with Singularity (for HPC use).

```
singularity exec docker://harbor.cyverse.org/vice/xpra/cloudcompare:22.04 vglrun CloudCompare
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
singularity exec --nv --bind /xdisk/$USER docker://harbor.cyverse.org/vice/xpra/cloudcompare:22.04 vglrun CloudCompare
```

If you get an error, you may need to reset the DISPLAY.

Find out what the local display is:

```
echo $DISPLAY
```

Run Docker container as shell

```
singularity shell --bind /xdisk/$USER docker://harbor.cyverse.org/vice/xpra/cloudcompare:22.04
```

From the Singularity shell:

```
export DISPLAY=localhost:50.0
```

Start CloudCompare

```
CloudCompare
```
