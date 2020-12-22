ARG UBUNTU_VER=14.04

FROM ubuntu:${UBUNTU_VER} AS builder
ARG DEBIAN_FRONTEND=noninteractive

ARG PREFIX_DIR=/usr/local
# ARG BUILD_TYPE=debug
#BUILD_TYPE=release

RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y install gperf bison flex texinfo help2man gawk libtool libncurses5-dev \
        libtool-bin bash


# FROM dpdkbuilder AS pktgenbuilder

# ARG PREFIX_DIR=/usr/local
# ARG PKGGEN_VER=20.11.3
# #COPY ./pktgen-${PKGGEN_VER}.tar.xz pktgen-${PKGGEN_VER}.tar.xz
# ENV PKG_CONFIG_PATH "${PREFIX_DIR}/dpdk/lib/x86_64-linux-gnu/pkgconfig"
# RUN cd / && \
#     wget https://git.dpdk.org/apps/pktgen-dpdk/snapshot/pktgen-${PKGGEN_VER}.tar.xz && \
#     tar -xf pktgen-${PKGGEN_VER}.tar.xz && \
#     cd pktgen-${PKGGEN_VER} && \
#     CFLAGS=-I${PREFIX_DIR}/dpdk/include meson build -Dprefix=${PREFIX_DIR}/dpdk/ -Denable_lua=true && \
#     ninja -C build install -j4

# # Use same alpine as the base for the runtime image
# FROM ubuntu:${UBUNTU_VER}
# ARG DEBIAN_FRONTEND=noninteractive

# LABEL calvin <c6supper@hotmail.com>

# ARG PREFIX_DIR=/usr/local

# # Copy build artifacts into this stage
# COPY --from=pktgenbuilder ${PREFIX_DIR}/dpdk ${PREFIX_DIR}/dpdk
# ENV PATH="${PREFIX_DIR}/dpdk/bin:${PATH}"
# RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
#     apt-get update && \
#     #pciutils
#     apt-get -y install python3 libnuma1 libbpf0 libpcap0.8 liblua5.4-0 iproute2 libvirt0 \
#         libjansson4 libbsd0 libmnl0 libibverbs1 libipsec-mb0 libisal2 intel-cmt-cat libssl1.1 && \
#     ldconfig ${PREFIX_DIR}/dpdk/lib/x86_64-linux-gnu/ && \
#     apt-get clean autoclean  && \
#     apt-get autoremove --yes  && \
#     rm -rf /var/lib/{apt,dpkg,cache,log}/  && \
#     echo "over"

CMD ["/usr/bin/bash"]

#docker run -it --privileged --device=/dev/net/tun --network host -d -v /sys/bus/pci/devices:/sys/bus/pci/devices -v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages -v /sys/devices/system/node:/sys/devices/system/node -v /dev:/dev --name mercury c6supper/mercury

#--vdev=eth_af_packet0,iface=enp4s2 -l 0-3 -n 2 -- -P -p 1 --rx="(0,0,0,0)(0,0,1,1)" --tx="(2,0)(3,1)" --parse-ptype
#dpdk-l3fwd-thread --log-level=0 --vdev=eth_af_packet0,iface=enp4s2,qpairs=3 -l 0-2 -n 2 -- -p 0x1 -P --rx="(0,0,0,0),(0,1,1,1),(0,2,2,2)" --tx="(0,0),(0,1),(0,2)"  --eth-dest=0,00:18:63:02:cb:54 --parse-ptype
#--vdev=net_tap,iface=tap0,remote=enp4s2