#!/bin/bash
source Shells/common.sh
source Shells/echo_color.sh
source Shells/git_action.sh

export LANG="zh_CN.GB2312"

#------------------------------------------------------------------------
#配置项目名称和路径等相关参数
#------------------------------------------------------------------------
filepath=$(cd "$(dirname "$0")"; pwd)
echo_blue "文件目录: ${filepath}"

fileName=${filepath##*/}
#echo "fileName_${fileName}"
pushLib $fileName;


