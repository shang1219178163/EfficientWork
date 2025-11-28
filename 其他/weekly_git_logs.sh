#!/bin/bash

# 获取当前 git 用户
current_user=$(git config user.name)
echo "Current Git User: $current_user"

# 遍历当前目录下所有一级子文件夹
for dir in */ ; do
    project="${dir%/}"

    # 检查是否 Git 仓库
    if [ -d "$project/.git" ]; then
        echo "Processing $project ..."

        # 当前项目的日志文件
        log_file="./${project}.txt"

        # 获取当前分支名
        branch=$(git -C "$project" rev-parse --abbrev-ref HEAD)

        echo "  - Branch: $branch"

        # 导出当前分支 + 当前用户的最近 5 天提交
        git -C "$project" log \
            "$branch" \
            --since="5 days ago" \
            --author="$current_user" \
            --pretty=format:"%s" \
            --date=short \
            > "$log_file"

        echo "  - Saved: $log_file"
    else
        echo "Skipping $project (not a git repo)"
    fi
done

echo "Done."
