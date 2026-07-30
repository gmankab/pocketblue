#!/usr/bin/env bash

set -uexo pipefail

mkdir boot
mount $boot_part boot
mount $esp_part boot/efi
cp -ar boot/ostree/default-*/dtb boot/efi/dtb
umount -R boot/
rmdir boot
