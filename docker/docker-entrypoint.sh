#!/bin/sh

set -ex

patch_conf() {
    
    cd /opt/ && tar -xf x-tool.tar.xz;rm -f x-tool.tar.xz;
    ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime;
    export DEBIAN_FRONTEND=noninteractive;
    apt install -y rename locales libc6-i386 lib32stdc++6 autoconf wget libtool libtool-bin autopoint \
    subversion git cmake astyle libglib2.0-0:i386 gettext python3 libdbus-1-dev unzip bison \
    vim;
    dpkg-reconfigure --frontend noninteractive tzdata ;
    locale-gen en_US.UTF-8;
    mkdir -p /opt/x-tools/armv7-mx5-linux-musleabihf/fakebin/;
    find /opt/x-tools/armv7-mx5-linux-musleabihf/bin -name 'arm*' -exec ln -vs "{}" /opt/x-tools/armv7-mx5-linux-musleabihf/fakebin/ ';';
    cd /opt/x-tools/armv7-mx5-linux-musleabihf/fakebin/ && rename 's/armv7-mx5-linux-musleabihf/arm-none-linux-gnueabi/' * ;
    
    # envsubst "$defined_envs" < "/etc/guacamole/guacamole.properties.template" > "/etc/guacamole/guacamole.properties"
}

pack_rootfs() {
    cd ${JUPITER_DIR} && \
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
    cp -rf /opt/x-tools/armv7-mx5-linux-musleabihf/armv7-mx5-linux-musleabihf/sysroot/usr/share/lxc \
    ./usr/local/jrootfs/usr/share/ && \
    find \( -iname .keep -o -iname '*.a' -o -iname '*.spec' \
    -o -iname '*.la' -o -iname '*.o' -o -iname include \
    -o -iname pkgconfig -o -iname '*.h' \) | xargs rm -rf || true && \
    find | xargs armv7-mx5-linux-musleabihf-strip -s || true && \
    tar -cJf jrootfs.tar.xz ./usr && mv jrootfs.tar.xz ../ && cd ../ && rm -rf jrootfs
}

if [ ! -f "$JUPITER_INITIALIZED_MARK" ]; then
    patch_conf
    touch $JUPITER_INITIALIZED_MARK
    echo
    echo 'building env init process complete; ready for start up.'
    echo
else
    echo
    echo 'Skipping initialization'
    echo
    echo 'Packing rootfs'
    pack_rootfs
    echo 'done'
    echo
fi

/bin/sh -c "$@"
