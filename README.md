# cloudcompare-docker
Docker build for cloudcompare in linux xenial

## Instructions

Pull the container from DockerHub:

```
docker pull tswetnam/cloudcompare-docker
```

Build the container yourself:

```
git clone https://github.com/tyson-swetnam/cloudcompare-docker && \
cd cloudcompare-docker
docker build -t tswetnam/cloudcompare:latest .
```
To run the container with OpenGL on your localhost:

```
docker run -ti --rm -e "DISPLAY=$DISPLAY" -v="/tmp/.X11-unix:/tmp/.X11-unix:rw" --privileged tswetnam/cloudcompare CloudCompare
```

