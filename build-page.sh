#! /bin/bash

COMMIT=${GITHUB_SHA:0:8}
VER=`cat grub4dos_version`
DATE=`date -u +%Y-%m-%d`
#DATE=`git log -1 --pretty=format:%ad --date=format:%Y-%m-%d --no-merges $GITHUB_SHA`
BIN=grub4dos-${VER}-${DATE}.7z
NAME=`basename $BIN`
PAGE=`pwd`/${NAME%.7z}.md
BASE_URI=$GITHUB_SERVER_URL/$GITHUB_REPOSITORY
echo title: $NAME > $PAGE
du -sh $BIN|awk '{printf "size: %s\n",$1}' >>$PAGE
echo date: `stat -c %y $BIN` >> $PAGE
echo commit: $COMMIT >>$PAGE
echo downlink: http://dl.grub4dos.chenall.net/${NAME} >>$PAGE
echo categories: $VER >>$PAGE
echo tags: $VER >>$PAGE
md5sum $BIN|awk '{printf "md5: %s\n",$1}' >>$PAGE
echo files: >>$PAGE
#可执行文件MD5信息
7z e -y -r -ssc- -obin $BIN grub.exe grldr ipxegrldr *.efi 
pushd bin && md5sum *|awk '{printf "  %s: %s\n",$2,$1}' >> $PAGE && popd
echo --- >>$PAGE
echo >>$PAGE
echo "### 更新信息(update log):" >>$PAGE
git log --pretty=format:"  * [%ad %h@%an ]($BASE_URI/commit/%H) %w(0,4,6)%B" --no-merges --date=format:%Y-%m-%d $COMMIT_RANGE >>$PAGE || git log --pretty=format:"  * [%ad %h@%an ]($BASE_URI/commit/%H) %w(0,4,6)%B" -1 --no-merges --date=format:%Y-%m-%d HEAD >>$PAGE
echo >>$PAGE
echo >>$PAGE
echo "### 对应源码(sources):" >>$PAGE
echo "  [查看源码(Browse source)]($BASE_URI/tree/$GITHUB_SHA)" >>$PAGE
echo >>$PAGE
echo "  [下载源码(Download ZIP)]($BASE_URI/archive/$GITHUB_SHA.zip)" >>$PAGE
echo ===========$PAGE================
cat $PAGE
echo ==============Success===========
