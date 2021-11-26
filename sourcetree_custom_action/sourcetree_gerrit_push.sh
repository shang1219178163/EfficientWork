#!/bin/sh

#  push.sh
#  KeepRunning

# 获取当前分支名
branch=`git symbolic-ref --short -q HEAD`
# push review
git push origin HEAD:refs/for/${branch}