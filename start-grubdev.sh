#!/bin/sh

set -e
sudo apt-get -y update
sudo apt install -y gcc-11 gcc-11-multilib nasm upx upx-ucl p7zip-full autoconf automake make patch binutils-dev liblzma-dev syslinux isolinux genisoimage
if [ ! "$INPUT_USEQEMU" = "1" ]; then
    exit
fi
for test in $grub4dos_src
do
  if [ ! -f $test/grub4dos_version ]; then
        echo 错误的 grub4dos 源码目录
        exit 1
  fi
done

if [ -e /dev/kvm ]; then
    qemu=kvm
else
    qemu=qemu-system-x86_64
fi

sudo apt -y install qemu-kvm genisoimage
genisoimage -hide-joliet boot.catalog -l -joliet-long -no-emul-boot -boot-load-size 4 -o grubdev.iso -v -V "grubdev" -b boot/grldr grubdev
echo "等待开发环境[${qemu}]启动完成，预计需要 3 － 10 分钟...."
sudo $qemu -m 1G -cdrom grubdev.iso -boot d -display none -net user,hostfwd=tcp::22222-:22 -net nic &
time timeout 10m nc -l -p 22223 || exit $?
[ -d ~/.ssh ] || mkdir -p ~/.ssh
[ -f ~/.ssh/known_hosts ] || touch ~/.ssh/known_hosts
[ -f ~/.ssh/config ] || touch ~/.ssh/config
cat ssh_config >> ~/.ssh/config
