disk:
    #!/usr/bin/env bash
    set -uexo pipefail

    mkdir -p out/images
    sudo mkdir -p /mnt/fedora_rootfs /mnt/root_subvol
    truncate -s 6G out/images/fedora_rootfs.raw
    mkfs.btrfs -f --features ^bgt out/images/fedora_rootfs.raw
    sudo losetup --find out/images/fedora_rootfs.raw
    sudo mount /dev/loop0 /mnt/fedora_rootfs
    sudo btrfs subvolume create /mnt/fedora_rootfs/root
    sudo umount /mnt/fedora_rootfs
    sudo mount --options=subvol=/root /dev/loop0 /mnt/root_subvol
    sudo podman run \
        --rm \
        --pid=host \
        --privileged \
        -v /mnt/root_subvol:/root_subvol:rslave \
        -v .:/data:ro \
        {{full_image}} \
        /data/tools/postprocess/only-fedora-rootfs.sh
    sudo umount /mnt/root_subvol

artifacts:
    #!/usr/bin/env bash
    set -euo pipefail

    export DEVICE_PATH=devices/{{device}}
    export ARGS_7Z="{{compression_7z}}"
    export ACTION_PATH=tools/postprocess
    export BUILD_AUX=build-aux

    tools/collect-artifacts.sh
