# Mac微信无法屏幕截图问题

mac 微信设置录屏，但是还是无法屏幕截图

macOS 权限数据库损坏（最常见）

如果之前升级过系统或者迁移过微信，经常出现：

权限显示已开启
实际无效

重置权限：

    tccutil reset ScreenCapture

或者仅重置微信：

    tccutil reset ScreenCapture com.tencent.xinWeChat

然后：

退出微信
再打开微信
系统会重新弹出授权窗口
点击允许