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

fileNameAll=$1
echo_blue "查找文件: ${fileNameAll}"

#result=$(echo ${fileNameAll} | grep ".podspec")
#if [[ "$result" != "" ]]
if [ -d "$fileNameAll" ]
then
   # echo_green "--- 存在：${fileNameAll} ---"
   echo_green "--- 发现lib: $(datetime) ---"
   createRepo $fileNameAll;
else
   echo_red "--- lib不存在：${fileNameAll}，创建本地lib ---"
   createLib $fileNameAll;
fi


