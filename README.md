## PWNBOX CTF MACHINE

### OS X VMware Fusion
1. Install Docker. You can use [Homebrew](http://brew.sh/): `brew install docker docker-compose docker-machine`
1. Create at minimuma a 4GB docker machine with 1GB of RAM: `docker-machine create --driver vmwarefusion --vmwarefusion-disk-size 4000 --vmwarefusion-memory-size 1024 ctf`
1. Set correct environment: `eval $(docker-machine env ctf)`
1. Build the pwnbox container: `docker build -t superkojiman/pwnbox .`
1. Use the included `run.sh` script to launch the pwnbox container. 
