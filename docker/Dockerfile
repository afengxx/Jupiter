ARG UBUNTU_VER=20.04

FROM ubuntu:${UBUNTU_VER} AS cross-compiler-builder
ARG DEBIAN_FRONTEND=noninteractive
ARG CT_VERSION=1.24.0

#default args
ARG CPU=mx5
ARG BUILD_DIR=/code/
ARG GLIB=glibc-2.23
ARG KERNEL=linux-2.6.35.3
ARG PROXY_SERVER=
ENV PKG_CONFIG_PATH=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/lib/pkgconfig/:/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/lib/pkgconfig/:/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/share/pkgconfig/
#ARG BUILD_TYPE=debug
#ARG BUILD_TYPE=release
RUN mkdir -p ${BUILD_DIR}/tarball
COPY ./configuration/gcc/${CPU}/${GLIB}/${KERNEL}/.config /${BUILD_DIR}/gcc.config
COPY ./${KERNEL}.tar.bz2 /${BUILD_DIR}/
ENV PATH=$PATH:/opt/x-tools/armv7-mx5-linux-musleabihf/bin
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install locales gperf bison flex texinfo help2man gawk libtool-bin libncurses5-dev \
        bash nano wget xz-utils build-essential autoconf unzip gettext python3 pkg-config \
        xutils-dev cmake unzip xtrans-dev git autopoint; \
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
    mv -f /${BUILD_DIR}/gcc.config .config ;./configure --enable-local && \
    make -j8 && \
    cd ${BUILD_DIR}/crosstool-ng-${CT_VERSION} && \
    ./ct-ng build && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/n/ncurses/ncurses_6.0+20160213.orig.tar.gz && \
    tar -xf ncurses_6.0+20160213.orig.tar.gz && \
    cd ncurses-6.0-20160213 && \
    ./configure --host=armv7-mx5-linux-musleabihf \
        --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ \
    --without-tests --with-termlib --with-shread && \
    make -j8 install && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/z/zlib/zlib_1.2.8.dfsg.orig.tar.gz && \
    tar -xvf zlib_1.2.8.dfsg.orig.tar.gz && \
    cd zlib-1.2.8/ && \
    CC=armv7-mx5-linux-musleabihf-gcc ./configure --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget https://www.openssl.org/source/old/1.1.1/openssl-1.1.1h.tar.gz && \
    tar -xf openssl-1.1.1h.tar.gz && \
    cd openssl-1.1.1h/ && \
    # wget https://openssl.org/source/openssl-1.0.2h.tar.gz && \
    # tar -xf openssl-1.0.2h.tar.gz && \
    # cd openssl-1.0.2h/ && \
    CC=armv7-mx5-linux-musleabihf-gcc ./Configure linux-armv4 enable-ssl3-method enable-ssl2 enable-ssl3 \
        --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/  && \
    make -j8 && make install && \
    sed -i 's/#include <linux\/socket.h>/#include <sys\/socket.h>/g' \
        /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/include/linux/netlink.h 

