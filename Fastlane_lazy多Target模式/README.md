# Fastlane 多Target模式
  因项目需要开发定制版，所以项目开始多Target模式。
  
### 配置 fastlane：

       1、安转 fastlane： 
          全局目录下执行： brew install fastlane --cask
       
       2、iOS 目录下执行：
           2.1 初始化
             fastlane init
           2.2 安装插件
            fastlane add_plugin pgyer
            fastlane add_plugin firim
       
       3、修改配置文件 
           3.1 .env 文件
               Apple_Id 改为自己的appstore上传账号
               
               IpaDir_Development 本地开发包存储路径
               IpaDir_AppStore 本地生产包存储路径
        
               Dingtalk_Url 一般是app测试群机器人url
               
          3.2 Fastfile 文件
               PgyerApiKey 改为团队的蒲公英 ApiKey
            
               FirToken 改为团队Firm token
  
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
  
  
===

### 问题

1. fastlane-credentials 报错
   https://github.com/fastlane/fastlane/tree/master/credentials_manager

2. This request is forbidden for security reasons - The API key in use does not allow this request
   https://github.com/fastlane/fastlane/issues/14372
   账号权限从开发者改为管理者；