<img src="https://raw.githubusercontent.com/ReactiveX/RxSwift/master/assets/Rx_Logo_M.png" alt="" width="36" height="36"> EfficientWork
====================================== 

![帮助大家省出时间去享受生活](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/Beach.png?raw=true)

##第一篇章： IconAndLaunch — iOS app图标和启动图一键生成
```
(目前支持到iOS12 iPhone XS Max)
1. 将自己的图片替换命名为AppIcon.png/AppLaunch.png 替换原文件；
2. 终端此文件下执行：sh AppIcon.sh/AppLaunch.sh，对应生成AppIcon.appiconset/LaunchImage.launchimage文件夹（或者AppIcon.sh/AppLaunch.sh 下拉菜单打开方式选终端）
3. 将生成的文件夹根据需要拖入项目中即可；

app图标生成支持iPhone、iPad、iMac三种类型图标；启动图仅支持iPhone。
备注： 执行操作之前最好在 https://tinypng.com/ 进行压缩，达到最优体积。
```

## Fastlane_lazy — iOS app自动化集成/打包
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

## CodeHelper — App代码助手（ObjC && Swift）

功能：
1.自己开发的字符串生成模型文件，目前支持MJExtension、YYModel、HandyJson
2.根据属性一键生成lazy方法

[CodeHelper.dmg](https://github.com/shang1219178163/MacTemplet/releases/tag/release1.1.0)

![效果图](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/screenshot.png?raw=true)
![效果图](https://github.com/shang1219178163/EfficientWork/blob/master/Resource/screenshot1.png?raw=true)




