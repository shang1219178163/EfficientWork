<img src="https://raw.githubusercontent.com/ReactiveX/RxSwift/master/assets/Rx_Logo_M.png" alt="" width="36" height="36"> EfficientWork
====================================== 
 *_对于可以自动化，一劳永逸的部分，总是值得我们花费更多的时间和精力，毕竟这世界前进的本质就是效率。_*

![天魔曲](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/Beach.png?raw=true)

## 第一篇章： IconAndLaunch — iOS app图标和启动图一键生成
```
(目前支持到iOS12 iPhone XS Max)
1. 将自己的图片替换命名为AppIcon.png/AppLaunch.png 替换原文件；
2. 终端此文件下执行：sh AppIcon.sh/AppLaunch_iPhone.sh，对应生成AppIcon.appiconset/LaunchImage.launchimage文件夹（或者AppIcon.sh/AppLaunch_iPhone.sh 下拉菜单打开方式选终端）
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

#### （更上一层）： Fastlane 多Target模式
```
  因项目需要开发定制版，所以项目开始多Target模式。
  
### 使用方法：

  1.修改verison值（Build为脚本自动设置yyyyMMddHHmm）
  
  2.把项目文件夹拖入终端窗口;
  
  3.执行命令： 
  fastlane release 打包并上传到 appStore;
  fastlane fir 打包上传到 fir;
  
  fastlane releaseA 打包 targetOne 并上传到appStore;
  fastlane firA 打包 targetOne 上传到fir;
  
  ···
  targetTwo
  
  targetThree
  
  同理
```
![钉钉打包通知](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/dingding%E7%9A%84Screenshot.png?raw=true)

![slack打包通知](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/slack%E7%9A%84Screenshot.png?raw=true)

##### bundleVersion 脚本化：

![bundleVersion 脚本化](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/bundleVersion%20%E8%84%9A%E6%9C%AC%E5%8C%96.png?raw=true)
```
#bundleVersion根据工程运行时间自动生成
bundleVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
bundleVersion=$(date "+%Y%m%d%H%M")
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $bundleVersion" "$INFOPLIST_FILE"
```
## 第三篇章： CodeHelper — App代码助手（ObjC && Swift）

功能：

1.字符串生成模型文件，目前支持MJExtension、YYModel、HandyJson；

2.根据属性一键生成lazy方法；

[CodeHelper.dmg](https://github.com/shang1219178163/MacTemplet/releases/download/v1.3.2/CodeHelper.dmg)

![效果图](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/screenshot.png?raw=true)
![效果图](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/screenshot1.png?raw=true)


## 第四篇章： Pod组件库更新动作自动化 — 基于shell


使用方法：修改pod库之后，将Pod库文件夹拖入终端，输入命令 sh build.sh 运行即可

思路：

1.找到pod库*.podspec文件

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

2.获取文件中的version值

```

 version=$(grep -E 's\.version.+=' $1 | grep -E '[0-9][0-9.]+' -o)

