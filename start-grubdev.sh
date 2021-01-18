#!/bin/sh

sudo apt -y install qemu-system-x86 genisoimage
genisoimage -hide-joliet boot.catalog -l -joliet-long -no-emul-boot -boot-load-size 4 -o grubdev.iso -v -V "grubdev" -b boot/grldr grubdev
sudo qemu-system-x86_64 -m 1G -cdrom grubdev.iso -boot d -display none -net user,hostfwd=tcp::22222-:22 -net nic &
echo 等待开发环境启动完成，预计需要 3 － 5 分钟....
timeout 5m nc -l -p 22223
[ -d ~/.ssh ] || mkdir ~/.ssh
[ -f ~/.ssh/known_hosts ] || touch ~/.ssh/known_hosts
ssh-keyscan -p 22222 127.0.0.1 >> ~/.ssh/known_hosts