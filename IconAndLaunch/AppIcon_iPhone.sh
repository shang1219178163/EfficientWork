#!/bin/bash

source Shells/appIcon_launch_func.sh

#文件名称
fileNameAll="AppIcon.png"
#检测文件是否存在
isExistFile $fileNameAll
#转化成可操作的格式
switchToSRGB
# find . -type f -name '*.png' -print0 | while IFS= read -r -d '' file;
# find . -type f -name '*.png' | while IFS= read -r -d '' file;
# do
# sips --matchTo '/System/Library/ColorSync/Profiles/sRGB Profile.icc' "$file" --out "$file";
# done

#目标文件夹名称
targetFileDir=./iPhone/AppIcon.appiconset
#创建目标文件夹
mkdir -p ${targetFileDir}
#目标文件夹写入json文件
createContentsApp $targetFileDir
#目标文件夹写入图片
setImageApp $targetFileDir $fileNameAll

# var=$0
# res=${var#*_}
# dirName=${res%%.*}
# echo $dirName