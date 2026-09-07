#!/bin/bash

# 提取 version_name、version_code
yaml_file="pubspec.yaml"
if [[ ! -f "$yaml_file" ]]; then
    echo "错误: 找不到 $yaml_file 文件"
    exit 1
fi

version=$(grep 'version:' "$yaml_file" | awk '{print $2}')
if [[ -z "$version" ]]; then
    echo "错误: 无法提取版本信息"
    exit 1
fi

versionName=${version%%+*}  # 提取版本名称
versionCode=${version##*+}   # 提取版本代码

# 获取输入环境名称  test（beta、pre） prod 
while true; do
    echo "请选择环境: 1:test  2:pre  0:prod"; read -r envName
    case $envName in
        1) envName="test"; break ;;
        2) envName="pre"; break ;;
        0) envName="prod"; break ;;
        *) echo "请输入有效的选项 (1 或 2 或 0)" ;;
    esac
done

# 定义变量
appPrefix="kbisai"
timestamp=$(date +%Y-%m-%d-%H-%M)
apkFileName="${appPrefix}-${versionName}_${versionCode}_${timestamp}_${envName}.apk"

# 构建并重命名 apk 文件
if flutter build apk --release --dart-define=app_env=${envName}; then
    cp build/app/outputs/flutter-apk/app-release.apk build/app/outputs/flutter-apk/${apkFileName}
else
    echo "错误: APK 构建失败"
    exit 1
fi

# 输出路径
echo $'\n在编辑器中打开文件目录 (Cmd + 单击)'
echo $'\e[35m'"$(realpath "build/app/outputs/flutter-apk/")"$'\e[0m'

exit 0