#----------------------------------------------------------------#
# Dockerfile to build a container for binary reverse engineering #
# and exploitation. Suitable for CTFs.                           #
#                                                                #
# See https://github.com/wardwouts/pwnbox for details.        #
#                                                                #
# To build: docker build -t wardwouts/pwnbox                  #
#----------------------------------------------------------------#

FROM debian:buster-slim
MAINTAINER ward@wouts.nl

ENV DEBIAN_FRONTEND noninteractive

# Set LC_ALL to a safe value so pip doesn't break
ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=C.UTF-8

RUN dpkg --add-architecture i386
RUN apt-get update \
    && apt-get -o Dpkg::Options::="--force-confnew" upgrade -y

#-------------------------------------#
# Install packages from Ubuntu repos  #
#-------------------------------------#
RUN mkdir -p /usr/share/man/man1 \
    && apt-get -o Dpkg::Options::="--force-confnew" install -y \
        sudo \
        apt-utils \
        locales \
        build-essential \
        gcc-multilib \
        g++-multilib \
        gdb \
        gdb-multiarch \
        python3-dev \
        python3-pip \
        ipython3 \
        default-jdk-headless \
        default-jdk \
        net-tools \
        nasm \
        cmake \
        rubygems \
        ruby-dev \
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
        tcpdump \
        exiftool \
        squashfs-tools \
        unzip \
        upx-ucl \
        man-db \
        manpages-dev \
        libtool-bin \
        bison \
        gperf \
        libseccomp-dev \
        libini-config-dev \
        libssl-dev \
        libffi-dev \
        libc6-dbg \
        libglib2.0-dev \
        libc6:i386 \
        libc6-dbg:i386 \
        libncurses5:i386 \
        libstdc++6:i386 \
        libc6-dev-i386 \
        binutils

RUN apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && locale-gen en_US.UTF-8 \
    && update-locale

#-------------------------------------#
# Install stuff from pip repos        #
#-------------------------------------#
RUN pip3 install --upgrade pip \
    && pip3 install \
        r2pipe \
        scapy \
        python-constraint \
        pycipher \
        uncompyle \
        pipenv \
        manticore[native] \
        ropper \
        xortool \
        meson \
        ninja \
        frida-tools \
        frida

# install pwntools 3
RUN pip3 install --upgrade pwntools

#-------------------------------------#
# Install stuff from GitHub repos     #
#-------------------------------------#
# install rizin
RUN git clone https://github.com/rizinorg/rizin /opt/rizin && \
    cd /opt/rizin && \
    meson build && \
    ninja -C build && \
    ninja -C build install

# install libc-database
RUN git clone https://github.com/niklasb/libc-database /opt/libc-database

# install peda
RUN git clone https://github.com/longld/peda.git /opt/peda

# install gef
RUN git clone https://github.com/hugsy/gef.git /opt/gef

# install pwndbg
RUN git clone https://github.com/pwndbg/pwndbg.git /opt/pwndbg && \
    cd /opt/pwndbg && \
    ./setup.sh

# install libseccomp
RUN git clone https://github.com/seccomp/libseccomp.git /opt/libseccomp && \
    cd /opt/libseccomp && \
    ./autogen.sh && ./configure && make && make install

# install PinCTF
RUN git clone https://github.com/ChrisTheCoolHut/PinCTF.git /opt/PinCTF && \
    cd /opt/PinCTF && \
    ./installPin.sh

# install one_gadget seccomp-tools
RUN gem install one_gadget seccomp-tools

ENTRYPOINT ["/bin/bash"]
