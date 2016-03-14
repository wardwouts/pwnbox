#!/usr/bin/env bash

# Run superkojiman/pwnbox container in docker. 
# Store your .gdbinit, .radare2rc, .vimrc, etc in rc as it gets mounted to /root
# Store the binaries you want to pwn/reverse in ./work as it gets mounted to /root/work

if [[ ! -d ${PWD}/rc ]]; then
    mkdir -p ${PWD}/rc
fi

if [[ ! -d ${PWD}/work ]]; then 
    mkdir -p ${PWD}/work
fi

docker run -it --rm \
    -v ${PWD}/rc:/root \
    -v ${PWD}/work:/root/work \
    -h pwnbox \
    --security-opt seccomp:unconfined \
    superkojiman/pwnbox
