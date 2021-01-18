#!/bin/sh

set -ex

patch_conf() {

  cd /opt/ && tar -xf x-tool.tar.xz;rm -f x-tool.tar.xz;
  ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime;
  export DEBIAN_FRONTEND=noninteractive;
  apt install -y rename locales libc6-i386 lib32stdc++6 \
    subversion git cmake astyle libglib2.0-0:i386 gettext python3 libdbus-1-dev unzip;
  dpkg-reconfigure --frontend noninteractive tzdata autoconf wget libtool libtool-bin autopoint;
  locale-gen en_US.UTF-8;
  mkdir -p /opt/x-tools/armv7-mx5-linux-musleabihf/fakebin/;
  find /opt/x-tools/armv7-mx5-linux-musleabihf/bin -name 'arm*' -exec ln -vs "{}" /opt/x-tools/armv7-mx5-linux-musleabihf/fakebin/ ';';
  cd /opt/x-tools/armv7-mx5-linux-musleabihf/fakebin/ && rename 's/armv7-mx5-linux-musleabihf/arm-none-linux-gnueabi/' * ;

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
