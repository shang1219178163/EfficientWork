<img src="https://github.com/shang1219178163/EfficientWork/blob/master/Resource/avatar.jpg?raw=true" alt="" width="36" height="36">EfficientWork
====================================== 
 *_繁琐工作自动化，总是值得我们花费更多的时间和精力，毕竟推动这世界前进的本质就是效率。_*

![天魔曲](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/Beach.png?raw=true)

#### [MindMapping目录](https://github.com/shang1219178163/EfficientWork/tree/develop/MindMapping) 
包含 Flutter和移动h5开发的一些知识点总结（笔者夜观天象，发现大前端和全栈是未来技术的发展趋势，为愿意转型大前端的 iOS 开发者提供一些帮助）；
```
.
├── CodeSnippets（Xcode代码片段，提高开发效率）
├── Crash文件符号化
│   └── debug
├── Fastlane_lazy多Target模式
│   └── actions
├── IconAndLaunch（脚本生成图片）
│   ├── Shells
│   ├── iMac
│   │   └── AppIcon.appiconset
│   ├── iPhone
│   │   ├── AppIcon.appiconset
│   │   └── LaunchImage.launchimage
│   └── iWatch
│       └── AppIcon.appiconset
├── Linux命令
├── MindMapping（思维导图）
│   ├── Flutter编程知识
│   │   ├── Flutter状态管理
│   │   └── 其他
│   ├── MiniProgram
│   ├── Web编程知识
│   │   ├── HTML
│   │   ├── JavaScript
│   │   │   └── JavaScript 内置对象
│   │   ├── React
│   │   ├── Vue
│   │   │   └── 其他
│   │   ├── Web API
│   │   ├── Web CSS
│   │   ├── 其他
│   │   └── 浏览器原理相关
│   ├── iOS编程知识
│   │   ├── SwiftUI
│   │   │   └── 其他
│   │   └── 其他
│   ├── 其他
│   ├── 社会常识
│   └── 编程语言基础
├── Reveal
├── VSCode
│   └── snippets
├── android studio
│   └── LiveTemplate
├── build （iOS CocoaPods 库通过脚本化维护，提高50%的开发效率。）
│   └── Shells
├── flutter
│   ├── Fastlane疑难问题
│   ├── enhance
│   └── 其他
├── sourcetree_custom_action（sourcetree自定义命令）
│   └── doc
└── 其他
```
## 第一篇章： IconAndLaunch — iOS app图标和启动图一键生成
```
(目前支持到iOS12 iPhone XS Max)
1. 将自己的图片替换命名为AppIcon.png/AppLaunch.png 替换原文件；
2. 终端此文件下执行：sh AppIcon.sh/AppLaunch_iPhone.sh，对应生成AppIcon.appiconset/LaunchImage.launchimage文件夹（或者AppIcon.sh/AppLaunch_iPhone.sh 下拉菜单打开方式选终端）
3. 将生成的文件夹根据需要拖入项目中即可；

app图标生成支持iPhone、iPad、iMac、iWatch四种类型图标；启动图仅支持iPhone。
备注： 执行操作之前最好在 https://tinypng.com/ 进行压缩，达到最优体积。

启动图有黑边可以设置背景色和启动图一个颜色。
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
  fastlane release 打包上传到appStore；
  fastlane fir 打包上传到 firim；
  fastlane pgy 打包上传到 蒲公英；

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

（Mac OS 10.14之后，需要获取完全磁盘访问权限，才能访问Mail,Messages,Safari,Home，Time Machine backups等等为所有用户准备的工具区域。）
功能：

1.字符串生成模型文件，目前支持MJExtension、YYModel、HandyJson；

2.根据属性一键生成lazy方法；

[CodeHelper.dmg v2.4.0](https://github.com/shang1219178163/MacTemplet/releases/download/v2.4.0/CodeHelper.dmg)

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
    
发布成功后但是不能通过pod search到
在终端输入

    rm ~/Library/Caches/CocoaPods/search_index.json

完成后再搜索

    pod search *
    
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
#### （更上二层）：Pod 库脚本化
随着Pod库的数量逐渐增加，常用的七八个，长期维护的十几个，每次通过手敲 git 命令 创建维护升级 Pod 逐渐成为了一种负担（先不说命令是否记得住，记得全，不会敲错），遂花费几天时间脚本化。目录如下：

    ├── build
    │   ├── Shells
    │   │   ├── common.sh
    │   │   ├── echo_color.sh
    │   │   └── git_action.sh
    │   ├── create.sh (创建本地lib之后输入github密码创建远程repo)
    │   ├── push.sh (pod首次创建之后关联及其推送到repo)
    │   └── update.sh (pod库以后每次的版本升级)

如何使用：
(首先将每个脚本中的 username 改为自己的 github 用户名， 本地 ssh 配置)
1. create.sh 和 Shells 粘贴复制到桌面，进入终端该目录执行：sh create.sh PodName
2. 创建本地库成功后会要求输入用户密码，以创建远程pod库
3. repo 成功后执行 sh push.sh 本地库会关联并推送代码到远程库
...
添加pod文件，配置 *.podspec 文件等
...
4. （每次更新pod库 tag必须比之前大）修改完成后执行 sh update 即可。

至此从本地库创建，远程库创建，本地lib关联远程库repo，以及 脚本化升级Pod，完美实现。

## 第八篇章：批量生成需求控制器文件、API请求文件、自定义视图文件
通过输入的文件名称字符串一键批量生成相应模板文件，自动出现在下载目录中。这已经属于针对每个人每个不同项目的定制化代码生成工具。实现不复杂，但是看着模块代码自动生成对应文件真TM的爽！

[NNBatchClassCreateController.swift](https://github.com/shang1219178163/MacTemplet/blob/master/MacTemplet/NNBatchClassCreateController.swift)

![](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/screenshot2.png?raw=true)


## 第九篇章：Reveal - UI调试神器

<div align=center><img width="150" height="150" src="https://github.com/shang1219178163/EfficientWork/blob/master/Resource/Reveal.png?raw=true"/></div>

以前 XCode 本身支持的工具基本可以满足需求，但是随着 XCode 的升级和项目体积的增加，有些界面已经无法再支持分层可视化，随安装 Reveal 工具提高开发效率；

[Reveal 24(12917).dmg](https://pan.baidu.com/s/13IVbvF-EvAe48L9aq0giLg) 密码: sbjd

指导文档在 Reveal 文件夹之下，最简单的安装使用和升级问题解决办法；


## 第十篇章：TinyPNG4Mac

<div align=center><img width="150" height="150" src="https://github.com/shang1219178163/EfficientWork/blob/master/Resource/TinyPNG4Mac.jpeg?raw=true"/></div>

这是一个基于 https://tinypng.com/ 的 mac 客户端，使用的时候只需要拖拽到上面即可，操作高效便利。

[作者Github](https://github.com/kyleduo/TinyPNG4Mac)

## 第十一篇章：RxSwift && OC 链式编程

>凡是你觉得调用起来特别恶心的方法，都可以用链式封装调用，成倍的提高心情愉悦度和开发效率；

RxSwift 好处不用多说，积极拥抱即可；

链式编程：可以让程序变得优雅，开发更加高效

用 NSAttributedString 示例：
```
🌰🌰：
        let att0: NSMutableAttributedString = "Swift,".matt
            .font(UIFont.systemFont(ofSize: 16))
            .color(.systemBlue)
            .underline(.single, .red)
            .oblique(0.5)
            .link("https://www.hackingwithswift.com")