#currently we put whole x11 in to containers
# FROM cross-compiler-builder AS x11-builder
# RUN cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libf/libffi/libffi_3.2.1.orig.tar.gz && \
#     tar -xf libffi_3.2.1.orig.tar.gz && \
#     cd libffi-3.2.1 && \
#     ./configure --enable-builddir=armv7-mx5-linux-musleabihf --host=armv7-mx5-linux-musleabihf --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ host_alias=armv7-mx5-linux-musleabihf && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/p/pcre3/pcre3_8.38.orig.tar.gz && \
#     tar -xf pcre3_8.38.orig.tar.gz && \
#     cd pcre-8.38/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/g/glib2.0/glib2.0_2.48.2.orig.tar.xz && \
#     tar -xf glib2.0_2.48.2.orig.tar.xz && \
#     cd glib-2.48.2 && \
#     echo glib_cv_stack_grows=no>>armv7-mx5-linux.cache && \
#     echo glib_cv_uscore=no>>armv7-mx5-linux.cache && \
#     ln -s /usr/bin/python2.7 /usr/bin/python2.5 && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr \
#         --disable-option-checking --cache-file=armv7-mx5-linux.cache \
#         --with-python=/usr/bin/python3 && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/e/expat/expat_2.1.0.orig.tar.gz && \
#     tar -xf expat_2.1.0.orig.tar.gz && \
#     cd expat-2.1.0 && \
#     CC=armv7-mx5-linux-musleabihf-gcc ./configure --host=arm-linux-eabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/d/dbus/dbus_1.10.6.orig.tar.gz && \
#     tar -xf dbus_1.10.6.orig.tar.gz && \
#     cd dbus-1.10.6 && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-core/x11proto-core_7.0.31.orig.tar.gz && \
#     tar -xf x11proto-core_7.0.31.orig.tar.gz && \
#     cd xproto-7.0.31 && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxdmcp/libxdmcp_1.1.2.orig.tar.gz && \
#     tar -xf libxdmcp_1.1.2.orig.tar.gz && \
#     cd libXdmcp-1.1.2 && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxau/libxau_1.0.8.orig.tar.gz && \
#     tar -xf libxau_1.0.8.orig.tar.gz && \
#     cd libXau-1.0.8/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/universe/x/xcb-proto/xcb-proto_1.11.orig.tar.gz && \
#     tar -xf xcb-proto_1.11.orig.tar.gz && \
#     cd xcb-proto-1.11 && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \ 
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libp/libpthread-stubs/libpthread-stubs_0.3.orig.tar.gz && \
#     tar -xf libpthread-stubs_0.3.orig.tar.gz && \
#     cd libpthread-stubs-0.3/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxcb/libxcb_1.11.1.orig.tar.gz && \
#     tar -xf libxcb_1.11.1.orig.tar.gz && \
#     cd libxcb-1.11.1/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-input/x11proto-input_2.3.1.orig.tar.gz && \
#     tar -xf x11proto-input_2.3.1.orig.tar.gz && \
#     cd inputproto-2.3.1/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-xext/x11proto-xext_7.3.0.orig.tar.gz && \
#     tar -xf x11proto-xext_7.3.0.orig.tar.gz && \
#     cd xextproto-7.3.0/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/xtrans/xtrans_1.3.5.orig.tar.gz && \
#     tar -xf xtrans_1.3.5.orig.tar.gz && \
#     cd xtrans-1.3.5 && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-kb/x11proto-kb_1.0.7.orig.tar.gz && \
#     tar -xf x11proto-kb_1.0.7.orig.tar.gz && \
#     cd kbproto-1.0.7/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libx11/libx11_1.6.12.orig.tar.gz && \
#     tar -xf libx11_1.6.12.orig.tar.gz && \
#     cd libX11-1.6.12/ && \
#     echo enable_malloc0returnsnull=yes>>armv7-mx5-linux.cache && \
#     ./configure --host=armv7-mx5-linux-musleabihf --cache-file=armv7-mx5-linux.cache \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxext/libxext_1.3.3.orig.tar.gz && \
#     tar -xf libxext_1.3.3.orig.tar.gz && \
#     cd libXext-1.3.3/ && \
#     echo enable_malloc0returnsnull=yes>>armv7-mx5-linux.cache && \
#     ./configure --host=armv7-mx5-linux-musleabihf --cache-file=armv7-mx5-linux.cache \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-render/x11proto-render_0.11.1.orig.tar.gz && \
#     tar -xf x11proto-render_0.11.1.orig.tar.gz  && \
#     cd renderproto-0.11.1/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxrender/libxrender_0.9.9.orig.tar.gz && \
#     tar -xf libxrender_0.9.9.orig.tar.gz && \
#     cd libXrender-0.9.9/ && \
#     echo enable_malloc0returnsnull=yes>>armv7-mx5-linux.cache && \
#     ./configure --host=armv7-mx5-linux-musleabihf --cache-file=armv7-mx5-linux.cache \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/f/freetype/freetype_2.6.1.orig.tar.gz && \
#     tar -xf freetype_2.6.1.orig.tar.gz && \
#     cd freetype-2.6.1 && tar -xf freetype-2.6.1.tar.bz2 && cd freetype-2.6.1 && \
#     ./configure --host=armv7-mx5-linux-musleabihf CFLAGS='-std=gnu99' LD=armv7-mx5-linux-musleabihf-ld \
#         CC=armv7-mx5-linux-musleabihf-gcc AR=armv7-mx5-linux-musleabihf-ar \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     sed -i "s/\/usr\/local/\/opt\/x-tools\/armv7-mx5-linux-musleabihf\/armv7-mx5-linux-musleabihf\/sysroot\/usr/g" \
#         /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/lib/pkgconfig/freetype2.pc && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libf/libfontenc/libfontenc_1.1.3.orig.tar.gz && \
#     tar -xf libfontenc_1.1.3.orig.tar.gz && \
#     cd libfontenc-1.1.3 && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-fonts/x11proto-fonts_2.1.3.orig.tar.gz && \
#     tar -xf x11proto-fonts_2.1.3.orig.tar.gz && \
#     cd fontsproto-2.1.3/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxfont/libxfont_1.5.1.orig.tar.gz && \
#     tar -xf libxfont_1.5.1.orig.tar.gz && \
#     cd libXfont-1.5.1/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-xf86bigfont/x11proto-xf86bigfont_1.2.0.orig.tar.gz && \
#     tar -xvf x11proto-xf86bigfont_1.2.0.orig.tar.gz && \
#     cd xf86bigfontproto-1.2.0/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-xcmisc/x11proto-xcmisc_1.2.2.orig.tar.gz && \
#     tar -xf x11proto-xcmisc_1.2.2.orig.tar.gz && \
#     cd xcmiscproto-1.2.2/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 install && \ 
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-scrnsaver/x11proto-scrnsaver_1.2.2.orig.tar.gz && \
#     tar -xf x11proto-scrnsaver_1.2.2.orig.tar.gz && \
#     cd scrnsaverproto-1.2.2/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-bigreqs/x11proto-bigreqs_1.1.2.orig.tar.gz && \
#     tar -xf x11proto-bigreqs_1.1.2.orig.tar.gz && \
#     cd bigreqsproto-1.1.2/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-resource/x11proto-resource_1.2.0.orig.tar.gz && \
#     tar -xf x11proto-resource_1.2.0.orig.tar.gz && \
#     cd resourceproto-1.2.0/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-randr/x11proto-randr_1.5.0.orig.tar.gz && \
#     tar -xf x11proto-randr_1.5.0.orig.tar.gz && \
#     cd randrproto-1.5.0/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-xinerama/x11proto-xinerama_1.2.1.orig.tar.gz && \
#     tar -xf x11proto-xinerama_1.2.1.orig.tar.gz && \
#     cd xineramaproto-1.2.1 && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-fixes/x11proto-fixes_5.0.orig.tar.gz && \
#     tar -xf x11proto-fixes_5.0.orig.tar.gz && \
#     cd fixesproto-5.0/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-damage/x11proto-damage_1.2.1.orig.tar.gz && \
#     tar -xf x11proto-damage_1.2.1.orig.tar.gz && \
#     cd damageproto-1.2.1 && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxfixes/libxfixes_5.0.1.orig.tar.gz && \
#     tar -xf libxfixes_5.0.1.orig.tar.gz && \
#     cd libXfixes-5.0.1 && \
#     ./configure --host=armv7-mx5-linux-musleabihf CFLAGS='-DHAVE__XEATDATAWORDS' \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxi/libxi_1.7.6.orig.tar.gz && \
#     tar -xf libxi_1.7.6.orig.tar.gz && \
#     cd libXi-1.7.6/ && \
#     echo enable_malloc0returnsnull=yes>>armv7-mx5-linux.cache && \
#     ./configure --host=armv7-mx5-linux-musleabihf --cache-file=armv7-mx5-linux.cache \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-record/x11proto-record_1.14.2.orig.tar.gz && \
#     tar -xf x11proto-record_1.14.2.orig.tar.gz && \
#     cd recordproto-1.14.2 && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxtst/libxtst_1.2.2.orig.tar.gz && \
#     tar -xf libxtst_1.2.2.orig.tar.gz && \
#     cd libXtst-1.2.2/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf CFLAGS='-DHAVE__XEATDATAWORDS' \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxinerama/libxinerama_1.1.3.orig.tar.gz && \
#     tar -xf libxinerama_1.1.3.orig.tar.gz && \
#     cd libXinerama-1.1.3/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxrandr/libxrandr_1.5.0.orig.tar.gz && \
#     tar -xvf libxrandr_1.5.0.orig.tar.gz && \
#     cd libXrandr-1.5.0/ && \
#     echo enable_malloc0returnsnull=yes>>armv7-mx5-linux.cache && \
#     ./configure --host=armv7-mx5-linux-musleabihf --cache-file=armv7-mx5-linux.cache \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/xinput/xinput_1.6.2.orig.tar.gz && \
#     tar -xvf xinput_1.6.2.orig.tar.gz && \
#     cd xinput-1.6.2/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install

