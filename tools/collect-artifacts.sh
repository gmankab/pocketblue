#!/usr/bin/env bash

set -uexo pipefail

which 7z

mkdir -p out
if [ -d output/images ]; then
    mv output/images out/
fi
if [ -f output/disk.raw ]; then
    mv output/disk.raw out/
fi

# extra downloads
if [ -f "$DEVICE_PATH/build-aux/extra-sources" ]; then
    $SCRIPTS/download-extra.sh $DEVICE_PATH/build-aux/extra-sources
fi

# custom artifact processing script
export OUT_PATH=$(realpath ./out)
export DEVICE_PATH=$(realpath $DEVICE_PATH)
$DEVICE_PATH/build-aux/artifacts.sh

cd out
7z a -mx=9 $ARGS_7Z "../pocketblue.7z" .
