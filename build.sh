#!/usr/bin/env sh

set -x

# APT params
_APT_PROXY=${APT_PROXY}
_APT_FLAGS_COMMON=${APT_FLAGS_COMMON:=-y --no-install-recommends}
export DEBIAN_FRONTEND=noninteractive

_ROOT_DIR=$(pwd)

_MAIN_PACKAGES=" \
                curl \
                devscripts \
                equivs \
                software-properties-common \
"

# Proc numbers for building faster
_NB_PROC=${NB_PROC:=$(grep -c ^processor /proc/cpuinfo)}

echo "Cleaning..."
# Clean out any files from previous runs of this script
rm -rf build

# Ensure that we have the required software to compile
if [ -z "${_APT_PROXY}" ]; then
  echo "Acquire::http::Proxy \"{{ ${_APT_PROXY} }}\";" > /etc/apt/apt.conf.d/99pcache
fi
if [ -z "${_HTTP_PROXY}" ]; then
  export http_proxy=${_HTTP_PROXY}
fi

# Clean
rm -f *-stamp
rm -rf build-*
rm -rf output
rm -f *.deb
rm -f debian/*.debhelper
rm -rf debian/.debhelper
rm -f debian/*.log
rm -f debian/*.substvars
rm -rf debian/php-xxhash

apt-get update
apt-get install ${_APT_FLAGS_COMMON} ${_MAIN_PACKAGES}

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
add-apt-repository -y -u ppa:ondrej/php
apt-get update

# install build deb dependencies
mk-build-deps -t "apt-get ${_APT_FLAGS_COMMON}" --install debian/control

dpkg-buildpackage -rfakeroot -b -j${_NB_PROC} -uc -us -tc
