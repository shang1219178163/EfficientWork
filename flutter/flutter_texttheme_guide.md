# Flutter TextTheme 详解（Flutter 3.24+ / Material 3）

## 🧱 一、TextTheme 是什么

`TextTheme` 定义了应用全局的文字样式集合，  
它是 `ThemeData` 的一部分，用于统一控制 App 内各处文字的大小、粗细、颜色、字体等。

```dart
ThemeData(
  textTheme: TextTheme(
    bodyMedium: TextStyle(fontSize: 16),
  ),
)
```

通过 `Theme.of(context).textTheme` 获取当前主题的文字样式。

---

## 📚 二、TextTheme 的所有字段（Flutter 3.24 / Material 3）

| 字段 | 默认字体大小 | 默认粗细 | 用途说明 |
|------|--------------|----------|----------|
| `displayLarge` | 57 | w400 | 超大标题，用于 Splash、欢迎页主标题 |
| `displayMedium` | 45 | w400 | 大标题，用于展示页主内容标题 |
| `displaySmall` | 36 | w400 | 标题，用于主屏内容区大字标题 |
| `headlineLarge` | 32 | w400 | 页面标题、详情页主标题 |
| `headlineMedium` | 28 | w400 | 内容区分区标题 |
| `headlineSmall` | 24 | w400 | 二级标题、卡片标题 |
| `titleLarge` | 22 | w500 | AppBar、对话框标题 |
| `titleMedium` | 16 | w500 | 列表项标题、按钮文字 |
| `titleSmall` | 14 | w500 | 标签、小标题 |
| `bodyLarge` | 16 | w400 | 主体文本（默认文字） |
| `bodyMedium` | 14 | w400 | 次级文本、小字说明 |
| `bodySmall` | 12 | w400 | 辅助信息、时间戳 |
| `labelLarge` | 14 | w500 | 按钮文字（如 ElevatedButton） |
| `labelMedium` | 12 | w500 | 次级按钮、标签 |
| `labelSmall` | 11 | w500 | 微标、小徽章 |

✅ **实际应用对照表**

| 常见组件 | 使用的 TextStyle |
|----------|-----------------|
| `TextField` | `bodyLarge` |
| `AppBar.title` | `titleLarge` |
| `ElevatedButton` | `labelLarge` |
| `TextButton` | `labelLarge` |
| `Chip` | `labelSmall` |
| `ListTile.title` | `titleMedium` |
| `ListTile.subtitle` | `bodyMedium` |

---

## 🎨 三、TextTheme 示例：完整定义 + 注释

```dart
final textTheme = const TextTheme(
  displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400), // 超大标题
  displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400), // 大标题
  displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400), // 标题
  headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w400), // 页面标题
  headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w400), // 区块标题
  headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w400), // 二级标题
  titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500), // AppBar / 对话框标题
  titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), // 列表项标题
  titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500), // 标签标题
  bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400), // 主体文本
  bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400), // 次级文本
  bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400), // 辅助文本
  labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500), // 按钮文字
  labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500), // 次级按钮
  labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500), // 徽章
);
```

---

## 🌗 四、在明暗模式中使用

```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  textTheme: textTheme.apply(
    bodyColor: Colors.black,
    displayColor: Colors.grey[800],
  ),
  brightness: Brightness.light,
);
```

暗模式：

```dart
textTheme.apply(
  bodyColor: Colors.white,
  displayColor: Colors.grey[300],
);
```

---

## 🧩 五、动态调整或局部覆盖

### 局部修改字体

```dart
Text(
  '标题',
  style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
);
```

### 全局字体替换

```dart
ThemeData(
  fontFamily: 'PingFang SC', // 全局中文字体
  textTheme: GoogleFonts.notoSansTextTheme(), // 使用 Google Fonts
);
```

---

## ⚙️ 六、最佳实践总结

| 场景 | 推荐 TextStyle | 说明 |
|------|----------------|------|
| 首页主标题 | `headlineLarge` | 层级清晰 |
| 二级模块标题 | `headlineSmall` | 视觉对比好 |
| 普通正文 | `bodyLarge` | 默认主文字 |
| 次级说明文字 | `bodyMedium` | 常用于备注 |
| 小字提示 | `bodySmall` | 比如时间、作者名 |
| 按钮文字 | `labelLarge` | Material3 按钮默认样式 |
| 小徽章 / 标签 | `labelSmall` | 视觉轻量 |

---

## 🚀 七、高级技巧

### 1️⃣ TextTheme 动态缩放（响应式）

```dart
MediaQuery.textScaleFactorOf(context)
```

结合自定义逻辑确保文字不被放大过多：

```dart
Text(
  '内容',
  textScaleFactor: min(MediaQuery.textScaleFactorOf(context), 1.2),
);
```

### 2️⃣ 不跟随系统字体缩放

```dart
MediaQuery(
  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
  child: MyApp(),
);
```

### 3️⃣ 与 Typography 联动（系统默认）

```dart
ThemeData(
  typography: Typography.material2021(platform: TargetPlatform.android),
);
```

---

## 🧠 八、视觉层级思维导图

```
TextTheme
├── Display (大标题组)
│   ├── displayLarge
│   ├── displayMedium
│   └── displaySmall
├── Headline (页面级标题)
│   ├── headlineLarge
│   ├── headlineMedium
│   └── headlineSmall
├── Title (组件级标题)
│   ├── titleLarge
│   ├── titleMedium
│   └── titleSmall
├── Body (正文组)
│   ├── bodyLarge
│   ├── bodyMedium
│   └── bodySmall
└── Label (按钮/徽章)
    ├── labelLarge
    ├── labelMedium
    └── labelSmall
```

---

## ✅ 九、总结要点

| 关键点 | 含义 |
|--------|------|
| `TextTheme` 控制全局文字风格 | 一处定义，全局生效 |
| Material 3 提供 13 个标准层级 | 从 Display → Label 层级明确 |
| 建议结合 `ColorScheme` | 让明暗模式自动适配 |
| 可用 `.apply()`、`.copyWith()` 灵活调整 | 高度可定制 |
| 支持全局字体 / 局部字体覆盖 | `fontFamily`、`GoogleFonts` 等 |
