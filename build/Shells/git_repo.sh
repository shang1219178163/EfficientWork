#!/bin/bash

source Shells/common.sh
source Shells/echo_color.sh
source Shells/git_action.sh

export LANG="zh_CN.GB2312"


#创建并关联到远程仓库
#libCreateAndLinkRepo(){
#    username=shang1219178163
#    echo_green "--- ${username}: $1 ---"
#
#     echo_green "--- Step: pod lib create $1 --template-url=https://github.com/$username/pod-template.git ---"
#     pod lib create $1 --template-url=https://github.com/$username/pod-template.git || exit 1
#
#    echo_green "--- Step: curl -u ${username} https://api.github.com/user/repos -d '{\"name\":\"$1\"}' ---"
#    curl -u ${username} https://api.github.com/user/repos -d '{"name":"$1"}' || exit 1
#
#    echo_green "--- Step: git remote rm origin ---"
#    git remote rm origin || exit 1
#
#    echo_green "--- Step: git remote add origin ssh://git@github.com:${username}/$1.git ---"
#    git remote add origin ssh://git@github.com:${username}/$1.git
#
#    echo_green "--- Step: git remote set-url origin https://github.com/${username}/$1.git ---"
#    git remote set-url origin https://github.com/${username}/$1.git || exit 1
#
#    echo_green "--- Step: git push --force --all ---"
#    git push --force --all || exit 1
#
#    echo_yellow "--- Step: finished ！---"
#}


#创建本地你仓库 local lib
createLib(){
    username=shang1219178163
    echo_green "--- ${username}: $1 ---"

    echo_green "--- Step: pod lib create $1 --template-url=https://github.com/$username/pod-template.git ---"
    pod lib create $1 --template-url=https://github.com/$username/pod-template.git || exit 1

   linkRepo $1;
}

#关联到远程仓库
linkRepo(){
    username=shang1219178163
    echo_green "--- ${username}: $1 ---"

    # echo_green "--- Step: pod lib create $1 --template-url=https://github.com/$username/pod-template.git ---"
    # pod lib create $1 --template-url=https://github.com/$username/pod-template.git || exit 1

    echo_green "--- Step: curl -u ${username} https://api.github.com/user/repos -d '{\"name\":\"$1\"}' ---"
    curl -u ${username} https://api.github.com/user/repos -d '{"name":"$1"}' || exit 1

    echo_green "--- Step: git remote rm origin ---"
    git remote rm origin || exit 1

    echo_green "--- Step: git remote add origin ssh://git@github.com:${username}/$1.git ---"
    git remote add origin ssh://git@github.com:${username}/$1.git

    echo_green "--- Step: git remote set-url origin https://github.com/${username}/$1.git ---"
    git remote set-url origin https://github.com/${username}/$1.git || exit 1

    echo_green "--- Step: git push --force --all ---"
    git push --force --all || exit 1
 
    echo_yellow "--- Step: finished ！---"
}

#------------------------------------------------------------------------
#配置项目名称和路径等相关参数
#------------------------------------------------------------------------
filepath=$(cd "$(dirname "$0")"; pwd)
echo_blue "文件目录: ${filepath}"

fileName=${filepath##*/}
#echo "fileName_${fileName}"

fileNameAll="$1"
echo_blue "查找文件: ${fileNameAll}"

#result=$(echo ${fileNameAll} | grep ".podspec")
#if [[ "$result" != "" ]]
if [ -d "$fileNameAll" ]
then
   # echo_green "--- 存在：${fileNameAll} ---"
   echo_green "--- 发现lib: $(datetime) ---"
   linkRepo $fileNameAll;
else
   echo_red "--- lib不存在：${fileNameAll}，创建本地lib ---"
   createLib $fileNameAll;
fi


