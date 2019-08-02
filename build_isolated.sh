#!/usr/bin/env sh

set -x

_IMAGE_NAME=${IMAGE_NAME:=buildpack-deps}
_IMAGE_VERSION=${IMAGE_VERSION:=16.04-scm}
_PRIVATE_REPO=${PRIVATE_REPO}
_APT_PROXY=${APT_PROXY}
_HTTP_PROXY=${HTTP_PROXY}

docker run --rm \
    --interactive \
    --workdir /workdir/debfiles-php-xxhash \
    --volume $(pwd)/..:/workdir/ \
    --env USERID=$(id -u) \
    --env GROUPID=$(id -g) \
    --env APT_PROXY=${_APT_PROXY} \
    --env HTTP_PROXY=${_HTTP_PROXY} \
    --entrypoint sh \
  ${_PRIVATE_REPO}${_IMAGE_NAME}:${_IMAGE_VERSION} \
    build.sh
