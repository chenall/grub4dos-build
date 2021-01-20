#!/bin/sh
cd opt-src
find | cpio -o -H newc | gzip > ../grubdev/boot/opt.gz
