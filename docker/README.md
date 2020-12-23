
## Jupiter imx5 building enviroment docker
**Authentication and Authorization server.**  

## How to build
1. **Checkout you kernel source code into current directory**
2. **Debug, 
      docker build -t c6supper/jupiter -f Dockerfile --build-arg BUILD_TYPE="debug" \
                                                      --build-arg CODE_DIR="/code" \
                                                      --build-arg CPU="mx5" \
                                                      --build-arg GLIB="glibc-2.23" \
                                                      --build-arg KERNEL="linux-2.6.35.3" \
                                                      --build-arg PROXY_SERVER="http://192.168.100.7:3128" ./**