# FROM x11-builder AS xserver-builder
# RUN cd ${BUILD_DIR} && \    
#     wget http://archive.ubuntu.com/ubuntu/pool/main/p/pixman/pixman_0.33.6.orig.tar.gz && \
#     tar -xf pixman_0.33.6.orig.tar.gz && \
#     cd pixman-0.33.6/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/x11proto-video/x11proto-video_2.3.2.orig.tar.gz && \
#     tar -xf x11proto-video_2.3.2.orig.tar.gz && \
#     cd videoproto-2.3.2/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/x/xorgproto/xorgproto_2018.4.orig.tar.gz && \
#     tar -xf xorgproto_2018.4.orig.tar.gz && \
#     cd xorgproto-2018.4/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxfont/libxfont_2.0.3.orig.tar.gz && \
#     tar -xf libxfont_2.0.3.orig.tar.gz && \
#     cd libXfont2-2.0.3/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxkbfile/libxkbfile_1.0.9.orig.tar.gz && \
#     tar -xf libxkbfile_1.0.9.orig.tar.gz && \
#     cd libxkbfile-1.0.9 && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libx/libxkbcommon/libxkbcommon_0.5.0.orig.tar.gz && \
#     tar -xf libxkbcommon_0.5.0.orig.tar.gz && \
#     cd libxkbcommon-0.5.0/ && \
#     ./autogen.sh && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget https://github.com/tinycorelinux/tinyx/archive/master.zip -O tinyx.zip && \
#     unzip tinyx.zip && \
#     cd tinyx-master/ && \
#     autoreconf -i && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ \
#         --disable-screensaver --disable-xdmcp --disable-xdm-auth-1 --disable-dbe \
#         --disable-xf86bigfont --disable-dpms && \
#     # use tinycore linux instead
#     # wget http://archive.ubuntu.com/ubuntu/pool/main/x/xorg-server/xorg-server_1.19.6.orig.tar.gz && \
#     # tar -xf xorg-server_1.19.6.orig.tar.gz && \
#     # cd xorg-server-1.19.6 && \
#     # ./configure --host=armv7-mx5-linux-musleabihf \
#     #     --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ \
#     #     --enable-docs=no --enable-devel-docs=no --enable-unit-tests=no --enable-aiglx=no \
#     #     --enable-glx-tls=no --disable-registry --disable-composite --disable-mitshm \
#     #     --disable-record --disable-dga --enable-dri=no --enable-dri2=no --disable-xf86vidmode \
#     #     --disable-dpms --enable-xaa=no --enable-xorg=no --enable-vgahw=no --enable-vbe=no \
#     #     --enable-int10-module=no --enable-libdrm=no --disable-clientids --enable-pciaccess=no \
#     #     --enable-dmx=no --enable-xnest=no --enable-xquartz=no --enable-standalone-xpbproxy=no \
#     #     --enable-xwin=no --enable-kdrive=yes --enable-xephyr=no --enable-xfake=no \
#     #     --enable-xfbdev=yes --enable-kdrive-kbd=yes --enable-kdrive-mouse=yes \
#     #     --enable-kdrive-evdev=yes --enable-unix-transport --enable-tcp-transport \
#     #     --disable-glx --enable-sparkle=no --disable-screensaver --disable-xvmc --disable-xdmcp \
#     #     --disable-xdm-auth-1 --disable-xinerama --disable-xace --enable-xselinux=no \
#     #     --enable-xcsecurity=no && \
#     make -j8 && make install

