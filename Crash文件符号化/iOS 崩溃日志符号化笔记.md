## iOS Crash文件符号化

### 一. 操作步骤
#### 1.获取symbolicatecrash工具

打开终端输入以下命令：

find /Applications/Xcode.app -name symbolicatecrash -type f

//路径是：

/Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/symbolicatecrash

根据路径前往文件夹找到symbolicatecrash ，将其复制到刚才指定文件夹

#### 2.打包时产生的dSYM文件。

#### 3.崩溃时产生的Crash文件,XXX.crash。

打开终端，cd到当前文件夹，输入命令

./symbolicatecrash XX.crash XX.app.dSYM > result.crash

如果报错

 Error: "DEVELOPER_DIR" is not defined at ./symbolicatecrash 
 
 需要 执行命令
export DEVELOPER_DIR="/Applications/XCode.app/Contents/Developer"

然后重新 输入命令

./symbolicatecrash XX.crash XX.app.dSYM > result.crash


### 二. 脚本方式

桌面创建一个debug文件夹，将dsym, crash文件，debug.sh放入其中，终端 cd 进该文件夹，执行 sh debug.sh 即可（ 0.txt, 1.txt 属于成功转化的崩溃日志）
├── 0.txt
├── 1.txt
├── app.dSYM
├── attachment-18041338411594966961crashlog-EABB45A1-4FAD-414C-92AF-0CF8F6743686..crash
├── attachment-9462394146614423376crashlog-26D38E76-FFDB-483E-8F45-8DEDCA802648..crash
└── debug.sh

#### lazy：懒人模式
1. debug文件夹复制到桌面，替换里边的 .dSYM；
2. 删除所有 .crash文件，拖入自己的 .carsh文件；
3. 终端 cd 进该文件夹，执行 sh debug.sh 即可
