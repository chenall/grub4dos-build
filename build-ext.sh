#!/bin/bash

set -e
git clone --depth=1 https://github.com/chenall/grubutils.git $GITHUB_WORKSPACE/grubutils
pushd $GITHUB_WORKSPACE/grubutils
GRUB4DOS_VER=$(cat $GITHUB_WORKSPACE/grub4dos_version)
if [ "${GRUB4DOS_VER/EFI}" = "${GRUB4DOS_VER}" ]; then
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 100
  make -C umbr
  make -j -C g4dext && mv g4dext/bin g4dext/ext
  make -C g4dext clean
else
  make -j -C g4eext && mv g4eext/bin g4eext/ext
  make -C g4eext clean
fi
popd