# FROM xserver-builder AS vnc-builder
# RUN cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libv/libvncserver/libvncserver_0.9.13+dfsg.orig.tar.xz && \
#     tar -xf libvncserver_0.9.13+dfsg.orig.tar.xz && \
#     cd libvncserver-LibVNCServer-0.9.13/ && \
#     echo "set(COMPILER_PREFIX "armv7-mx5-linux-musleabihf")" >> cmake/cross && \
#     echo "find_program(CMAKE_C_COMPILER NAMES \${COMPILER_PREFIX}-gcc)" >> cmake/cross && \
#     echo "find_program(CMAKE_C_COMPILER NAMES \${COMPILER_PREFIX}-g++)" >> cmake/cross && \
#     echo "SET(USER_ROOT_PATH \${CMAKE_CURRENT_SOURCE_DIR}/deps)" >> cmake/cross && \
#     echo "SET(CMAKE_FIND_ROOT_PATH /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot \${USER_ROOT_PATH})" >> cmake/cross && \
#     echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> cmake/cross && \
#     echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> cmake/cross && \
#     echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> cmake/cross && \
#     echo "set(CMAKE_INSTALL_LIBDIR /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/lib)" >> cmake/cross && \
#     echo "set(CMAKE_INSTALL_INCLUDEDIR /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/include)" >> cmake/cross && \
#     cmake ./ -DCMAKE_TOOLCHAIN_FILE=cmake/cross -DWITH_OPENSSL=ON -DWITH_GCRYPT=OFF && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/universe/x/x11vnc/x11vnc_0.9.16.orig.tar.gz && \
#     tar -xvf x11vnc_0.9.16.orig.tar.gz && \
#     cd x11vnc-0.9.16/ && \
#     ./autogen.sh --host=armv7-mx5-linux-musleabihf \
#         --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#    make -j8 && make install

