#----------------------------------------------------------------#
# Dockerfile to build a container for binary reverse engineering #
# and exploitation. Suitable for CTFs.                           #
#                                                                #
# To build: docker build -t superkojiman/pwnbox                  #
#----------------------------------------------------------------#

FROM phusion/baseimage
MAINTAINER superkojiman@techorganic.com

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y upgrade

#-------------------------------------#
# Install packages from Ubuntu repos  #
#-------------------------------------#
RUN apt-get install -y \
    build-essential \
    gdb \
    python-dev \
    python3-dev \
    python-pip \
    python3-pip \
    binutils-arm-linux-gnueabi \
    binfmt-support \
    binfmtc \
    gcc-arm-linux-gnueabi \
    g++-arm-linux-gnueabi \
    libc6-armhf-cross \
    gdb-multiarch \
    nasm \
    vim \
    tmux \
    git \
    binwalk \
    strace \
    ltrace \
    autoconf \
    socat \
    netcat \
    nmap \
    wget \
    man-db \
    libssl-dev \
    libffi-dev \
    libglib2.0-dev \
    libc6:i386 \
    libncurses5:i386 \
    libstdc++6:i386 \
    libc6-dev-i386

RUN apt-get -y autoremove
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#-------------------------------------#
# Install stuff from pip repos        #
#-------------------------------------#
RUN pip install \
    pycipher \
    uncompyle \
    ropgadget \
    distorm3 \
    filebytes \
    python-constraint

RUN yes | pip uninstall capstone

RUN pip install --upgrade git+https://github.com/binjitsu/binjitsu.git

RUN pip3 install pycparser \
    "psutil>=3.1.0" \
    "python-ptrace>=0.8"

#-------------------------------------#
# Install stuff from GitHub repos     #
#-------------------------------------#
RUN git clone https://github.com/aquynh/capstone /opt/capstone && \
    cd /opt/capstone && \
    git checkout -t origin/next && \
    ./make.sh install && \
    cd bindings/python && \
    python setup.py install && \
    python3 setup.py install
RUN rm -rf /opt/capstone

RUN git clone https://github.com/unicorn-engine/unicorn /opt/unicorn && \
    cd /opt/unicorn && \
    ./make.sh install && \
    cd bindings/python && \
    python setup.py install && \
    python3 setup.py install
RUN rm -rf /opt/unicorn

RUN git clone https://github.com/radare/radare2.git /opt/radare2 && \
    cd /opt/radare2 && \
    git fetch --tags && \
    git checkout $(git describe --tags $(git rev-list --tags --max-count=1)) && \
    ./sys/install.sh 

RUN git clone https://github.com/sashs/Ropper.git /opt/ropper && \
    cd /opt/ropper && \
    python setup.py install
RUN rm -rf /opt/ropper

RUN git clone https://github.com/packz/ropeme.git /opt/ropeme && \
    sed -i 's/distorm/distorm3/g' /opt/ropeme/ropeme/gadgets.py

RUN git clone https://github.com/hellman/libformatstr.git /opt/libformatstr && \
    cd /opt/libformatstr && \
    python setup.py install
RUN rm -rf /opt/libformatstr

RUN git clone https://github.com/niklasb/libc-database /opt/libc-database

RUN git clone https://github.com/longld/peda.git /opt/peda
RUN git clone https://github.com/zachriggle/pwndbg.git /opt/pwndbg
RUN git clone https://github.com/hugsy/gef.git /opt/gef

ENTRYPOINT ["/bin/bash"]
