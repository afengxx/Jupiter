
## Jupiter imx5 building environment docker
**For IMX53 building environment, based on Ubuntu.**  

## How to build
1. **Instal buildah ,example for install in UBUNTU 18.04**
      sudo apt-get update -qq
      sudo apt-get install -qq -y software-properties-common
      sudo add-apt-repository -y ppa:projectatomic/ppa
      sudo apt-get update -qq
      sudo apt-get -qq -y install buildah
2. **Checkout you kernel source code into current directory**
3. **Example command line, 
      docker build -t c6supper/jupiter -f Dockerfile  --build-arg WITH_XSERVER="false" \
                                                      --build-arg WITH_QT="false" \
                                                      --build-arg WITH_X11="false" \
                                                      --build-arg BUILD_DIR="/code" \
                                                      --build-arg CPU="mx5" \
                                                      --build-arg GLIB="glibc-2.23" \
                                                      --build-arg KERNEL="linux-2.6.35.3" \
                                                      --build-arg PROXY_SERVER="http://192.168.100.7:3128" ./
      or 
      buildah build -t c6supper/jupiter -f Dockerfile --build-arg WITH_XSERVER="false" \
                                                      --build-arg WITH_QT="false" \
                                                      --build-arg WITH_X11="false" \
                                                      --build-arg BUILD_DIR="/code" \
                                                      --build-arg CPU="mx5" \
                                                      --build-arg GLIB="glibc-2.23" \
                                                      --build-arg KERNEL="linux-2.6.35.3" \
                                                      --build-arg PROXY_SERVER="http://192.168.100.7:3128" ./**
## How to Jail, example
1.**Start jchroot in inittab**
      /usr/local/jrootfs/usr/bin/jchroot -p /tmp/var/run/jail.pid -n jail -f /usr/local/jrootfs/etc/fstab /usr/local/jrootfs/ /sbin/init
2.**Run command inside the jail**
      nsenter -t $(cat /tmp/var/run/jail.pid) -p -r your_command
