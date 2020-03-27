#!/bin/bash

source Shells/common.sh
source Shells/echo_color.sh
source Shells/git_action.sh

export LANG="zh_CN.GB2312"

testLogColor(){
    send=$(datetime)
    echo $send
    echo_red "red $send"
    echo_green "green $send"
    echo_yellow "yellow $send"
    echo_blue "blue $send"
    echo_purple "purple $send"
    echo_cyan "cyan $send"
    echo_white "white $send"

    # echo_redbg "red $send"
    # echo_greenbg "green $send"
    # echo_yellowbg "yellow $send"
    # echo_bluebg "blue $send"
    # echo_purplebg "purple $send"
    # echo_cyanbg "cyan $send"
    # echo_whitebg "white $send"

    log "${send}"

    log debug "${send}"
    log info "${send}"
    log warn "${send}"
    log error "${send}"

    # echo "___$?___"
    # echo_purple `$now()`

    tmp=$(datetime)
    tmpNew=`datetime`
    echo "___$(datetime)___"
    echo "___${tmp}___"
    echo "___${tmpNew}___"
    echo "___$(datetimeStamp)___"

    exit 1;

}

#------------------------------------------------------------------------
#配置项目名称和路径等相关参数
#------------------------------------------------------------------------
# find -name BNCategory.podspec
#遍历文件目录
# path=$1
# files=$(ls $path)
# for filename in $files
# do
# #   echo $filename >> filename.txt
# #   echo "filename——${filename}"
#   result=$(echo ${filename} | grep ".podspec")
#   if [[ "$result" != "" ]]
#   then
#     echo "包含___${filename}"
#     var=$(cat ${filename})
#     # echo "文件内容___${var}"
#     # echo ${var%s.summary*}

#     # gitFuntion ${filename};

#   else
#     echo "不包含_${filename}"
#   fi 

# done

filepath=$(cd "$(dirname "$0")"; pwd)
echo_blue "文件目录: ${filepath}"

fileName=${filepath##*/}
#echo "fileName_${fileName}"

fileNameAll="${fileName}.podspec"
echo_blue "查找文件: ${fileNameAll}"

#result=$(echo ${fileNameAll} | grep ".podspec")
#if [[ "$result" != "" ]]
if [ -f "$fileNameAll" ]
then
    echo_green "--- $(datetime) ---"
#    testLogColor;
    updatePod ${fileNameAll};

else
    echo_red "文件不存在：$fileNameAll"
fi

