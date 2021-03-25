# Fastlane 多Target模式
  因项目需要开发定制版，所以项目开始多Target模式。
  
### 使用方法：

  1.修改verison值（Build为脚本自动设置yyyyMMddHHmm）
  
  2.把项目文件夹拖入终端窗口;
  
  3.执行命令： 
  fastlane release 打包并上传到appStore, 
    追加参数 (to: pgy/fir/release) 发布到对应平台;
    
  fastlane develop 打包上传到pgy; 
    追加参数 (to: pgy/fir) 发布到对应平台;
    
  //打包并上传方法
  fastlane archive sign: develop/release, to: pgy/fir/release, target: A/B/C;
  
  //上传方法
  fastlane upload sign: develop/release, to: pgy/fir/release, target: A/B/C;
  
  //定制项目
  targetA
  targetB
  targetC
  ···