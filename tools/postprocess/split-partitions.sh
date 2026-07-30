#!/usr/bin/env bash

set -uexo pipefail

mkdir -p $OUTPUT/images

dd if=$esp_part of=$OUTPUT/images/fedora_esp.raw bs=1M
dd if=$boot_part of=$OUTPUT/images/fedora_boot.raw bs=1M
dd if=$root_part of=$OUTPUT/images/fedora_root.raw bs=1M

sync

chmod 666 $OUTPUT/images/*
