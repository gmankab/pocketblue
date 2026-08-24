disk-prepare:
    #!/usr/bin/env bash
    set -uexo pipefail
    mkdir -p out/images
    truncate -s 6G out/images/fedora_rootfs.raw
    mkfs.btrfs -f --features ^bgt out/images/fedora_rootfs.raw

disk:
    #!/usr/bin/env bash
    set -uexo pipefail
    mkdir -p /mnt/fedora_rootfs /mnt/root_subvol
    losetup --find out/images/fedora_rootfs.raw
    mount /dev/loop0 /mnt/fedora_rootfs
    btrfs subvolume create /mnt/fedora_rootfs/root
    umount /mnt/fedora_rootfs
    mount --options=subvol=/root /dev/loop0 /mnt/root_subvol
    podman run \
        --rm \
        --pid=host \
        --ipc=host \
        --privileged \
        -v /var/lib/containers:/var/lib/containers \
        -v /mnt/root_subvol:/root_subvol:rslave \
        -v .:/data:ro \
        {{full_image}} \
        /data/tools/postprocess/only-fedora-rootfs.sh
    umount /mnt/root_subvol

postprocess:
    #!/usr/bin/env bash
    set -euo pipefail

    source devices/{{device}}/build-aux/device.conf
    export CONF_INSTALL_DTB=${install_dtb:-}
    export CONF_SPLIT_PARTITIONS=${split_partitions:-}
    export CONF_BUILD_EROFS=${build_erofs:-false}

    export OUTPUT=./output
    export SCRIPTS=tools/postprocess
    export OCI_IMAGE="{{full_image}}"

    tools/postprocess/postprocess.sh

artifacts:
    #!/usr/bin/env bash
    set -euo pipefail

    export DEVICE_PATH=devices/{{device}}
    export ARGS_7Z="{{compression_7z}}"
    export SCRIPTS=tools/postprocess

    tools/collect-artifacts.sh
