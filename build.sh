#!/bin/bash

ACTION_PATH=$(dirname $(readlink -f $0))
$ACTION_PATH/build-ext.sh
chmod +x $ACTION_PATH/build-page.sh
set -e
for src in $grub4dos_src
do
    if [ ! -f $src/grub4dos_version ]; then
        echo 错误的 grub4dos 源码目录: $src
        exit 1
    fi
    dst=$src
    if [ "$src" = "." ]; then
        src=`pwd`
        dst=grub4dos
    fi
    pushd $src
    echo 准备编译 $dst
    GRUB4DOS_VER=`cat grub4dos_version`
    if [ "$INPUT_USEQEMU" = "1" ]; then
        scp -r `pwd` grubdev:~/$dst
        ssh grubdev "rm -rf /tmp/grub4dos-temp;cd ~/$dst && ./build"
        scp grubdev:~/$dst/grub4dos-*.7z ./ 
    else
        if [ -d ipxe ]; then
            #因为默认下载不是完整的代码不包含 tag 信息，ipxe 编译必须包含 tag,否则会报错
            #具体相关信息 https://github.com/ipxe/ipxe/commit/8f1514a00
            cd ipxe
            # iPXE 多线程预编译
            git tag v1.0.0
            make -j -C src bin/undionly.pxe
            cd ..
        fi
        CC=gcc-4.8 ./build
    fi

    GRUB4DOS_BIN=`ls grub4dos-$GRUB4DOS_VER-*.7z`
    if [ "${GRUB4DOS_VER/EFI}" = "${GRUB4DOS_VER}" ]; then
        if [ -d $GITHUB_WORKSPACE/grubutils/g4dext/ext ]; then
            7z a $GRUB4DOS_BIN $GITHUB_WORKSPACE/grubutils/g4dext/ext
        fi
    else
        if [ -d $GITHUB_WORKSPACE/grubutils/g4eext/ext ]; then
            7z a $GRUB4DOS_BIN $GITHUB_WORKSPACE/grubutils/g4eext/ext
        fi
    fi
    $ACTION_PATH/build-page.sh
    popd
done
[ "$INPUT_USEQEMU" = "1" ] && ssh grubdev sudo poweroff
echo "GRUB4DOS_VER=$GRUB4DOS_VER" >> $GITHUB_ENV
echo "GRUB4DOS_BIN=grub4dos-$GRUB4DOS_VER-`date -u +%Y-%m-%d`.7z" >> $GITHUB_ENV