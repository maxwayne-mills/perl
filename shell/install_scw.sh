#!/bin/bash


# get latest release
export ARCH=amd64  # can be 'i386', 'amd64' or 'armhf'
wget "https://github.com/scaleway/scaleway-cli/releases/download/v1.11.1/scw_1.11.1_${ARCH}.deb" -O /tmp/scw.deb
dpkg -i /tmp/scw.deb && rm -f /tmp/scw.deb

# test
scw version
