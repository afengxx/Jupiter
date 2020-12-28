#!/bin/sh

set -ex

patch_conf() {

  cd /root/ && tar -xf x-tool.tar.xz && rm -f x-tool.tar.xz;
  ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime;
  export DEBIAN_FRONTEND=noninteractive;
  apt install -y rename locales libc6-i386 lib32stdc++6 \
    subversion git cmake astyle libglib2.0-0:i386 gettext python3 libdbus-1-dev \
    systemctl nfs-kernel-server;
  dpkg-reconfigure --frontend noninteractive tzdata;

  mkdir -p /root/x-tools/armv7-mx5-linux-gnueabi/fakebin/;
  find /root/x-tools/armv7-mx5-linux-gnueabi/bin -name 'arm*' -exec ln -vs "{}" /root/x-tools/armv7-mx5-linux-gnueabi/fakebin/ ';';
  cd /root/x-tools/armv7-mx5-linux-gnueabi/fakebin/ && rename 's/armv7-mx5/arm-none/' * ;

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
