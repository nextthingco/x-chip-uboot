#!/bin/bash -ex

# this script builds a patched uboot.
# it's meant to be called via the Dockerfile
# in this directory, for which there's a Makefile to build
# and run the container

HERE=$PWD

mkdir -p build
cd build
git clone --depth 1 --branch v2022.01 https://github.com/u-boot/u-boot
cd u-boot

# apply nand patches
git apply "${HERE}/0001-sunxi-Add-support-for-slc-emulation-on-mlc-NAND.patch"
git apply "${HERE}/0001-sunxi-nand-Undo-removal-of-DMA-specific-code-that-br.patch"

# append nand configs to CHIP_defconfig before invoking it
cat "${HERE}/nand.cfg" >> configs/CHIP_defconfig

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-

make CHIP_defconfig
make -j"$(nproc)"

# hand the build outputs back to the invoking host user (HOST_UID/GID come
# from the Makefile's docker run), so build/ isn't left root-owned.
[ -n "${HOST_UID:-}" ] && chown -R "$HOST_UID:$HOST_GID" "$HERE/build" || true
