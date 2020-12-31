
## Jupiter imx5 building environment docker
**For IMX53 building environment, based on Ubuntu.**  

## How to build
1. **Checkout you kernel source code into current directory**
2. **Example command line, 
      docker build -t c6supper/jupiter -f Dockerfile --build-arg BUILD_TYPE="debug" \
                                                      --build-arg CPU="mx5" \
                                                      --build-arg GLIB="glibc-2.23" \
                                                      --build-arg KERNEL="linux-2.6.35.3" \
                                                      --build-arg PROXY_SERVER="http://192.168.100.7:3128" ./**

