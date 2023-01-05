

##### [iTMSTransporter] Error: Could not create the Java Virtual Machine.
下载文件 [items.zip](https://pan.baidu.com/s/1Op59V3aw8hLdjBPdbM6EGA)，解压其中文件覆盖到下面目录：
/usr/local/itms

--
##### 上传app报错（Unable to download a software component: com.apple.transporter.mediatoolkit/1.13.0）

报错信息：出现错误：
1.A downloaded software component is corrupted and will not be used.
解决方法：
打开文件夹：
/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/itms/bin/iTMSTransporter

2.Could not find proper version of fastlane (2.112.0) in any of the sources
解决方法：
remove Gemfile.lock in your project directory, and run 'fastlane init'

