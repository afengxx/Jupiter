ARG UBUNTU_VER=20.04

FROM ubuntu:${UBUNTU_VER} AS builder
ARG DEBIAN_FRONTEND=noninteractive
ARG CT_VERSION=1.24.0

#default args
ARG CPU=mx5
ARG GLIB=glibc-2.23
ARG KERNEL=linux-2.6.35.3
ARG PROXY_SERVER=
ARG BUILD_DIR=/code/
ENV PKG_CONFIG_PATH=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/lib/pkgconfig/:/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/lib/pkgconfig/:/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/share/pkgconfig/
#ARG BUILD_TYPE=debug
#ARG BUILD_TYPE=release
RUN mkdir -p ${BUILD_DIR}
COPY ./${CPU}/${GLIB}/${KERNEL}/.config /${BUILD_DIR}/.config
COPY ./${KERNEL}.tar.bz2 /${BUILD_DIR}/
ENV PATH=$PATH:/root/x-tools/armv7-mx5-linux-gnueabi/bin
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install locales gperf bison flex texinfo help2man gawk libtool-bin libncurses5-dev \
        bash nano wget xz-utils build-essential autoconf unzip gettext python3 pkg-config; \
    echo "https_proxy = $PROXY_SERVER" >> /etc/wgetrc; \
        echo "http_proxy = $PROXY_SERVER" >> /etc/wgetrc; \
        echo "ftp_proxy = $PROXY_SERVER" >> /etc/wgetrc; \
        echo "use_proxy = on" >> /etc/wgetrc; \
    locale-gen en_US.UTF-8 && echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash && \
    cd ${BUILD_DIR} && \
    wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${CT_VERSION}.tar.bz2 && \
    tar -xf crosstool-ng-${CT_VERSION}.tar.bz2 && \
    cd ${BUILD_DIR} && tar -xf ${KERNEL}.tar.bz2 && \
    cd ${BUILD_DIR}/crosstool-ng-${CT_VERSION} && \
    mv -f /${BUILD_DIR}/.config .config ;./configure --enable-local && \
    make -j4 && \
    cd ${BUILD_DIR}/crosstool-ng-${CT_VERSION} && \
    ./ct-ng build && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/z/zlib/zlib_1.2.8.dfsg.orig.tar.gz && \
    tar -xvf zlib_1.2.8.dfsg.orig.tar.gz && \
    cd zlib-1.2.8/ && \
    CC=armv7-mx5-linux-gnueabi-gcc ./configure --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/libf/libffi/libffi_3.2.1.orig.tar.gz && \
    tar -xf libffi_3.2.1.orig.tar.gz && \
    cd libffi-3.2.1 && \
    ./configure --enable-builddir=armv7-mx5-linux-gnueabi --host=armv7-mx5-linux-gnueabi --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ host_alias=armv7-mx5-linux-gnueabi && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/p/pcre3/pcre3_8.38.orig.tar.gz && \
    tar -xf pcre3_8.38.orig.tar.gz && \
    cd pcre-8.38/ && \
    ./configure --host=armv7-mx5-linux-gnueabi --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/g/glib2.0/glib2.0_2.48.2.orig.tar.xz && \
    tar -xf glib2.0_2.48.2.orig.tar.xz && \
    cd glib-2.48.2 && \
    echo glib_cv_stack_grows=no>>armv7-mx5-linux.cache && \
    echo glib_cv_uscore=no>>armv7-mx5-linux.cache && \
    ln -s /usr/bin/python2.7 /usr/bin/python2.5 && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot \
        --disable-option-checking --cache-file=armv7-mx5-linux.cache \
        --with-python=/usr/bin/python3 && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    # wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/openssl_1.1.1f.orig.tar.gz && \
    # tar -xf openssl_1.1.1f.orig.tar.gz && \
    # cd openssl-1.1.1f/ && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/openssl_1.0.2g.orig.tar.gz && \
    tar -xf openssl_1.0.2g.orig.tar.gz && \
    cd openssl-1.0.2g/ && \
    CC=armv7-mx5-linux-gnueabi-gcc ./Configure linux-armv4 enable-ssl2 enable-ssl3 \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/  && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/e/expat/expat_2.1.0.orig.tar.gz && \
    tar -xf expat_2.1.0.orig.tar.gz && \
    cd expat-2.1.0 && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/d/dbus/dbus_1.10.6.orig.tar.gz && \
    tar -xf dbus_1.10.6.orig.tar.gz && \
    cd dbus-1.10.6 && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-core/x11proto-core_7.0.31.orig.tar.gz && \
    tar -xf x11proto-core_7.0.31.orig.tar.gz && \
    cd xproto-7.0.31 && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxdmcp/libxdmcp_1.1.2.orig.tar.gz && \
    tar -xf libxdmcp_1.1.2.orig.tar.gz && \
    cd libXdmcp-1.1.2 && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxau/libxau_1.0.8.orig.tar.gz && \
    tar -xf libxau_1.0.8.orig.tar.gz && \
    cd libXau-1.0.8/ && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/universe/x/xcb-proto/xcb-proto_1.11.orig.tar.gz && \
    tar -xf xcb-proto_1.11.orig.tar.gz && \
    cd xcb-proto-1.11 && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \ wget http://archive.ubuntu.com/ubuntu/pool/main/libp/libpthread-stubs/libpthread-stubs_0.3.orig.tar.gz && \
    tar -xf libpthread-stubs_0.3.orig.tar.gz && \
    cd libpthread-stubs-0.3/ && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxcb/libxcb_1.11.1.orig.tar.gz && \
    tar -xf libxcb_1.11.1.orig.tar.gz && \
    cd libxcb-1.11.1/ && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-input/x11proto-input_2.3.1.orig.tar.gz && \
    tar -xf x11proto-input_2.3.1.orig.tar.gz && \
    cd inputproto-2.3.1/ && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-xext/x11proto-xext_7.3.0.orig.tar.gz && \
    tar -xf x11proto-xext_7.3.0.orig.tar.gz && \
    cd xextproto-7.3.0/ && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/x/xtrans/xtrans_1.3.5.orig.tar.gz && \
    tar -xf xtrans_1.3.5.orig.tar.gz && \
    cd xtrans-1.3.5 && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-kb/x11proto-kb_1.0.7.orig.tar.gz && \
    tar -xf x11proto-kb_1.0.7.orig.tar.gz && \
    cd kbproto-1.0.7/ && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libx11/libx11_1.6.3.orig.tar.gz && \
    tar -xf libx11_1.6.3.orig.tar.gz && \
    cd libX11-1.6.3/ && \
    echo enable_malloc0returnsnull=yes>>armv7-mx5-linux.cache && \
    ./configure --host=armv7-mx5-linux-gnueabi --cache-file=armv7-mx5-linux.cache \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxext/libxext_1.3.3.orig.tar.gz && \
    tar -xf libxext_1.3.3.orig.tar.gz && \
    cd libXext-1.3.3/ && \
    echo enable_malloc0returnsnull=yes>>armv7-mx5-linux.cache && \
    ./configure --host=armv7-mx5-linux-gnueabi --cache-file=armv7-mx5-linux.cache \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-render/x11proto-render_0.11.1.orig.tar.gz && \
    tar -xf x11proto-render_0.11.1.orig.tar.gz  && \
    cd renderproto-0.11.1/ && \
    ./configure --host=armv7-mx5-linux-gnueabi \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxrender/libxrender_0.9.9.orig.tar.gz && \
    tar -xf libxrender_0.9.9.orig.tar.gz && \
    cd libXrender-0.9.9/ && \
    echo enable_malloc0returnsnull=yes>>armv7-mx5-linux.cache && \
    ./configure --host=armv7-mx5-linux-gnueabi --cache-file=armv7-mx5-linux.cache \
        --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
    make -j8 && make install && \
    cd /root/ && tar -Jcf x-tool.tar.xz x-tools
