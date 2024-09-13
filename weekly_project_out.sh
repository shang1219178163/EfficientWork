#!/bin/bash

#项目文件外部执行此脚本

project_name="*"

# 获取当前脚本所在目录的路径
script_dir=$(dirname "$(realpath "$0")")
echo "脚本所在目录: $script_dir"


# # 获取当前脚本的绝对路径
# script_path=$(realpath "$0")
# echo "当前脚本路径: $script_path"


target_dir="$script_dir/$project_name"

# 判断目录是否存在
if [ -d "$target_dir" ]; then
  # 进入目标目录
  cd "$target_dir" || { echo "无法进入目录: $target_dir"; exit 1; }
  echo "已进入目录: $(pwd)"
else
  echo "目录不存在: $target_dir"
fi



git_author=$(git show -s --format='%ae')
echo "git_author: $git_author"

git_branch=$(git rev-parse --abbrev-ref HEAD)
echo "git_branch: $git_branch"

# 获取当前日期的倒数5天的日期
date_start=$(date -v -5d +%Y-%m-%d)
echo "date_start: $date_start"

log_file_name="${project_name}_log.txt"
echo "log_file_name: $log_file_name"

git log --author="${git_author}" --after="$date_start" --pretty=format:"%s" > ../$log_file_name
