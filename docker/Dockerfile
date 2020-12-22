ARG UBUNTU_VER=14.04

FROM ubuntu:${UBUNTU_VER} AS builder
ARG DEBIAN_FRONTEND=noninteractive
ARG CT_VERSION=1.24.0

#default args
ARG CPU=mx5
ARG GLIB=glibc-2.23
ARG KERNEL=linux-2.6.35.3

#ARG BUILD_TYPE=debug
#ARG BUILD_TYPE=release
COPY ./${CPU}/${GLIB}/${KERNEL}/.config /.config
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install gperf bison flex texinfo help2man gawk libtool libncurses5-dev \
        bash nano wget xz-utils build-essential autoconf && \
    cd ${CODE_DIR} && wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CT_VERSION}.tar.bz2 && \
    tar -xf crosstool-ng-${CT_VERSION}.tar.bz2 && cd crosstool-ng-${CT_VERSION} && \
    mv -f /.config .config && ./configure --enable-local && make -j4 && ./ct-ng build

 
# FROM builder-${BUILD_TYPE} AS final
# RUN echo "VAR is equal to ${VAR}"

CMD ["/usr/bin/bash"]