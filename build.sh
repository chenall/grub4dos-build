#!/bin/sh
env | sort

for src in $grub4dos_src
do
    if [ ! -f $src/grub4dos_version ]; then
        echo 错误的 grub4dos 源码目录: $src
        exit 1
    fi
    dst=$src
    [ "$src" == "." ] && dst=grub4dos
    echo 准备编译 $dst
    GRUB4DOS_VER=`cat $src/grub4dos_version`
    scp -r $src/ grubdev:~/$dst
    ssh grubdev "rm -rf /tmp/grub4dos-temp;cd ~/$src && ./build"
    scp grubdev:~/$dst/grub4dos-*.7z ./
done
ssh grubdev sudo poweroff
echo "GRUB4DOS_VER=$GRUB4DOS_VER" >> $GITHUB_ENV
echo "GRUB4DOS_BIN=grub4dos-$GRUB4DOS_VER-`date -u +%Y-%m-%d`.7z" >> $GITHUB_ENV
