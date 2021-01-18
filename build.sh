#!/bin/sh

if [ ! -f grub4dos_version ]; then
    echo 错误的 grub4dos 源码目录
    exit
fi
GRUB4DOS_VER=`cat grub4dos_version`
echo "GRUB4DOS_VER=$GRUB4DOS_VER" >> $GITHUB_ENV
echo "GRUB4DOS_BIN=grub4dos-$GRUB4DOS_VER-`date -u +%Y-%m-%d`.7z" >> $GITHUB_ENV
scp -r -P 22222 `pwd` tc@127.0.0.1:~/grub4dos
ssh -p 22222 tc@127.0.0.1 "cd ~/grub4dos && ./build"
scp -P 22222 tc@127.0.0.1:~/grub4dos/grub4dos-*.7z ./
