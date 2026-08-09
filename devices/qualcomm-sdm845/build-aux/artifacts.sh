#!/usr/bin/env bash

set -uexo pipefail

which 7z

mv $OUT_PATH/u-boot-*.zip ./
7z x 'u-boot-*.zip'
cp binaries/u-boot-oneplus-*.img $OUT_PATH/images/

install -Dm 0755 $DEVICE_PATH/flash-scripts/flash.sh $OUT_PATH/flash.sh
