#!/bin/bash

source Shells/appIcon_launch_func.sh

#文件名称
fileNameAll="AppIcon.png"
#检测文件是否存在
isExistFile $fileNameAll
#转化成可操作的格式
convertToSRGB
# find . -type f -name '*.png' -print0 | while IFS= read -r -d '' file;
# find . -type f -name '*.png' | while IFS= read -r -d '' file;
# do
# sips --matchTo '/System/Library/ColorSync/Profiles/sRGB Profile.icc' "$file" --out "$file";
# done


cd AppIconFiles

sh appIcon_iPhone.sh
sh appIcon_iMac.sh
sh appIcon_iWatch.sh
