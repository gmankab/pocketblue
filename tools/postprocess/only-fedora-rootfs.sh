#!/usr/bin/env bash
set -uexo pipefail

bootc install to-filesystem \
    --bootloader=none \
    --karg=rootflags=subvol=/root \
    --skip-finalize \
    /root_subvol

ostree config --repo=/root_subvol/ostree/repo set sysroot.bootloader uboot
ostree config --repo=/root_subvol/ostree/repo set sysroot.bootprefix false

touch /root_subvol/boot/loader/uEnv.txt
ln -sfn loader/uEnv.txt /root_subvol/boot/uEnv.txt

ostree admin --sysroot=/root_subvol instutil set-kargs --merge --replace=init_on_alloc=1
ostree admin --sysroot=/root_subvol instutil set-kargs --merge --replace=init_on_alloc=0

bootc install finalize /root_subvol