# #currently we put qt into container
# FROM vnc-builder AS qt-builder
# ARG CPU
# COPY ./configuration/qt/linux-${CPU}-musleabihf-g++ /${BUILD_DIR}/linux-${CPU}-musleabihf-g++
# RUN cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/universe/t/tslib/tslib_1.21.orig.tar.xz && \
#     tar -xf tslib_1.21.orig.tar.xz && \
#     cd tslib-1.21/ && \
#     echo "#define EVIOCGPROP(len)        _IOC(_IOC_READ, 'E', 0x09, len)        /* get device properties */" >> src/tslib.h && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#          --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget --no-proxy http://mirrors.ustc.edu.cn/qtproject/archive/qt/5.12/5.12.10/single/qt-everywhere-src-5.12.10.tar.xz && \
#     tar -xf qt-everywhere-src-5.12.10.tar.xz && \
#     cd qt-everywhere-src-5.12.10 && \
#     mv -f /${BUILD_DIR}/linux-${CPU}-musleabihf-g++ ./qtbase/mkspecs/devices/ && \
#     PKG_CONFIG_PATH="" PKG_CONFIG_SYSROOT_DIR="/" ./configure -sysroot /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/ \
#         -release -linuxfb -xcb -device linux-mx5-musleabihf-g++ -device-option CROSS_COMPILE=armv7-mx5-linux-musleabihf- \
#         -opensource -confirm-license -eventfd -inotify -no-opengl -pkg-config -force-asserts \
#         -tslib -nomake tests -no-use-gold-linker -recheck -glib \
#         -hostprefix /opt/x-tools/armv7-mx5-linux-musleabihf/ \
#         -extprefix /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ \
#         -prefix /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ \
#         -skip qtquickcontrols -skip qtactiveqt -skip qtandroidextras -skip qtdeclarative -skip qtmacextras -skip qtserialport \
#         -skip qtconnectivity -skip qtdoc -skip qtgraphicaleffects -skip qtlocation -skip qtmultimedia \
#         -skip qtsensors -skip qttools -skip qtscript -skip qtwayland -skip qtwinextras -no-mtdev -no-eglfs -verbose \
#         -no-feature-qt3d-opengl-renderer -no-feature-qt3d-render -no-feature-qt3d-simd-avx2 -no-feature-qt3d-simd-sse2 \
#         -no-feature-qt3d-animation -no-feature-qt3d-extras -no-feature-qt3d-input -no-feature-qt3d-logic && \
#    make -j8 && make install

