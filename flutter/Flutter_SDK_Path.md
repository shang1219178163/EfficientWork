# 项目中指定 Flutter SDK 路径

本文总结了在 Flutter 项目中**固定使用指定 Flutter SDK 版本**的最佳实践，适用于个人、团队与 CI 场景。

---

## 一、推荐方案：使用 FVM（Flutter Version Management）

### 1. 安装 FVM
```bash
brew install fvm
```

### 2. 在项目中指定 Flutter SDK 版本
```bash
fvm use 3.19.6
```

会生成以下文件：
```
.fvm/
.fvmrc
```

`.fvmrc` 示例：
```json
{
  "flutter": "3.19.6"
}
```

### 3. 项目内使用 Flutter
```bash
fvm flutter pub get
fvm flutter run
```

**优点**
- 团队成员版本一致
- 不影响全局 Flutter
- CI 友好

---

## 二、IDE 中指定 Flutter SDK 路径

### Android Studio / IntelliJ
```
Preferences
→ Languages & Frameworks
→ Flutter
→ Flutter SDK path
```

⚠️ 仅对当前 IDE 生效，不适合团队协作。

---

## 三、VS Code 项目级配置（不推荐）

```json
// .vscode/settings.json
{
  "dart.flutterSdkPath": "/Users/xxx/flutter_3.16.9"
}
```

缺点：
- 路径不可移植
- 只对 VS Code 生效

---

## 四、CI / 脚本中指定 Flutter SDK

### Shell 环境变量
```bash
export FLUTTER_ROOT=/opt/flutter_3.19.6
export PATH=$FLUTTER_ROOT/bin:$PATH
```

### GitHub Actions 示例
```yaml
- uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.19.6'
```

---

## 五、方案对比

| 场景 | 推荐方式 |
|------|----------|
| 团队 / 长期项目 | FVM |
| 单人临时验证 | IDE 指定 |
| CI 自动化 | flutter-action |
| 玩具项目 | 全局 Flutter |

---

## 六、结论

> **强烈建议：项目级使用 FVM，IDE 只是辅助。**

这样可以保证：
- Flutter 版本可控
- 环境可复现
- 升级 / 回滚安全

---
