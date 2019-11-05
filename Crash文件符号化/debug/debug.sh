#!/usr/bin/bash

# 进入当前目录（兼容不cd）
project_path=$(cd `dirname $0`; pwd)
echo $project_path
cd $project_path

#清除旧文件
rm -r *.txt
#开始符号化
export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

alias symbolicatecrash='/Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/symbolicatecrash'

i=0

for x in *.crash;
do
        symbolicatecrash $x *.app.dSYM > $i.txt
        i=$((i+1))
done

open 0.txt
