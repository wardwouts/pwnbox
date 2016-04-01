## PWNBOX CTF MACHINE

### Docker Hub:
You can grab the container from Docker Hub: `docker pull superkojiman/pwnbox`
 1. Optional: Create a ./rc directory. Your custom configuration files in $HOME go here. Eg: .gdbinit, .radare2rc, .bashrc, .vimrc, etc. The contents of rc gets copied into /root on the container. 
 1. Run the included `run.sh` script which creates a container named `ctfname-pwnbox`. Eg:

        $ ./run.sh defcon
        d477d2bbcbf9a37f733fc335e012e61af102b7f344854d552c5871cc94dcac26
        Let's pwn stuff!
        root@defcon-pwnbox:/# exit
        $ docker ps -a
        CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS                      PORTS               NAMES
        d477d2bbcbf9        superkojiman/pwnbox   "/bin/bash"         24 seconds ago      Exited (0) 12 seconds ago                       defcon-pwnbox

### Limitations
 1. If you need to edit anything in /proc, you must edit `run.sh` to use the `--privileged` option to `docker` instead of `--security-opt seccomp:unconfined`. 
 1. The container is designed to be isolated so no directories are mounted from the host. This allows you to have multiple containers hosting files from different CTFs. 

### OS X VMware Fusion
To build the container locally using the Dockerfile: 
 1. Install Docker. You can use [Homebrew](http://brew.sh/): `brew install docker docker-compose docker-machine`
 1. Create at minimum a 4GB docker machine with 1GB of RAM: `docker-machine create --driver vmwarefusion --vmwarefusion-disk-size 4000 --vmwarefusion-memory-size 1000 --vmwarefusion-no-share ctf`. If you plan on having multiple CTF containers for this Docker machine, make the disk size larger. 
 1. Set the correct environment: `eval $(docker-machine env ctf)`
 1. Build the pwnbox container: `docker build -t superkojiman/pwnbox .`
 1. Use the included `run.sh` script to launch the pwnbox container. 

### Go forth, and CTF 
•_•)

( •_•)>⌐■-■

(⌐■_■)
