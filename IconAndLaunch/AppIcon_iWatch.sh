#!/bin/bash

source Shells/appIcon_launch_func.sh

#文件名称
fileNameAll="AppIcon.png"
#检测文件是否存在
isExistFile $fileNameAll
#转化成可操作的格式
convertToSRGB
#目标文件夹名称
targetFileDir=./iWatch/AppIcon.appiconset
#创建目标文件夹
mkdir -p ${targetFileDir}
#目标文件夹写入json文件
createContentsiWatch $targetFileDir
#目标文件夹写入图片
setImageiWatch $targetFileDir $fileNameAll

