# Flutter 问题列表

1、Exception: No Windows desktop project configured. 

解决办法：执行下边命令创建，注意最后的点

**flutter create .**

-------

2、Flutter error: "CocoaPods not installed or not in valid state."

解决办法：执行终端命令：

**open /Applications/Android\ Studio.app**

-------

3、andriod studio 设备下拉列表不显示平台

解决办法：项目添加平台支持

**flutter config --enable-macos-desktop**

**flutter config --enable-web**

**flutter config --enable-linux-desktop**

**flutter config --enable-windows-desktop**

**flutter config --enable-windows-uwp-desktop**


```
flutter run -d chrome
flutter run -d macos
flutter run -d linux
flutter run -d windows
flutter run -d winuwp
```

4、ios Invalid `Podfile` file: undefined method `dirname

（如果项目集成了 mPaaS）
解决办法：执行终端命令：

    sh <(curl -s http://mpaas-ios.oss-cn-hangzhou.aliyuncs.com/cocoapods/installmPaaSCocoaPodsPlugin.sh)

# Xcode 真机调试无法识别手机解决方法

1.退出xcode。
2.打开命令行工具，输入 sudo pkill usbmuxd ，输入密码.
3.重启xcode就可以到手机调试连接了.

# 依赖库报错

主工程 flutter pub get 之后，LocalPackages 中子工程也需要 flutter pub get 获取最新代码；


# 壳工程如果想断线保留，需要设为调试模式改为 release 模式

# 如果没有当前壳工程的机器证书，可以将 bundle id 进行修改