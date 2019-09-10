# Fastlane 多Target模式
  因项目需要开发定制版，所以项目开始多Target模式。
  
### 使用方法：

  1.修改verison值（Build为脚本自动设置yyyyMMddHHmm）
  
  2.把项目文件夹拖入终端窗口;
  
  3.执行命令： 
  fastlane release 打包并上传到appStore;
  fastlane fir 打包上传到fir;
  
  fastlane releaseA 打包 targetA 并上传到 appStore;
  fastlane firA 打包 targetA 上传到 fir;
  
  ···
  targetB
  targetC
  同理