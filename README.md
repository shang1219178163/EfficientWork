<img src="https://raw.githubusercontent.com/ReactiveX/RxSwift/master/assets/Rx_Logo_M.png" alt="" width="36" height="36"> EfficientWork
====================================== 

## LaunchImage — iOS app启动图一键生成
```
1. 将自己的图片替换命名为Default 然后替换 Default.png；
2. 终端此文件下执行：sh AppLaunch.sh；
3. 然后将生成的LaunchImage.launchimage文件夹，拖入项目中即可；
```
--
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