```

///Swift 属性链式编程实现
```
@objc public extension NSMutableAttributedString {
    
    func font(_ font: UIFont) -> Self {
        addAttributes([NSAttributedString.Key.font: font], range: NSMakeRange(0, self.length))
        return self
    }
    
    func color(_ color: UIColor) -> Self {
        addAttributes([NSAttributedString.Key.foregroundColor: color], range: NSMakeRange(0, self.length))
        return self
    }
    
    func bgColor(_ color: UIColor) -> Self {
        addAttributes([NSAttributedString.Key.backgroundColor: color], range: NSMakeRange(0, self.length))
        return self
    }
    
    func link(_ value: String) -> Self {
        return linkURL(URL(string: value)!)
    }
    
    func linkURL(_ value: URL) -> Self {
        addAttributes([NSAttributedString.Key.link: value], range: NSMakeRange(0, self.length))
        return self
    }
    //设置字体倾斜度，取值为float，正值右倾，负值左倾
    func oblique(_ value: CGFloat = 0.1) -> Self {
        addAttributes([NSAttributedString.Key.obliqueness: value], range: NSMakeRange(0, self.length))
        return self
    }
       
    //字符间距
    func kern(_ value: CGFloat) -> Self {
        addAttributes([.kern: value], range: NSMakeRange(0, self.length))
        return self
    }
    
    //设置字体的横向拉伸，取值为float，正值拉伸 ，负值压缩
    func expansion(_ value: CGFloat) -> Self {
        addAttributes([.expansion: value], range: NSMakeRange(0, self.length))
        return self
    }
    
