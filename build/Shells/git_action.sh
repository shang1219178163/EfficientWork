#!/bin/bash

#第一个参数为lib库文件
#libCreateAndLinkRepo(){
#    username=shang1219178163
#    echo_green "--- ${username}: $1 ---"
#
#    echo_green "--- Step: pod lib create $1 --template-url=https://github.com/$username/pod-template.git ---"
#    pod lib create $1 --template-url=https://github.com/$username/pod-template.git || exit 1
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

#第一个参数为文件名称*.podspec
gitUpdatePod(){
    version=$(grep -E 's\.version.+=' $1 | grep -E '[0-9][0-9.]+' -o)
    # echo_green "--- version: ${version} ---"
    echo_green "--- $1: ${version} ---"

    echo_green "--- Step: pull from remote ---"
    git pull || exit 1

    echo_green "--- Step: add changes to local reposit ---"
    git add . || exit 1

    echo_green "--- Step: commit changes to local reposit ---"
    git commit -m "update" || exit 1

    echo_green "--- Step: push changes to remote reposit ---"
#    git push -u origin master || exit 1
    git push || exit 1

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

