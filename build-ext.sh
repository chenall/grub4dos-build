#!/bin/bash

set -e
git clone --depth=1 https://github.com/chenall/grubutils.git $GITHUB_WORKSPACE/grubutils
pushd $GITHUB_WORKSPACE/grubutils
make -C umbr
make -j -C g4dext && mv g4dext/bin g4dext/ext
make -j -C g4eext && mv g4eext/bin g4eext/ext
popd