    //设置下划线
    func underline(_ style: NSUnderlineStyle = .single, _ color: UIColor) -> Self {
        addAttributes([
            .underlineColor: color,
            .underlineStyle: style.rawValue
        ], range: NSMakeRange(0, self.length))
        return self
    }
    
    //设置删除线
    func strikethrough(_ style: NSUnderlineStyle = .single, _ color: UIColor) -> Self {
        addAttributes([
            .strikethroughColor: color,
            .strikethroughStyle: style.rawValue,
        ], range: NSMakeRange(0, self.length))
        return self
    }
    
    //设置删除线
    func stroke(_ color: UIColor, _ value: CGFloat = 0) -> Self {
        addAttributes([
            .strokeColor: color,
            .strokeWidth: value,
        ], range: NSMakeRange(0, self.length))
        return self
    }
    
    ///设置基准位置 (正上负下)
    func baseline(_ value: CGFloat) -> Self {
        addAttributes([.baselineOffset: value], range: NSMakeRange(0, self.length))
        return self
    }
    
    ///设置段落
    func paraStyle(_ alignment: NSTextAlignment,
                   lineSpacing: CGFloat = 0,
                   paragraphSpacingBefore: CGFloat = 0,
                   lineBreakMode: NSLineBreakMode = .byTruncatingTail) -> Self {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        style.lineBreakMode = lineBreakMode
        style.lineSpacing = lineSpacing
        style.paragraphSpacingBefore = paragraphSpacingBefore
        addAttributes([.paragraphStyle: style], range: NSMakeRange(0, self.length))
        return self
    }
        
    ///设置段落
    func paragraphStyle(_ style: NSMutableParagraphStyle) -> Self {
        addAttributes([.paragraphStyle: style], range: NSMakeRange(0, self.length))
        return self
    }
}

public extension String {
    
    /// -> NSMutableAttributedString
    var matt: NSMutableAttributedString{
        return NSMutableAttributedString(string: self)
    }
    
}

@objc public extension NSAttributedString {
    
    /// -> NSMutableAttributedString
    var matt: NSMutableAttributedString{
        return NSMutableAttributedString(attributedString: self)
    }
    
}

```
///OC 版本（兼容Swift）
```
//
//  NSMutableAttributedString+Chain.h
//  KTAttributedString
//
//  Created by Bin Shang on 2020/12/20.
//  Copyright © 2020 Shang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (Chain)

// addAttrs
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^addAttrs)(NSDictionary<NSAttributedStringKey, id> *);

// ParagraphStyle
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^paragraphStyle)(NSParagraphStyle *);

// Font
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^font)(UIFont *);
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^fontSize)(CGFloat);

// ForegroundColor
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^color)(UIColor *);

// BackgroundColor
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^bgColor)(UIColor *);

// Link
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^link)(NSString *);

// Link
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^linkURL)(NSURL *);

// Obliqueness
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^oblique)(CGFloat);

// Kern
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^kern)(CGFloat);

// Expansion
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^expansion)(CGFloat);

// Ligature
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^ligature)(NSUInteger);

// UnderlineStyle
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^underline)(NSUnderlineStyle, UIColor *);

// StrikethroughStyle(负值填充效果，正值中空效果)
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^strikethrough)(NSUnderlineStyle, UIColor *);

// Stroke
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^stroke)(UIColor *, CGFloat);

// StrokeWidth
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^baselineOffset)(CGFloat);

// Shadow
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^shadow)(NSShadow *);

// TextEffect
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^textEffect)(NSString *);

// Attachment
@property(nonatomic, strong, readonly) NSMutableAttributedString *(^attachment)(NSTextAttachment *);

@end


@interface NSString (Chain)

@property(nonatomic, strong, readonly) NSMutableAttributedString *matt;

@end


@interface NSAttributedString (Chain)

@property(nonatomic, strong, readonly) NSMutableAttributedString *matt;

@end

NS_ASSUME_NONNULL_END
```

```
//
//  NSMutableAttributedString+Chain.m
//  SwiftTemplet
//
//  Created by Bin Shang on 2020/12/20.
//  Copyright © 2020 Shang. All rights reserved.
//

#import "NSMutableAttributedString+Chain.h"

@implementation NSMutableAttributedString (Chain)

