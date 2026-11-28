# 永久关闭 macOS 系统更新提醒（方案 C：提醒日期推到 2030 年）

> 适用：macOS Sequoia 15.x（其他现代 macOS 版本同样适用）
> 目标：系统自带的「有可用更新 / 新软件已可安装。」+「今晚尝试 / 安装」弹窗，永久不再出现。
> 特性：只改当前用户的偏好设置，**可逆、无需 sudo、不伤系统**。

## 原理

`softwareupdate` 弹提醒前会读取 `com.apple.SoftwareUpdate` 偏好里的通知日期。
把「下次提醒日期」写到 2030 年，系统就认为还没到提醒时间，弹窗自然不再出现。

## 操作步骤

终端执行（不需要 sudo）：

```bash
defaults write com.apple.SoftwareUpdate MajorOSUserNotificationDate -date "2030-02-07 23:22:47 +0000"
defaults write com.apple.SoftwareUpdate UserNotificationDate -date "2030-02-07 23:22:47 +0000"
```

## 验证

```bash
defaults read com.apple.SoftwareUpdate
```

输出中应包含：

```
MajorOSUserNotificationDate = "2030-02-07 23:22:47 +0000";
UserNotificationDate        = "2030-02-07 23:22:47 +0000";
```

## 撤销（恢复提醒）

```bash
defaults delete com.apple.SoftwareUpdate MajorOSUserNotificationDate
defaults delete com.apple.SoftwareUpdate UserNotificationDate
```

## 注意事项

1. **当前已弹出的提醒不会自动消失**，手动关掉即可，之后不会再冒。
2. 只屏蔽「提醒」，**不影响**手动安装更新：`系统设置 → 通用 → 软件更新` 里仍可检查和安装。
3. 如果手动进设置点了「检查更新」，日期可能被系统重置，届时重新执行一次命令即可。
4. 以后系统不再主动提醒安全更新，建议偶尔手动检查。
5. 该设置不阻止后台检查/下载更新；想更干净可配合方案 B：`系统设置 → 通用 → 软件更新 → 自动更新 ⓘ`，关掉「检查更新」。

## 为什么不推荐老办法

`sudo softwareupdate --ignore` 和 `sudo softwareupdate --schedule off` 在 Sequoia 上基本失效：
命令看似成功，但提醒依旧或很快恢复，因此改用上面的偏好日期法。
