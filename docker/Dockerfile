ARG UBUNTU_VER=20.04

FROM ubuntu:${UBUNTU_VER} AS builder
ARG DEBIAN_FRONTEND=noninteractive
ARG CT_VERSION=1.24.0

#default args
ARG CPU=mx5
ARG GLIB=glibc-2.23
ARG KERNEL=linux-2.6.35.3
ARG PROXY_SERVER=
ARG BUILD_DIR=/code
# ENV http_proxy=${PROXY_SERVER}
# ENV https_proxy=${PROXY_SERVER}
# ENV ftp_proxy=${PROXY_SERVER}
#ARG BUILD_TYPE=debug
#ARG BUILD_TYPE=release
RUN mkdir -p ${BUILD_DIR} 
COPY ./${CPU}/${GLIB}/${KERNEL}/.config /${BUILD_DIR}/.config
COPY ./${KERNEL}.tar.bz2 /${BUILD_DIR}/
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install gperf bison flex texinfo help2man gawk libtool-bin libncurses5-dev \
        bash nano wget xz-utils build-essential autoconf unzip; \
        echo "https_proxy = $PROXY_SERVER" >> /etc/wgetrc; \
        echo "http_proxy = $PROXY_SERVER" >> /etc/wgetrc; \
        echo "ftp_proxy = $PROXY_SERVER" >> /etc/wgetrc; \
        echo "use_proxy = on" >> /etc/wgetrc; \
    cd ${BUILD_DIR} && \
    wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CT_VERSION}.tar.bz2 && \
    tar -xf crosstool-ng-${CT_VERSION}.tar.bz2 && \
    cd ${BUILD_DIR} && tar -xf ${KERNEL}.tar.bz2 && \
    cd ${BUILD_DIR}/crosstool-ng-${CT_VERSION} && \
    mv -f /${BUILD_DIR}/.config .config ;./configure --enable-local && \
    make -j4 && \
    cd ${BUILD_DIR}/crosstool-ng-${CT_VERSION} && \
    ./ct-ng build

 
FROM ubuntu:${UBUNTU_VER} AS building-env
COPY --from=builder /root/x-tools /root/

RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install bash nano; \
        echo 'export PATH=$PATH:/root/armv7-mx5-linux-gnueabi/bin' >> ~/.bashrc && \
    echo 'over'

CMD ["/usr/bin/bash"]
