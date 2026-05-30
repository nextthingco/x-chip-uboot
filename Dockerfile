# u-boot is old, requires old python
FROM debian:bookworm

# build deps for u-boot, cross-compiling armhf from amd64
RUN apt-get update \
  && apt-get -y install \
       gcc-arm-linux-gnueabihf \
       bc \
       bison \
       flex \
       libssl-dev \
       make \
       swig \
       python3-dev \
       python3-setuptools \
       python3-distutils \
       device-tree-compiler \
       git \
       ca-certificates
