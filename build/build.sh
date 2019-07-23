#!/bin/bash

source Shells/echo_color.sh

export LANG="zh_CN.GB2312"

function currentDate(){
    # echo `date +%Y:%m:%d %H:%M`

    send=`date '+%Y-%m-%d %H:%M:%S'`
#     echo $send
#     echo_red "red $send"
#     echo_green "green $send"
#     echo_yellow "yellow $send"
#     echo_blue "blue $send"
#     echo_purple "purple $send"
#     echo_cyan "cyan $send"
#     echo_white "white $send"

#     echo_redbg "red $send"
#     echo_greenbg "green $send"
#     echo_yellowbg "yellow $send"
#     echo_bluebg "blue $send"
#     echo_purplebg "purple $send"
#     echo_cyanbg "cyan $send"
#     echo_whitebg "white $send"
# exit 1;

    echo_green "--- date: $send ---"

}

#第一个参数为文件名称*.podspec
gitFuntion(){
    version=$(grep -E 's\.version.+=' $1 | grep -E '[0-9][0-9.]+' -o)
    # echo_green "--- version: ${version} ---"
    echo_green "--- $1: ${version} ---"    
    #动作时间
    currentDate;

    echo_green "--- Step: pull from remote ---"
    git pull || exit 1

    echo_green "--- Step: add changes to local reposit ---"
    git add . || exit 1

    echo_green "--- Step: commit changes to local reposit ---"
    git commit -m "update" || exit 1

    echo_green "--- Step: push changes to remote reposit ---"
    git push -u origin master || exit 1

    echo_green "--- Step: add tag to local reposit ---"
    git tag -a ${version} -m "update" || exit 1

    echo_green "--- Step: push tag to remote reposit ---"
    git push --tags || exit 1

    echo_green "--- Step: pod trunk push to remote reposit ---"
    pod trunk push $1 --allow-warnings --use-libraries || exit 1

    echo_yellow "--- Step: finished ！---"
    # if !command; then echo "command failed"; exit 1; fi

    # if ! (pod trunk push $1 --allow-warnings --use-libraries) 
    # then
    #     echo "《---failure---》"
    #     exit 1
    # # Put Failure actions here...
    # else
    #     echo "《---Success---》"
    #     # Put Success actions here...
    # fi
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
echo ${filepath}
fileName=${filepath##*/}
echo "fileName_${fileName}"

fileNameAll="${fileName}.podspec"
echo "fileNameAll_${fileNameAll}"

result=$(echo ${fileNameAll} | grep ".podspec")
if [[ "$result" != "" ]]
then
    # echo_green "--- 存在：${fileNameAll} ---"
    gitFuntion ${fileNameAll};

else
    echo_bred "--- 不存在：${fileNameAll} ---"
fi 



