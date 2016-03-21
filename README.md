## PWNBOX CTF MACHINE

### Docker Hub:
You can grab the container from Docker Hub: `docker pull superkojiman/pwnbox`
 1. Create a `rc` directory. Your custom configuration files in $HOME go here. Eg: .gdbinit, .radare2rc, .bashrc, .vimrc, etc... This gets mounted to /root on the container.
 1. Create a `work` directory. Copy the binaries you want to reverse/debug here. This gets mounted to /root/work on the container. 
 1. Run the following command to start the container with those directories mounted: 

```
docker run -it --rm \
    -v ${PWD}/rc:/root \
    -v ${PWD}/work:/work \
    -h pwnbox \
    --security-opt seccomp:unconfined \
    superkojiman/pwnbox
```

### OS X VMware Fusion
To build the container locally using the Dockerfile: 
 1. Install Docker. You can use [Homebrew](http://brew.sh/): `brew install docker docker-compose docker-machine`
 1. Create at minimum a 4GB docker machine with 1GB of RAM: `docker-machine create --driver vmwarefusion --vmwarefusion-disk-size 4000 --vmwarefusion-memory-size 1024 ctf`
 1. Set correct environment: `eval $(docker-machine env ctf)`
 1. Build the pwnbox container: `docker build -t superkojiman/pwnbox .`
 1. Use the included `run.sh` script to launch the pwnbox container. 
