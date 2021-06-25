### About
Pwnbox is a Docker container with tools for binary reverse engineering and exploitation. It's primarily geared towards Capture The Flag competitions.

### Installation
You can grab the container from Docker Hub: `docker pull wardwouts/pwnbox`
 1. Make sure you have Docker installed.
 1. Optional: Create a `./rc` directory. Your custom configuration files in `$HOME` go here. Eg: `.gdbinit`, `.radare2rc`, `.bashrc`, `.vimrc`, etc. The contents of `rc` gets copied into `/root` on the container.
 1. Get the `pwnbox` script from [https://github.com/wardwouts/pwnbox/blob/master/run.sh](https://github.com/wardwouts/pwnbox/blob/master/pwnbox).
 1. Execute `pwnbox <ctfname>` script which creates a container named `<ctfname>`. Eg:
```
 $ ./pwnbox defcon
CTF Name from argument: defcon
Creating container
080ca7f41f34f80ac2bd630633a5b0e21895a7c53a6bf06b252e71d078fd4896
                         ______
___________      ___________  /___________  __
___  __ \_ | /| / /_  __ \_  __ \  __ \_  |/_/
__  /_/ /_ |/ |/ /_  / / /  /_/ / /_/ /_>  <
_  .___/____/|__/ /_/ /_//_.___/\____//_/|_|
/_/                originally by superkojiman
/_/                       forked by wardwouts

To detach container without stopping it type:
CTRL-p CTRL-q
root@defcon:/#
```
 1. Works with this .bashrc snippet to automatically get a ctfname from the $cdj value:
```
export cdj=$(cat $HOME/.cdj)

cdj(){
        cd $(cat $HOME/.cdj)
}

scdj(){
        if [ -e $HOME/cdj ]; then
                rm $HOME/cdj
        fi
        ln -s $(pwd) $HOME/cdj
        pwd > $HOME/.cdj
        export cdj=$(cat $HOME/.cdj)
}
```
 1. If neither the argument `<ctfname>` is given nor `$cdj` is set, it takes the last part of the current path as ctfname. (So `/home/username/workdir` would become ctfname `workdir`.
 2. The `$cdj` directory or current directory will be mounted under `/root/work` in the container upon container creation.
 3. To start and/or reattach an existing container simply run the `pwnbox` script again with the same ctf name.
 4. The container engine can be set to podman by setting the following environment variable:
        DOCKER_COMMAND=podman

### Limitations
 1. If you need to edit anything in /proc, you must edit `pwnbox` to use the `--privileged` option to `docker` instead of `--cap-add=SYS_PTRACE`.

### Go forth, and CTF
•_•)

( •_•)>⌐■-■

(⌐■_■)
