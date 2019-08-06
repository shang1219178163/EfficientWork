<img src="https://raw.githubusercontent.com/ReactiveX/RxSwift/master/assets/Rx_Logo_M.png" alt="" width="36" height="36"> EfficientWork
====================================== 

![帮助大家省出时间去享受生活](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/Beach.png?raw=true)

## 第一篇章： IconAndLaunch — iOS app图标和启动图一键生成
```
(目前支持到iOS12 iPhone XS Max)
1. 将自己的图片替换命名为AppIcon.png/AppLaunch.png 替换原文件；
2. 终端此文件下执行：sh AppIcon.sh/AppLaunch.sh，对应生成AppIcon.appiconset/LaunchImage.launchimage文件夹（或者AppIcon.sh/AppLaunch.sh 下拉菜单打开方式选终端）
3. 将生成的文件夹根据需要拖入项目中即可；

app图标生成支持iPhone、iPad、iMac、iWatch四种类型图标；启动图仅支持iPhone。
备注： 执行操作之前最好在 https://tinypng.com/ 进行压缩，达到最优体积。
```

## 第二篇章： Fastlane_lazy — iOS app自动化集成/打包
```
lazy模式：因为同时负责多个项目，本着fastlane文件写一个就能所有项目拖过去直接用的目的而创建。（涉及到项目的地方已做除密处理）

使用方法：
1. 把actions和Fastfile拖入项目中的fastlane文件夹中；
2. 配置Fastfile文件中相关参数；
3. 修改verison值（Build为脚本自动设置yyyyMMddHHmm）；
4. 把项目文件夹拖入终端窗口；
5. 执行命令： 
  fastlane release 打包并上传到appStore；
  fastlane fir 打包上传到fir；
  
  使用注意：
  scheme的配置和项目实际情况一一对应（特别是多targt模式）；
```

## 第三篇章： CodeHelper — App代码助手（ObjC && Swift）

功能：

1.字符串生成模型文件，目前支持MJExtension、YYModel、HandyJson；

2.根据属性一键生成lazy方法；

[CodeHelper.dmg](https://github.com/shang1219178163/MacTemplet/releases/download/release_v1.3.0/CodeHelper.dmg)

![效果图](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/screenshot.png?raw=true)
![效果图](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/screenshot1.png?raw=true)


## 第四篇章： Pod组件库更新动作自动化 — 基于shell


使用方法：修改pod库之后，将Pod库文件夹拖入终端，输入命令 sh build.sh 运行即可

思路：

1. 找到pod库*.podspec文件

```
   filepath=$(cd "$(dirname "$0")"; pwd)
   echo ${filepath}

   fileName=${filepath##*/}
   echo "fileName_${fileName}"

   fileNameAll="${fileName}.podspec"
   echo "fileNameAll_${fileNameAll}"

   result=$(echo ${fileNameAll} | grep ".podspec")
   if [[ "$result" != "" ]]
   then
       *# echo_green "--- 存在：${fileNameAll} ---"*
       gitFuntion ${fileNameAll};

   else
       echo_bred "--- 不存在：${fileNameAll} ---"

   fi 
```

2. 获取文件中的version值

```

 version=$(grep -E 's\.version.+=' $1 | grep -E '[0-9][0-9.]+' -o)

```

3. 执行git动作

```
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
```

// 文件位置
![文件位置](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/pod_automtic_update.png?raw=true)
   
// 运行效果图
![运行效果图](https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/build%E8%BF%90%E8%A1%8C%E6%95%88%E6%9E%9C%E5%9B%BE.png?raw=true)

 附：颜色echo输出文件一个echo_color.sh

    send=`date '+%Y-%m-%d %H:%M:%S'`
    
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
   ![效果图](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/echo_color.png?raw=true)

    log "${send}"
    log debug "${send}"
    log info "${send}"
    log warn "${send}"
    log error "${send}"
   ![效果图](https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/logInfo.png?raw=true)

```