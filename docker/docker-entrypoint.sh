#!/bin/sh

set -ex

patch_conf() {

  cd /root/ && tar -xf x-tools.tar.xz && rm -f x-tools.tar.xz;
  # export PKG_CONFIG_PATH=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/lib/pkgconfig/
  # apt install -y rename locales libc6-i386 lib32stdc++6 subversion git cmake astyle libglib2.0-0:i386 gettext python3
  # locale-gen en_US.UTF-8 && echo "dash dash/sh boolean false" | debconf-set-selections 
  # DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
  # mkdir -p /root/x-tools/armv7-mx5-linux-gnueabi/fakebin/
  # find /root/x-toolsarmv7-mx5-linux-gnueabi/bin -name 'arm*' -exec ln -vs "{}" /root/x-tools/armv7-mx5-linux-gnueabi/fakebin/ ';'
  # cd /root/x-tools/armv7-mx5-linux-gnueabi/fakebin/ && rename 's/armv7-mx5/arm-none/' * 


  # wget http://archive.ubuntu.com/ubuntu/pool/main/z/zlib/zlib_1.2.8.dfsg.orig.tar.gz
  # tar -xvf zlib_1.2.8.dfsg.orig.tar.gz
  # cd zlib-1.2.8/
  # CC=armv7-mx5-linux-gnueabi-gcc ./configure --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr 
  # make -j4 ;make install;


  # wget http://archive.ubuntu.com/ubuntu/pool/main/libf/libffi/libffi_3.2.1.orig.tar.gz
  # tar -xf libffi_3.2.1.orig.tar.gz
  # cd libffi-3.2.1
  # ./configure --enable-builddir=armv7-mx5-linux-gnueabi --host=armv7-mx5-linux-gnueabi --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/ host_alias=armv7-mx5-linux-gnueabi
  # make -j4;make install

  ## maybe shouldn't be built
  # wget http://archive.ubuntu.com/ubuntu/pool/main/g/gettext/gettext_0.19.7.orig.tar.xz
  # tar -xf gettext_0.19.7.orig.tar.xz
  # cd gettext-0.19.7/
  # ./configure --host=armv7-mx5-linux-gnueabi --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot
  # make -j8;make install

  # wget http://archive.ubuntu.com/ubuntu/pool/main/p/pcre3/pcre3_8.38.orig.tar.gz
  # tar -xf pcre3_8.38.orig.tar.gz
  # cd pcre-8.38/
  # ./configure --host=armv7-mx5-linux-gnueabi --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/
  # make -j8;make install

  # wget http://archive.ubuntu.com/ubuntu/pool/main/g/glib2.0/glib2.0_2.48.2.orig.tar.xz
  # tar -xf glib2.0_2.48.2.orig.tar.xz
  # cd glib-2.48.2
  # echo glib_cv_stack_grows=no>>armv7-mx5-linux.cache
  # echo glib_cv_uscore=no>>armv7-mx5-linux.cache
  # ln -s /usr/bin/python2.7 /usr/bin/python2.5
  # ./configure --host=armv7-mx5-linux-gnueabi --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot --disable-option-checking --cache-file=armv7-mx5-linux.cache --with-python=/usr/bin/python3
  # make -j8 ;make install; 

  # wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/openssl_1.1.1f.orig.tar.gz
  # tar -xf openssl_1.1.1f.orig.tar.gz
  # cd openssl-1.1.1f/
  # CC=armv7-mx5-linux-gnueabi-gcc ./Configure linux-armv4 --prefix=/root/x-tools/armv7-mx5-linux-gnueabi/armv7-mx5-linux-gnueabi/sysroot/usr/
  # make -j8;make install
  # envsubst "$defined_envs" < "/etc/guacamole/guacamole.properties.template" > "/etc/guacamole/guacamole.properties"
}

# $JUPITER_DIR/liveness_probe.sh $JUPITER_POSTGRES_HOST 5432

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
fi

/bin/sh -c "$@"
