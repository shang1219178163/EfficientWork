## Flutter高级技巧

#### 一、Android Studio 快捷键
1、option+enter 可以在某一层添加或者移除一个Widget；
2、在组件类中按住 按住 command + 鼠标可以显示项目中使用此组件的地方；
3、鼠标点击组件然后选择菜单栏 navigate -》type hierarchy 会显示此组件继承关系；

#### 二、analysis_options.yaml
```dart
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - avoid_print
    # 局部变量类型可推断时省略注解（所有 Flutter 项目统一约定）
    - omit_local_variable_types

# 关键：排除大目录的文件监听
analyzer:
  errors:
    avoid_unnecessary_containers: ignore
    unused_local_variable: ignore
  exclude:
    - "build/**"
    - ".dart_tool/**"
    - "local_sdk/**"
    - "ios/**"
    - "android/**"
    - "linux/**"
    - "windows/**"
    - "macos/**"
    - "web/**"

formatter:
  page_width: 120 # ← 设置你想要的行宽
```

#### 三、Package

1、使用 flutter_launcher_icons 包，更换图片之后通过命令一键替换AppIcon

    flutter pub run flutter_launcher_icons
    
2、使用 flutter_native_splash 包，更换图片之后通过命令一键替换启动图

    dart run flutter_native_splash:create
    