# FROM qt-builder AS go-builder
# RUN cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/libg/libgpg-error/libgpg-error_1.37.orig.tar.bz2 && \
#     tar -xf libgpg-error_1.37.orig.tar.bz2 && \
#     cd libgpg-error-1.37/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#          --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/liba/libassuan/libassuan_2.5.3.orig.tar.bz2 && \
#     tar -xf libassuan_2.5.3.orig.tar.bz2 && \
#     cd libassuan-2.5.3/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#          --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ \
#          --with-libgpg-error-prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install && \
#     cd ${BUILD_DIR} && \
#     wget http://archive.ubuntu.com/ubuntu/pool/main/g/gpgme1.0/gpgme1.0_1.13.1.orig.tar.bz2 && \
#     tar -xf gpgme1.0_1.13.1.orig.tar.bz2 && \
#     cd gpgme-1.13.1/ && \
#     ./configure --host=armv7-mx5-linux-musleabihf \
#          --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ \
#          --with-libgpg-error-prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ \
#          --with-libassuan-prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
#     make -j8 && make install 

FROM cross-compiler-builder AS misc-builder
ARG CPU
ARG BUILD_DIR
COPY ./configuration/busybox/${CPU}/.config /${BUILD_DIR}/busybox.config
RUN cd ${BUILD_DIR} && \
    #kernel 2.6.35 doesn't support SYS_renameat2
    # wget https://github.com/libfuse/libfuse/releases/download/fuse-3.10.1/fuse-3.10.1.tar.xz && \
    # tar -xf fuse-3.10.1.tar.xz && \
    # cd fuse-3.10.1 && sed -i '/^udev/,$ s/^/#/' util/meson.build && \
    # echo <<< EOL \
    #     $'[binaries]\n'\
    #     $'c = \'armv7-mx5-linux-musleabihf-gcc\'\n' \
    #     $'cpp = \'armv7-mx5-linux-musleabihf-g++\'\n' \
    #     $'ar = \'armv7-mx5-linux-musleabihf-ar\'\n' \
    #     $'strip = \'armv7-mx5-linux-musleabihf-strip\'\n' \
    #     $'pkgconfig = \'pkg-config\'\n' \
    #     $'[host_machine]\n' \
    #     $'system = \'linux\'\n' \
    #     $'cpu_family = \'arm\'\n' \
    #     $'cpu = \'armv7\'\n' \
    #     $'endian = \'little\'\n' \
    # >> ./cross; \
    # meson buildir --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr \
    #     --cross-file cross -Dexamples=false -Ddisable-mtab=true; \
    # echo <<< EOL \
    #     $'#ifndef PR_SET_NO_NEW_PRIVS\n' \
    #     $'#define PR_SET_NO_NEW_PRIVS     38\n' \
    #     $'#define PR_GET_NO_NEW_PRIVS     39\n' \
    #     $'#define PR_GET_TID_ADDRESS      40\n' \
    #     $'#endif\n' \
    # >> ./buildir/config.h; \
    # ninja -C buildir/ install && \
    # cd ${BUILD_DIR} && \
    wget https://busybox.net/downloads/busybox-1.32.0.tar.bz2 && \
    tar -xf busybox-1.32.0.tar.bz2 && \
    cd busybox-1.32.0 && \
    sed -i 's/reboot(magic);//g' init/init.c && \
    mv -f /${BUILD_DIR}/busybox.config .config  && \
    # make ARCH=arm CROSS_COMPILE=armv7-mx5-linux-musleabihf- defconfig && \
    make ARCH=arm CROSS_COMPILE=armv7-mx5-linux-musleabihf- -j8 && \
    make ARCH=arm CROSS_COMPILE=armv7-mx5-linux-musleabihf- \
        install CONFIG_PREFIX=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/ && \
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/p/procps/procps_3.3.16.orig.tar.xz && \
    tar -xf procps_3.3.16.orig.tar.xz && \
    cd procps-3.3.16/ && ./autogen.sh && \
    ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes ./configure --host=armv7-mx5-linux-musleabihf \
        --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
    make -j8 && make install && \
    cd ${BUILD_DIR} && \
    wget https://github.com/OpenRC/openrc/archive/0.42.1.zip -O openrc.zip && \
    unzip openrc.zip && \
    cd openrc-0.42.1 && \
    sed -i 's/reboot(cmd)/exit(EXIT_SUCCESS)/g' src/rc/openrc-init.c && \
    MKBASHCOMP=no MKNET=no MKPREFIX=no MKPKGCONFIG=no MKSELINUX=no \
        MKSTATICLIBS=no MKSYSVINIT=no MKTERMCAP=ncurses MKZSHCOMP=no \
        SH=/bin/sh DESTDIR=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/ \
        CC=armv7-mx5-linux-musleabihf-gcc make install -j8 && \
    #overwrite tar to support lxc
    cd ${BUILD_DIR} && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/t/tar/tar_1.30+dfsg.orig.tar.xz && \
    tar -xf tar_1.30+dfsg.orig.tar.xz && \
    cd tar-1.30/ && \
    ./configure --host=armv7-mx5-linux-musleabihf \
        --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ && \
    make -j8 && make install && \
    # wget https://mmonit.com/monit/dist/monit-5.27.1.tar.gz && \
    # tar -xvf monit-5.27.1.tar.gz && \
    # cd monit-5.27.1 && \
    # ./configure --host=armv7-mx5-linux-musleabihf \
    #     --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ \
    #     --without-pam --without-ssl --enable-optimized && \
    # make -j8 && make install && \
    # echo 'set httpd port 3813' >> /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/etc/monitrc; \
    # echo 'allow veex:monit' >> /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/etc/monitrc; \
    # echo 'include /usr/etc/monit/conf.d/*' >> /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/etc/monitrc && \
    # echo 'include /home/monit/conf.d/*' >> /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/etc/monitrc && \
    # mkdir -p /opt/x-tools/armv7-mx5-linux-musleabihf/sysroot/usr/etc/monit/conf.d/ && \
    cd ${BUILD_DIR} && \
    git clone https://github.com/karelzak/util-linux.git --depth 1 -b v2.36.1 && \
    cd util-linux && ./autogen.sh && \
    ./configure --without-systemd --without-python --disable-all-programs \
        --enable-libblkid --enable-libmount --enable-mount \
        --enable-static-programs=nsenter,unshare --enable-nsenter --enable-unshare \
        --host=armv7-mx5-linux-musleabihf \
        --prefix=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr && \
    sed -i 's/mount_LDFLAGS = \$(SUID_LDFLAGS) \$(AM_LDFLAGS)/mount_LDFLAGS = \$(SUID_LDFLAGS) \$(AM_LDFLAGS) -lblkid/g' sys-utils/Makemodule.am && \
    sed -i 's/umount_LDFLAGS = \$(SUID_LDFLAGS) \$(AM_LDFLAGS)/umount_LDFLAGS = \$(SUID_LDFLAGS) \$(AM_LDFLAGS) -lblkid/g' sys-utils/Makemodule.am && \
    make -j8 && make install && \
    rm -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/bin/nsenter && \
    rm -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/bin/unshare && \
    mv /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/bin/unshare.static \
        /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/bin/unshare && \
    mv /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/bin/nsenter.static \
        /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/bin/nsenter && \
    cd ${BUILD_DIR} && \
    git clone https://github.com/c6supper/jchroot.git  --depth 1 && \
    cd jchroot && \
    CC=armv7-mx5-linux-musleabihf-gcc LDFLAGS="-static" make && \
    cp -rf jchroot /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/bin/

