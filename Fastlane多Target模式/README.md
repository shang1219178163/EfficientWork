# Fastlane 多Target模式
  因项目需要开发定制版，所以项目开始多Target模式。
  
### 使用方法：

  1.修改verison值（Build为脚本自动设置yyyyMMddHHmm）
  
  2.把项目文件夹拖入终端窗口;
  
  3.执行命令： 
  fastlane release 打包并上传到appStore;
  fastlane fir 打包上传到fir;
  
  fastlane releaseOne 打包targetOne并上传到appStore;
  fastlane firOne 打包targetOne上传到fir;
  
  ···
  targetTwo
  targetThree
  同理