# only for local build

FROM registry.opensuse.org/home/kwk/elemental/images/opensuse_leap_15.3/rancher/ros-node-image-opensuse/15.3
ARG CACHEBUST
ENV LUET_NOLOCK=true

RUN ["luet", \
    "install", "--no-spinner", "-d", "-y", \
    "meta/cos-modules"]

# Starting from here are the lines needed for RancherOS to work

# Make this build unique for ros-updater
RUN echo "TIMESTAMP="`date +"\"%Y%m%d%H%M%S\""` >> /etc/os-release

# Rebuild initrd to setup dracut with the boot configurations
RUN mkinitrd && \
    # aarch64 has an uncompressed kernel so we need to link it to vmlinuz
    kernel=$(ls /boot/Image-* | head -n1) && \
    if [ -e "$kernel" ]; then ln -sf "${kernel#/boot/}" /boot/vmlinuz; fi
