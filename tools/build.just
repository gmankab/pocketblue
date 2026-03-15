label := if expires_after != "" { "--label quay.expires-after=" + expires_after } else { "" }
buildah_tag := registry + "/" + device + "-" + desktop + ":" + tag + rechunk_suffix

build *ARGS:
    sudo buildah bud \
        --net=host \
        --arch="{{arch}}" \
        --build-arg="base={{base}}:{{branch}}" \
        --build-arg="device={{device}}" \
        --build-arg="desktop={{desktop}}" \
        --build-arg="target_tag={{tag}}" \
        {{ARGS}} \
        --tag="{{buildah_tag}}" \
        {{label}} \
        "."
