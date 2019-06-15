# Fastlane_lazy

  lazy模式——
  因为同时负责多个项目，本着fastlane文件写一个就能所有项目拖过去直接用的目的而创建。（涉及到项目的地方已做除密处理）

### 使用方法：

  1.修改verison值（Build为脚本自动设置yyyyMMddHHmm）
  
  2.把项目文件夹拖入终端窗口;
  
  3.执行命令： 
  fastlane release 打包并上传到appStore;
  fastlane fir 打包上传到fir;
  
  ### 使用注意：
  
  1.scheme的配置和项目实际情况一一对应（特别是多targt模式）;
  
  2.使用时注意本地和网络方法重名;

  
