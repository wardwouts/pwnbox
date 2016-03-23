## PWNBOX CTF MACHINE

### Docker Hub:
You can grab the container from Docker Hub: `docker pull superkojiman/pwnbox`
 1. Create a `rc` directory. Your custom configuration files in $HOME go here. Eg: .gdbinit, .radare2rc, .bashrc, .vimrc, etc... This gets mounted to /root on the container.
 1. Create a `work` directory. Copy the binaries you want to reverse/debug here. This gets mounted to /root/work on the container. 
 1. Run the included `run.sh` script which starts the container with those directories mounted. Here's what `run.sh` does: 

```
docker run -it --rm \
    -v ${PWD}/rc:/root \
    -v ${PWD}/work:/work \
    -h pwnbox \
    --privileged \
    superkojiman/pwnbox
```

### Limitations
 1. By default, `--privileged` is passed to `docker` so you can edit files in `/proc`, and allow `ptrace`. 
 1. If you don't care about editing files in `/proc`, you can swap out `--privileged` with `--security-opt seccomp:unconfined` instead, which will allow `ptrace`.
 1. `core` files are empty when created in a mounted directory. So you'll need to set `/proc/sys/kernel/core\_pattern` to where you want `core` files dumped. Eg: `/tmp/core`


### OS X VMware Fusion
To build the container locally using the Dockerfile: 
 1. Install Docker. You can use [Homebrew](http://brew.sh/): `brew install docker docker-compose docker-machine`
 1. Create at minimum a 4GB docker machine with 1GB of RAM: `docker-machine create --driver vmwarefusion --vmwarefusion-disk-size 4000 --vmwarefusion-memory-size 1024 ctf`
 1. Set correct environment: `eval $(docker-machine env ctf)`
 1. Build the pwnbox container: `docker build -t superkojiman/pwnbox .`
 1. Use the included `run.sh` script to launch the pwnbox container. 
