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