```

3.执行git动作

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
![运行效果图](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/build%E8%BF%90%E8%A1%8C%E6%95%88%E6%9E%9C%E5%9B%BE.png?raw=true)

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
   ![效果图](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/logInfo.png?raw=true)

## 第五篇章： Xcode - CodeSnippets

CodeSnippets - 代码片段集，可以极快的录入预设代码,让工作效率翻倍的技巧。

操作方法：

1.将本项目CodeSnippets内所有文件拖入下边文件夹：
/Users/用户名/Library/Developer/Xcode/UserData/CodeSnippets

2.重启Xcode的软件。

3.点击Xcode右上角 {} 按钮，出现列表；右键单击任一即可出现使用菜单。
![效果图](https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/CodeSnippets1.png?raw=true)

效果图：
![](https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/CodeSnippets2.gif?raw=true)

git 管理 CodeSnippets:
	1. git clone https://github.com/shang1219178163/EfficientWork
	2. cd EfficientWork
	3. ./setup_snippets.sh

## 第六篇章：iOS Crash文件符号化

### 一. 操作步骤
#### 1.获取symbolicatecrash工具

打开终端输入以下命令：

find /Applications/Xcode.app -name symbolicatecrash -type f

//路径是：

/Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/symbolicatecrash

根据路径前往文件夹找到symbolicatecrash ，将其复制到刚才指定文件夹

##### 2.打包时产生的dSYM文件。

##### 3.崩溃时产生的Crash文件,XXX.crash。

打开终端，cd到当前文件夹，输入命令

./symbolicatecrash XX.crash XX.app.dSYM > result.crash

如果报错

 Error: "DEVELOPER_DIR" is not defined at ./symbolicatecrash 
 
 需要 执行命令
export DEVELOPER_DIR="/Applications/XCode.app/Contents/Developer"

然后重新 输入命令

./symbolicatecrash XX.crash XX.app.dSYM > result.crash


#### 二. 脚本方式

桌面创建一个debug文件夹，将dsym, crash文件，debug.sh放入其中，终端 cd 进该文件夹，执行 sh debug.sh 即可（ 0.txt, 1.txt 属于成功转化的崩溃日志）
├── 0.txt
├── 1.txt
├── app.dSYM
├── attachment-18041338411594966961crashlog-EABB45A1-4FAD-414C-92AF-0CF8F6743686..crash
├── attachment-9462394146614423376crashlog-26D38E76-FFDB-483E-8F45-8DEDCA802648..crash
└── debug.sh

##### lazy：懒人模式
1. debug文件夹复制到桌面，替换里边的 .dSYM；
2. 删除所有 .crash文件，拖入自己的 .crash文件；
3. 终端 cd 进该文件夹，执行 sh debug.sh 即可

## 第七篇章：iOS 模块化/组件化
 模块化/组件化的本质是项目具体模块的私有化仓库和私有化pod索引库组合达到 pod 公有库可以用 pod 命令安装的效果，万变的从来是形式而非思想。配合路由达成数据的高效通信又是另外一个知识点了。
（进行下边步骤前先配置ssh）
#### 一. 创建本地库并关联到远程仓库
1.创建 git 远程仓库

2.创建本地仓库

    pod lib create * 

3.关联远程仓库

    git remote add origin ‘url’

4.关联分支（track master）

    git branch --set-upstream-to=origin/master master

(暴力方法：如果一直关联失败，可以克隆远程仓库到本地，用远程仓库 git 替换 本地仓库 git)

5.若有创建 lisence 和 readme 文件，可能冲突

    git push --force --all

#### 二. Pod 公有库：
进入本地仓库文件目录，
1.打tag，tag值即为不同版本值（*.podspec 文件中s.version和此相同）

    git tag -a 1.0.0 -m ‘update’ 
    git push origin 1.0.0 （或者 git push origin --tags ）
    
2.校验是否包含错误

    pod spec lint --allow-warnings --use-libraries
    pod spec lint --verbose --use-libraries

3.推送自己库到Pod索引库（效果：可以通过 pod install安装）

    pod trunk push *.podspec --allow-warnings --use-libraries
    
    出现如下显示即代表提交成功(如果搜索不到 可尝试 pod repo update, pod setup)
    --------------------------------------------------------------------------------
    🎉  Congrats
    🚀  * (1.0.0) successfully published
    📅  December 11th, 22:55
    🌎  https://cocoapods.org/pods/*
    👍  Tell your friends!
    --------------------------------------------------------------------------------
    
#### 三. 私有库：
1.创建私有spec repo，专门存放私有库模块

2.添加到本地 pod 目录

    pod repo add [privateSpecRepoName] [privateGitPath]
    
3.续 pod 公有库 第1步，私有库校验

    pod lib lint --allow-warnings --use-libraries
    pod lib lint --verbose --use-libraries
    
4.校验通过之后，提交podspec到私有repo

    pod repo push [privateSpecRepoName] [libName].podspec
    
5.查看我们本地的Specs库：
    直接Findle ->右键 -> 前往文件夹 -> 输入：~/.cocoapods/repos ->点击前往 
    
6.终端执行一下进入我们的私有库管理Specs，git更新提交

    git add . 
    git commit -a -m "update"
    git pull origin master
    git push origin master

（私有库创建发布结束。）

---
##### 私有库使用：
1.podfile文件顶部添加

    source 'https://github.com/CocoaPods/Specs.git' //公有pod索引库
    source 'privateGitPath' //我们之前创建的私有pod索引库
    
2.执行 pod install， 你应该能你的私有库了，over。

#### （更上一层）：所有的一切都是基于本地仓库，如何优化本地仓库的创建呢？
```
1.fork 官方项目模板 [CocoaPods/pod-template](https://github.com/CocoaPods/pod-template)；
2.克隆到本地，需改 templates 中三种项目（ios/macos-swift/swift）模板，达到你的要求即可,
譬如国际化，纯代码化，基础组件添加，所有你需要的，省去之后创建多个本地库时的重复工作；
3.修改 NAME.podspec/NAME-osx.podspec 添加自己需要，删除不需要的；
4.setup中 所有 *.rb 文件需改，优化本地库创建流程；
5.其他（开源许可声明，Readme定制化），开心就好；

如何使用：
pod lib create 模块名 --template-url=https://github.com/*/pod-template.git

此方法也可以用来创建新项目（模块名改为项目名称即可，毕竟 Example 本身就是一个项目）
```

## 第八篇章：批量生成需求控制器文件、API请求文件、自定义视图文件
通过输入的文件名称字符串一键批量生成相应模板文件，自动出现在下载目录中。这已经属于针对每个人每个不同项目的定制化代码生成工具。实现不复杂，但是看着模块代码自动生成对应文件真TM的爽！
[BatchClassCreateController.swift](https://github.com/shang1219178163/MacTemplet/blob/master/MacTemplet/BatchClassCreateController.swift)

![](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/screenshot2.png?raw=true)
