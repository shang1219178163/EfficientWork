#!/bin/bash

source Shells/appIcon_launch_func.sh

#文件名称
fileNameAll="AppLaunch.png"
#检测文件是否存在
isExistFile $fileNameAll
#转化成可操作的格式
switchToSRGB
#目标文件夹名称
targetFileDir=./iPhone/LaunchImage.launchimage
#创建目标文件夹
mkdir -p ${targetFileDir}
#目标文件夹写入json文件
createContentsAppLaunch $targetFileDir
#目标文件夹写入图片
setImageAppLaunch $targetFileDir $fileNameAll