FROM misc-builder AS lxc-builder
ARG CPU
ARG BUILD_DIR
RUN cd ${BUILD_DIR} && \
    # wget https://linuxcontainers.org/downloads/lxc/lxc-2.1.1.tar.gz && \
    # tar -xf lxc-2.1.1.tar.gz && \
    # cd lxc-2.1.1 && \
    git clone git://github.com/lxc/lxc --depth 1 -b stable-4.0 && \
    cd lxc && ./autogen.sh && \
    ./configure --host=armv7-mx5-linux-musleabihf with_distro="noNeed" \
        --enable-static=no --enable-shared=yes \
        --prefix=/usr/local/jrootfs/usr --localstatedir=/var \
        --disable-doc --disable-api-docs --disable-examples --disable-tests with_distro="noNeed"; \
    # echo "#define HAVE_SETNS (1)" >> src/config.h; \
    echo "#ifndef __aligned_u64" >> src/config.h; \
    echo "#define __aligned_u64 __u64 __attribute__((aligned(8)))" >> src/config.h; \
    echo "#endif" >> src/config.h && \
    make -j8 && \
    DESTDIR=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot make install && \
    cd /opt/ && tar -Jcf x-tool.tar.xz x-tools

FROM lxc-builder AS rootfs-builder
ARG BUILD_DIR
RUN cd ${BUILD_DIR} && \
    git clone https://github.com/c6supper/jupiter_jrootfs.git --depth=1 jrootfs && \
    cd jrootfs && rm -rf .git .gitignore LICENSE README.md && \
    cp -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/debug-root/usr/bin \
        ./usr/local/jrootfs/ && \
    cp -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/bin \
        ./usr/local/jrootfs/ && \
    cp -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/sbin \
        ./usr/local/jrootfs/ && \
    cp -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/lib \
        ./usr/local/jrootfs/ && \
    cp -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/libexec \
        ./usr/local/jrootfs/ && \
    cp -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/sbin \
        ./usr/local/jrootfs/usr/ && \
    cp -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/bin \
        ./usr/local/jrootfs/usr/ && \
    cp -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/lib \
        ./usr/local/jrootfs/usr/ && \
    cp -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/libexec \
        ./usr/local/jrootfs/usr/ && \        
    cp -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/ssl \
        ./usr/local/jrootfs/usr/ && \
    cp -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/local/jrootfs/* \
        ./usr/local/jrootfs/ && \
    find \( -iname .keep -o -iname '*.a' -o -iname '*.spec' \
        -o -iname '*.la' -o -iname '*.o' -o -iname include \
        -o -iname pkgconfig -o -iname '*.h' \) | xargs rm -rf || true && \
    find | xargs armv7-mx5-linux-musleabihf-strip -s || true && \
    tar -cJf jrootfs.tar.xz ./usr && mv jrootfs.tar.xz /opt/

FROM ubuntu:${UBUNTU_VER} AS building-env
ARG DEBIAN_FRONTEND=noninteractive
COPY --from=rootfs-builder /opt/x-tool.tar.xz /opt/
ENV JUPITER_DIR /jupiter
COPY docker-entrypoint.sh $JUPITER_DIR/
ENV JUPITER_INITIALIZED_MARK $JUPITER_DIR/patched
RUN mkdir -p $JUPITER_DIR
COPY --from=rootfs-builder /opt/jrootfs.tar.xz $JUPITER_DIR/
ENV PATH=$PATH:/opt/x-tools/armv7-mx5-linux-musleabihf/bin:/opt/x-tools/armv7-mx5-linux-musleabihf/fakebin
ENV PKG_CONFIG_PATH=/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/lib/pkgconfig/:/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/lib/pkgconfig/:/opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/share/pkgconfig/
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install bash xz-utils locales; \
        echo 'export PATH=$PATH:/opt/x-tools/armv7-mx5-linux-musleabihf/bin:/opt/x-tools/armv7-mx5-linux-musleabihf/fakebin' >> ~/.bashrc; \
        echo 'export LC_ALL="en_US.UTF-8"' >> ~/.bashrc && \
    echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash && \
    echo 'over'

# initilization for the first time
ENTRYPOINT ["/jupiter/docker-entrypoint.sh"]

CMD ["/usr/bin/bash"]