# RUN wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxinerama/libxinerama_1.1.3.orig.tar.gz && \
#     tar -xf libxinerama_1.1.3.orig.tar.gz && \
#     cd libXinerama-1.1.3/ && \
#     ./configure --host=armv7-mx5-linux-gnueabi \
#         --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
#     make -j8 && make install;

# RUN wget http://archive.ubuntu.com/ubuntu/pool/main/x/xinput/xinput_1.6.2.orig.tar.gz && \
#     tar -xvf xinput_1.6.2.orig.tar.gz && \
#     cd xinput-1.6.2/ && \
#     ./configure --host=armv7-mx5-linux-gnueabi \
#         --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ && \
#     make -j8 && make install;

FROM ubuntu:${UBUNTU_VER} AS building-env
ARG DEBIAN_FRONTEND=noninteractive
COPY --from=builder /root/x-tool.tar.xz /root/
ENV JUPITER_DIR /jupiter
ENV JUPITER_INITIALIZED_MARK $JUPITER_DIR/patched
RUN mkdir -p $JUPITER_DIR
ENV PATH=$PATH:/root/x-tools/armv7-mx5-linux-gnueabi/bin:/root/x-tools/armv7-mx5-linux-gnueabi/fakebin
ENV PKG_CONFIG_PATH=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/lib/pkgconfig/:/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/lib/pkgconfig/:/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/share/pkgconfig/
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install bash nano xz-utils locales; \
        echo 'export PATH=$PATH:/root/x-tools/armv7-mx5-linux-gnueabi/bin:/root/x-tools/armv7-mx5-linux-gnueabi/fakebin' >> ~/.bashrc; \
        echo 'export LC_ALL="en_US.UTF-8"' >> ~/.bashrc && \
    echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash && \
    echo 'over'

# initilization for the first time
ENTRYPOINT ["/jupiter/docker-entrypoint.sh"]

CMD ["/usr/bin/bash"]
