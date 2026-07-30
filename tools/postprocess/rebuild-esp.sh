#!/usr/bin/env bash

set -uexo pipefail

size=$(blockdev --getsize64 $esp_part)
uuid=$(blkid -s UUID -o value $esp_part | tr -d '-')

truncate -s $size esp_temp.raw
mkfs.vfat -S $CONF_ESP_SECTOR_SIZE -n EFI -i $uuid esp_temp.raw

mkdir -p esp.old esp.new
mount $esp_part esp.old
mount -o loop esp_temp.raw esp.new

cp -a esp.old/. esp.new/

umount esp.old esp.new
rmdir esp.old esp.new

dd if=esp_temp.raw of=$esp_part bs=1M
sync
rm esp_temp.raw