- (NSMutableAttributedString * _Nonnull (^)(NSDictionary<NSAttributedStringKey, id> * _Nonnull))addAttrs{
    return ^(NSDictionary<NSAttributedStringKey, id> * dic) {
        [self addAttributes:dic range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(NSParagraphStyle * _Nonnull))paragraphStyle{
    return ^(NSParagraphStyle *style) {
        [self addAttributes:@{NSParagraphStyleAttributeName: style} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(UIFont *))font {
    return ^(UIFont *font) {
        [self addAttributes:@{NSFontAttributeName: font} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(CGFloat))fontSize {
    return ^(CGFloat fontSize) {
        [self addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(UIColor *))color {
    return ^(UIColor *color) {
        [self addAttributes:@{NSForegroundColorAttributeName: color} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(UIColor *))bgColor {
    return ^(UIColor *color) {
        [self addAttributes:@{NSBackgroundColorAttributeName: color} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(NSString *))link {
    return ^(NSString *link) {
        [self addAttributes:@{NSLinkAttributeName: link} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(NSURL *))linkURL {
    return ^(NSURL *link) {
        [self addAttributes:@{NSLinkAttributeName: link} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(CGFloat))oblique {
    return ^(CGFloat value) {
        [self addAttributes:@{NSObliquenessAttributeName: @(value)} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(CGFloat))kern {
    return ^(CGFloat kern) {
        [self addAttributes:@{NSKernAttributeName: @(kern)} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(CGFloat))expansion {
    return ^(CGFloat value) {
        [self addAttributes:@{NSExpansionAttributeName: @(value)} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(NSUInteger))ligature {
    return ^(NSUInteger ligature) {
        [self addAttributes:@{NSLigatureAttributeName: @(ligature)} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(NSUnderlineStyle, UIColor *))underline {
    return ^(NSUnderlineStyle underline, UIColor *color) {
        [self addAttributes:@{NSUnderlineStyleAttributeName: @(underline)} range:NSMakeRange(0, self.length)];
        [self addAttributes:@{NSUnderlineColorAttributeName: color} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(NSUnderlineStyle, UIColor *))strikethrough {
    return ^(NSUnderlineStyle underline, UIColor *color) {
        [self addAttributes:@{NSStrikethroughStyleAttributeName: @(underline)} range:NSMakeRange(0, self.length)];
        [self addAttributes:@{NSStrikethroughColorAttributeName: color} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(UIColor * _Nonnull, CGFloat))stroke{
    return ^(UIColor *color, CGFloat value) {
        [self addAttributes:@{NSStrokeColorAttributeName: color} range:NSMakeRange(0, self.length)];
        [self addAttributes:@{NSStrokeWidthAttributeName: @(value)} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(NSShadow *))shadow {
    return ^(NSShadow *shadow) {
        [self addAttributes:@{NSShadowAttributeName: shadow} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(NSString *))textEffect {
    return ^(NSString *textEffect) {
        [self addAttributes:@{NSTextEffectAttributeName: textEffect} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(NSTextAttachment *))attachment {
    return ^(NSTextAttachment *attachment) {
        [self addAttributes:@{NSAttachmentAttributeName: attachment} range:NSMakeRange(0, self.length)];
        return self;
    };
}

- (NSMutableAttributedString *(^)(CGFloat))baselineOffset {
    return ^(CGFloat value) {
        [self addAttributes:@{NSBaselineOffsetAttributeName: @(value)} range:NSMakeRange(0, self.length)];
        return self;
    };
}

@end


@implementation NSString (Chain)

- (NSMutableAttributedString *)matt {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    return attributedString;
}

@end


@implementation NSAttributedString (Chain)

- (NSMutableAttributedString *)matt {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    return attributedString;
}

@end

```

附：OC 字符串常见操作链式化
```
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Chain)
/// 过滤字符集
@property(nonatomic, strong, readonly) NSString *(^trimmedBy)(NSString *);

@property(nonatomic, strong, readonly) NSString *(^subStringBy)(NSUInteger loc, NSUInteger len);

@property(nonatomic, strong, readonly) NSString *(^append)(NSString *);

@property(nonatomic, strong, readonly) NSString *(^appendFormat)(NSString *format, ... );

@property(nonatomic, strong, readonly) NSString *(^replace)(NSString *, NSString *);

@end

NS_ASSUME_NONNULL_END
```

```
#import "NSString+Chain.h"

@implementation NSString (Chain)

- (NSString *(^)(NSString *))trimmedBy{
    return ^(NSString *value) {
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:value];
        NSString *result = [self stringByTrimmingCharactersInSet:set];
        return result;
    };
}

- (NSString * _Nonnull (^)(NSUInteger, NSUInteger))subStringBy{
    return ^(NSUInteger loc, NSUInteger len) {
        if (loc + len > self.length) {
            return self;
        }
        NSString *result = [self substringWithRange:NSMakeRange(loc, len)];
        return result;
    };
}

- (NSString *(^)(NSString * _Nonnull))append{
    return ^(NSString *value){
        return [self stringByAppendingString:value];
    };
}

- (NSString * _Nonnull (^)(NSString * _Nonnull, ...))appendFormat{
    return ^(NSString *format, ...){
        va_list list;
        va_start(list, format);
        NSString *string = [[NSString alloc] initWithFormat:format arguments:list];
        va_end(list);
        NSString *result = [self stringByAppendingString:string];
        return result;
    };
}

- (NSString * _Nonnull (^)(NSString * _Nonnull, NSString * _Nonnull))replace{
    return ^(NSString *target, NSString *replacement){
        return [self stringByReplacingOccurrencesOfString:target withString:replacement];
    };
}

@end
```

[代码助手CodeHelper.dmg](https://github.com/shang1219178163/MacTemplet/releases)

## 第十二篇章：Text Scanner.app

<div align=center><img width="150" height="150" src="https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/AppIcon-TextScan.png?raw=true"/></div>

这是一个免费图片文字提取的 mac 客户端，使用的时候只需要拖拽图片或者截屏到上面，然后开始转化即可，操作高效便利。

####备用：[搜狗输入助手-图片转文字.app](https://apps.apple.com/cn/app/%E6%90%9C%E7%8B%97%E8%BE%93%E5%85%A5%E5%8A%A9%E6%89%8B-%E5%9B%BE%E7%89%87%E8%BD%AC%E6%96%87%E5%AD%97/id1621072638?mt=12)
<div align=center><img width="150" height="150" src="https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/AppIcon-sougou.png?raw=true"/></div>

## 第十三篇章：LiveTemplate 自定义
用 AndirodStudio 开发 dart 时极不方便

>当我熟悉了 XCode 中的 CodeSnippets 功能之后，就为此功能深深着迷，无输次拯救我敲代码不提示的抓狂；所以当用 Andriod Studio 创建 Dart 文件时，看见创建的文件一片空白，nothing !!! 这能忍？随无限谷歌之后找到 LiveTemplate （类 CodeSnippets）更强大，然后定义自己的快捷代码。

一.  Live template 是什么？
直译是“实时模板”，它的机制简单地说就是提前定义好一些通用的代码片段在编写代码时插入编辑器，使用方法类似代码补全；同时支持 Groovy 函数自定义，无限扩展。
```
///Groovy 函数自定义
groovyScript(<String>, [arg, ...])	
```

二. Live Template 如何自定义？

1. 点击添加一个Live Template 空白文件；
2. 填写 Abbreviation  缩写快捷键；
3. 描述（可选）；
4. Template Text 编写，然后 Edit variables（本质就是字符串加变量）；
5. 支持语言设置；
6. 点击 Apply，OK 生效； 

![6751620996088_.pic_hd.jpg](https://upload-images.jianshu.io/upload_images/281882-f0f5478c4d72a725.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

🌰🌰：
```
//
//  $fileName$
//  $projectName$
//
//  Created by $user$ on $date$ $time$.
//  Copyright © $year$ $user$. All rights reserved.
//
```
上边变量的对应关系为：
fileName 对应 fileName()
user 对应 user()
date 对应 date()
time 对应 time()
year 对应 date()

projectName 复杂一些，为工程名称，[官方预定义方法](https://www.jetbrains.com/help/idea/template-variables.html#predefined_functions) 并未提供相应的方法，所以就需要我们通过编写 groovyScript 代码来得到对应的结果，代码如下；
```
groovyScript("def list = _1.split('/'); def result = list[4]; return result;", filePath());
```
[groovy sdk 安装](https://blog.csdn.net/HUandroid/article/details/114359409)
VSCode 安装 [code runner 插件](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner) ；
[groovy 基础语法](https://www.w3cschool.cn/groovy/groovy_operators.html)


三. 如何导出导入？
（有时我们公司和家里电脑，需要导出导入进行同步）

![导出第一步.jpg](https://upload-images.jianshu.io/upload_images/281882-fdc7d8a6a1102c9f.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![导出第二步.jpg](https://upload-images.jianshu.io/upload_images/281882-4016cb08f421a486.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![导出结果.jpg](https://upload-images.jianshu.io/upload_images/281882-0dd4b7d32469e23d.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

[user.xml](https://github.com/shang1219178163/EfficientWork/blob/master/LiveTemplate/user.xml) 中就是我们自定义的 LiveTemplate；如果你有特别棒的模板，可以分享到 github ，一起 lazy 才是 nice ！

已定义模板 :
hCopyright
```
//
//  $fileName$
//  $projectName$
//
//  Created by $user$ on $date$ $time$.
//  Copyright © $year$ $user$. All rights reserved.
//
```

hstatelessWidget 
```
import 'package:flutter/material.dart';

class $fileName$ extends StatelessWidget {

  const $fileName$({
  	Key? key,
  	this.title,
  }) : super(key: key);
  
 final String? title;

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(arguments[1]),
        ),
        body: Text(arguments.toString())
    );
  }
}

```
hStatefulWidget
```
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class $fileName$ extends StatefulWidget {

  final String? title;

  $fileName$({ Key? key, this.title}) : super(key: key);

  
  @override
  _$fileName$State createState() => _$fileName$State();
}

class _$fileName$State extends State<$fileName$> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic arguments = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "$widget"),
        actions: ['done',].map((e) => TextButton(
          child: Text(e,
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => print(e),)
        ).toList(),
      ),
      body: Text(arguments.toString())
    );
  }

}
```
hswitch_int
```
switch ($value$) {
  case $pattern$:
    {

    }
    break;
  case $pattern1$:
    {

    }
    break;
  case $pattern2$:
    {
    }
    break;
  default:
    break;
}
```
hlayoutBuilder（根据当前可用约束条件布局，避免组件越界）
```
LayoutBuilder(
  builder: (context, constraints){
    
    return SizedBox();
  }
),
```
hstatefulBuilder（函数组件转 StatefulWidget）
```
StatefulBuilder(
  builder: (context, setState) {
    
    return SizedBox();
  }
),
```
## 第十四篇章：SourceTree 自定义命令
利用sourcetree自定义操作调用git-bash、cmd、powershell等命令执行工具，传入自定义脚本命令并运行。
mac： SourceTree/偏好设置/自定义操作

![](https://github.com/shang1219178163/EfficientWork/blob/master/sourcetree_custom_action/doc/sourecetree_custom_action.png?raw=true)

![](https://github.com/shang1219178163/EfficientWork/blob/master/sourcetree_custom_action/doc/sourecetree_custom_action2.png?raw=true)

sourcetree_gerrit_push.sh
```
#!/bin/bash
branchName=`git symbolic-ref --short -q HEAD` ##获取分支名
echo 推送到分支： $branchName
git push origin HEAD:refs/for/$branchName
read -p "按任意键关闭" -n 1
```

sourcetree_gerrit_add_tag.sh（flutter项目）
```
#!/bin/bash
#!/bin/zsh

#parse_yaml <*.yaml> <prefix>
#parse_yaml pubspec.yaml
function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

#addTag + version
function addTag_by_version(){
    local version=$1
    echo "--- version: $version ---"

    commitID=`git log -1 --pretty=%h`
    commitMessage=`git log -1 --pretty=format:"%s"`
    echo "--- commitID: $commitID ---"
    echo "--- commitMessage: $commitMessage ---"
    echo "--- Step: add tag to local reposit：$commitID - $commitMessage---"
#    echo "git tag ${version} $commitID -m \"$commitMessage\""
    git tag ${version} $commitID -m "$commitMessage" || exit 1

    echo "--- Step: push tag to remote reposit ---"
    git push origin ${version} || exit 1

    echo "--- Step: finished ！---"
}

#解析 pubspec.yaml 添加 tag
function addTag_by_yaml(){
    eval $(parse_yaml pubspec.yaml "yaml_")
    echo "--- version: $yaml_version ---"
    
    addTag_by_version $yaml_version
}

addTag_by_yaml

```
## 第十五篇章：VSCode extension 开发
个人开发插件 [easy-flutter-plugin ](https://marketplace.visualstudio.com/items?itemName=shang.easy-flutter-plugin)用于将 flutter plugin 功能简化；根据 lib dart方法一键生成 objc/swift + java/kotlin + web .dart + example/lib/.main.dart + test.dart 的方法生成；开发者只需要关注函数内部实现即可；模板化的工作让插件生成，提高开发效率； 

VSCode 插件开发发布

// 安装需要的包
npm install -g yo generator-code
// 运行命令，创建工程
yo code

。。。实现功能（推荐使用typescript）；

1.注册账号 https://aka.ms/SignupAzureDevOps；

2.创建 Personal Access Token
点击创建新的个人访问令牌，这里特别要注意Organization要选择all accessible organizations，Scopes要选择Full access，否则后面发布会失败。

3.打包发布
vsce package

vsce publish -p <*Personal Access Token*>

## 第十六篇章： VSCode - CodeSnippets 
很简单就不详细说了，vue 的插件本身支持不是什么特别好（相对flutter， iOS而言），所以需要大量自定义适合自己的代码片段来提高生产力。

## 第十七篇章：Syntax Highlight.app —— QuickLook 代码文件类型扩展
代码预览器神器，懂的都懂.
![Syntax Highlight.app](https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/Syntax%20Highlight.png?raw=true)

安装：
1. brew install --cask syntax-highlight
2. tag 下载

## 第十八篇章：搭建自己的前端开发脚手架（以 Vue 为例）

#### 一、是什么？
可以理解为为你从仓库克隆代码添加了一个中间层，你可以在项目模板的基础上进行业务方面的任意定制,名称、描述、关键字、作者等等。

#### 二、怎么做？
1.初始化一个npm项目

    mkdir test-cli && cd test-cli && npm init -y 

2.安装第三方依赖

    npm i chalk log-symbols ora download-git-repo fs-extra inquirer commander shelljs

3.在项目根目录下依次新建js文件

    cli.js：入口文件，负责调用初始化项目的执行函数；
    init.js：初始化项目函数的具体实现，负责调用下载模板、询问配置信息、安装依赖等工作；
    clone.js：下载远端git仓库模板；

4.修改package.json文件 type（commonjs（默认值），适用于Nodejs环境；module，即ES Module语法，适用于浏览器环境。）

    // package.json
    {
        "type": "module",
    }

5.设置执行命令以及对应的文件

    // package.json
    {
      ...,
      "bin": {
        "test-cli": "./cli.js"
      }
    }
    
    执行命令为test-cli，执行文件为./cli.js

6.开发调试
    
    在开发过程中，可通过将当前项目链接到全局的方式，然后再使用，避免每次将脚手架发布到npm仓库。在当前项目执行npm link，，则可以在...\AppData\Roaming\npm\node_modules中找到当前项目的一个链接，然后就可以在全局使用test-cli命令来创建项目。
    
7.发布与更新
    发布方式一
使用npm login[登录](https://www.npmjs.com/)npm仓库, 如果没有先注册;
使用npm publish将当前项目发布到npm仓库，稍等一会儿刷新即可使用;

每次发布代码前，需要更新package.json中的version字段；

[源码](https://github.com/shang1219178163/shang-cli)

#### 三、第三方依赖简介

chalk：终端字体颜色；
log-symbols：在终端上显示√或×等图标；
ora：终端显示下载中的动画；
download-git-repo：下载并提取git仓库；
fs-extra：删除非空文件夹；
inquirer：通用的命令行用户界面集合，用于交互；
commander：解析命令和参数，用于处理用户输入的命令；
shelljs：自动化处理重复的事；

#### 四、结束了吗？NO
重新介绍一下几个主角：

##### commander：完整的 node.js 命令行解决方案。[预览](https://github.com/shang1219178163/EfficientWork/blob/develop/MindMapping/Web%E7%BC%96%E7%A8%8B%E7%9F%A5%E8%AF%86/%E5%B7%A5%E5%85%B7commander.png)
##### fs-extra：系统fs模块的扩展，提供了更多便利的API，并继承了fs模块的API。[预览](https://github.com/shang1219178163/EfficientWork/blob/develop/MindMapping/Web%E7%BC%96%E7%A8%8B%E7%9F%A5%E8%AF%86/%E5%B7%A5%E5%85%B7fs-extra.png)
##### ShellJS：一个可移植的 （Windows/Linux/macOS） 在 Node.js API 之上实现的 Unix shell 命令。您可以使用它来消除shell脚本对Unix的依赖性，同时仍然保留其熟悉且功能强大的命令。你也可以全局安装它，这样你就可以从Node项目外部运行它 - 告别那些粗糙的Bash脚本！[预览](https://github.com/shang1219178163/EfficientWork/blob/develop/MindMapping/Web%E7%BC%96%E7%A8%8B%E7%9F%A5%E8%AF%86/%E5%B7%A5%E5%85%B7shelljs.png)

以三个库为核心你可以用 js 去实现任何你曾经想实现的shell脚本；之前也写过一些 shell脚本，但是用写起来是真的难受（shell大神请无视我）。换句话说，用 js 写自动化工具的世界已为你打开!

## 第十九篇章：VSCode 开发 flutter 小技巧
用 andriod studio 开发flutter时，可以在选定组件树之后通过 option + enter 唤醒重构菜单；

但是在 VSCode 中变为 ctr + shift + R；可以通过vscode的键盘快捷键自定义将 ctr + shift + R 修改为 option + enter，方便多个 ide 工具的习惯统一，提高工作效率。（因为某些原因，需要频繁的在 as 和 VSCode 之间来回切换使用）。

## 第二十篇章：iPhone 真机调试 iOS/Flutter 时截图/录屏快速获取 

![图像捕捉.app](https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/AppIcon-%E5%9B%BE%E5%83%8F%E6%8D%95%E6%8D%89.png?raw=true)

**打开 图像捕捉.app 选择下载文件夹，然后选择文件点击下载即可。（此方法比通过 AirDrop 传递快了无数倍。）**

## 第二十一篇章：flutter 开发时可以通过 Mac 的控制台应用过滤进程，查看特定app的日志信息

![控制台.app](https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/screenshot-%E6%8E%A7%E5%88%B6%E5%8F%B0.png?raw=true)

## 第二十二篇章：PNG压缩与格式转换工具 - iSparta
常用于图片转 webp
![iSparta.png](https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/iSparta.png?raw=true)

iSparta提供PNG等图片格式的图片压缩
PNG等格式向APNG、WebP格式的转换
APNG动图向动态WebP格式的转换

[iSparta 下载链接](http://isparta.github.io/)

## 第二十三篇章：ipa 文件体积瘦身分析工具 - OmniDiskSweeper
ipa体积太多，分析文件体积神器。
![OmniDiskSweeper.png](https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/OmniDiskSweeper.png?raw=true)

![screenshot-OmniDiskSweeper.png](https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/screenshot-OmniDiskSweeper.png?raw=true)

[OmniDiskSweeper 下载链接](http://files.omnigroup.com/software/macOS/11/)

## 第二十四篇章：Figma 转代码

如果你们使用 figma 可以使用 function12 自动生成 Flutter 代码；虽然不一定完全满足需求，但是能解决 80% 的基础布局。

https://function12.io/


## 第二十五篇章：Flutter 进阶：json 转 model 工具开发

![效果图](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/Flutter-jsonToModel.jpg?raw=true)

https://juejin.cn/spost/7307501392788471844

[JSON to Dart Model 网页版](https://shang1219178163.github.io/web_tool/#/file/json)

## 第二十六篇章：LocalSend
将文件分享到附近的设备。免费、开源、跨平台。可通过此app实现 mac 到安卓手机的apk 安装传输，不用等待上传下载的时间，真好。

![localsend](https://localsend.org/_nuxt/logo-512.aU8Z13Dx.png)

https://localsend.org/zh-CN/download

## 第二十七篇章：iOS隐私文件 PrivacyInfo.xcprivacy 生成工具
![ios_privacy_manifest_maker.png](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/ios_privacy_manifest_maker.png?raw=true)

https://wemakeapps.net/manifest-maker
[简单文档](https://wemakeapps.medium.com/how-to-quickly-get-a-privacyinfo-xcprivacy-file-for-your-ios-app-9b43e7b938fe)

## 第二十八篇章：使用AI工具编码
![Cursor](https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/Cursor.png?raw=true)
[Cursor下载](https://www.cursor.com/cn) 选择一个你觉的不错的AI编程工具，先尝试一个月。

## 第二十九篇章：Json To Dart Model 自定义
![Cursor](https://github.com/shang1219178163/EfficientWork/blob/develop/Resource/screenshot_json_to_model.png?raw=true)

[JsonToModel](https://shang1219178163.github.io/json_model/#/JsonToModel)

## 第三十篇章：使用 Flutter Inspector
Flutter Inspector 可以通过点击组件，快速定位到响应代码的位置，在调整 UI 阶段是最高效的定位方式。

## 第三十一篇章：使用 github action自动发布 pub package包

.github/workflows/publish.yml
[GitHub Actions](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets?tool=cli)

## 第三十三篇章：部分代码AI生成
使用 Cursor + figma/蓝湖 生产部分代码。

1、Cursor + figma
https://github.com/GLips/Figma-Context-MCP

2、Cursor + 蓝湖
https://github.com/dsphper/lanhu-mcp

## 第三十四篇章：用MCP flutter_agent_lens 分析应用性能
[flutter_agent_lens 用 MCP 服务，将 Flutter DevTools 暴露给 AI](https://mp.weixin.qq.com/s/aem5PBksrnrQ6U_bNT7ftA)

[flutter_agent_lens](
https://github.com/dhruvanbhalara/flutter_agent_lens)

flutter_agent_lens depends on dart_mcp >=0.1.0 which requires SDK version >=3.7.0 <4.0.0

## 第三十五篇章：分析项目架构
![archify](https://github.com/tt-a1i/archify/raw/main/docs/assets/archify-readme-hero.png)
[archify](https://github.com/tt-a1i/archify)

![Understand-Anything](https://github.com/Egonex-AI/Understand-Anything/raw/main/assets/hero.png)
[Understand-Anything](https://github.com/Egonex-AI/Understand-Anything)

## 第三十六篇章：待续。。。