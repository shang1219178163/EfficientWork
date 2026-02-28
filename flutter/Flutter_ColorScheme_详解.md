# Flutter ColorScheme 属性详解（Flutter 3.24 / Material 3）

## 🎨 一、ColorScheme 是什么？

`ColorScheme` 是 **Flutter Material 3 主题的核心配色系统**，所有组件（如
Button、AppBar、Dialog、TextField 等）都从中取色。\
它定义了一个完整的色彩语义层（semantic color roles），而非具体组件颜色。

> ✅ **推荐实践**：\
> 不要直接设组件颜色，优先通过 `colorScheme` 管理统一风格。

------------------------------------------------------------------------

## 🌈 二、属性总览（Flutter 3.24 全版）

  --------------------------------------------------------------------------------------------------------------
  属性名                        类型              说明                               常用示例用途
  ----------------------------- ----------------- ---------------------------------- ---------------------------
  **primary**                   Color             主要品牌色，UI 主色                按钮、选中状态、FAB

  **onPrimary**                 Color             与 primary 对比的前景色            文字/Icon（在主色背景上）

  **primaryContainer**          Color             次级主色容器                       Card、Chip 背景

  **onPrimaryContainer**        Color             容器内容前景色                     Card 内文字

  **secondary**                 Color             辅助色                             标签、状态标识

  **onSecondary**               Color             secondary 上的前景色               文字/Icon

  **secondaryContainer**        Color             辅助容器背景                       Chip、Badge

  **onSecondaryContainer**      Color             辅助容器文字                       

  **tertiary**                  Color             第三级强调色                       装饰、分割线、信息强调

  **onTertiary**                Color             三级色上的前景色                   

  **tertiaryContainer**         Color             第三级容器背景                     

  **onTertiaryContainer**       Color             第三级容器前景                     

  **error**                     Color             错误色                             表单错误、警示

  **onError**                   Color             错误背景前景色                     

  **errorContainer**            Color             错误色容器                         

  **onErrorContainer**          Color             错误容器文字                       

  **background**                Color             页面背景色                         Scaffold 背景

  **onBackground**              Color             背景上的前景色                     

  **surface**                   Color             主要表面颜色                       Card、Dialog 背景

  **onSurface**                 Color             表面文字/Icon                      

  **surfaceVariant**            Color             次级表面色（有层次的背景）         

  **onSurfaceVariant**          Color             次级表面文字/Icon                  

  **outline**                   Color             轮廓线颜色                         边框、分割线

  **outlineVariant**            Color             次级轮廓线                         

  **shadow**                    Color             阴影颜色                           

  **scrim**                     Color             遮罩层颜色（如弹窗背景）           

  **inverseSurface**            Color             相反表面色（如暗模式）             

  **onInverseSurface**          Color             反向表面文字色                     

  **inversePrimary**            Color             在反向背景上的主色（用于暗模式）   

  **surfaceTint**               Color             表面叠加色（组件动态着色）         

  **surfaceBright**             Color             亮面（Material 3 细分表面）        

  **surfaceDim**                Color             暗面（Material 3 细分表面）        

  **surfaceContainerLowest**    Color             最浅层容器色                       

  **surfaceContainerLow**       Color             次浅容器色                         

  **surfaceContainer**          Color             默认容器色                         

  **surfaceContainerHigh**      Color             深容器色                           

  **surfaceContainerHighest**   Color             最深容器色                         
  --------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------

## 🧩 三、ColorScheme 示例（明亮 + 黑暗主题）

``` dart
final lightColorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF0061A4),
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFD1E4FF),
  onPrimaryContainer: Color(0xFF001D36),
  secondary: Color(0xFF535F70),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFD7E3F7),
  onSecondaryContainer: Color(0xFF101C2B),
  tertiary: Color(0xFF6B5778),
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFF2DAFF),
  onTertiaryContainer: Color(0xFF251431),
  error: Color(0xFFBA1A1A),
  onError: Colors.white,
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFBFCFF),
  onBackground: Color(0xFF191C20),
  surface: Color(0xFFFBFCFF),
  onSurface: Color(0xFF191C20),
  surfaceVariant: Color(0xFFDEE3EB),
  onSurfaceVariant: Color(0xFF42474E),
  outline: Color(0xFF72777F),
  outlineVariant: Color(0xFFC2C7CF),
  shadow: Colors.black,
  scrim: Colors.black54,
  inverseSurface: Color(0xFF2E3135),
  onInverseSurface: Color(0xFFF0F0F3),
  inversePrimary: Color(0xFF9ECAFF),
  surfaceTint: Color(0xFF0061A4),
);
```

------------------------------------------------------------------------

## ☯️ 四、亮暗主题快速生成

``` dart
final theme = ThemeData(
  colorScheme: lightColorScheme,
  useMaterial3: true,
);

final darkTheme = ThemeData(
  colorScheme: lightColorScheme.copyWith(brightness: Brightness.dark),
  useMaterial3: true,
);
```

> ✅ **最佳实践**：通过 `ColorScheme.fromSeed` 自动生成配色系统。

``` dart
final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
);
```

------------------------------------------------------------------------

## 🧠 五、ColorScheme 与组件的映射关系（核心对应）

  组件                      主要颜色来源
  ------------------------- -------------------------------------------
  AppBar                    primary / onPrimary
  FAB                       primary / onPrimary
  ElevatedButton            primary / onPrimary
  TextButton                primary
  OutlinedButton            outline / onSurface
  Dialog                    surface / onSurface
  Scaffold                  background / onBackground
  Card                      surfaceContainer / onSurfaceVariant
  Divider                   outlineVariant
  Chip                      secondaryContainer / onSecondaryContainer
  TextField                 surface / onSurfaceVariant / outline
  Switch、Checkbox、Radio   primary / onPrimaryContainer

------------------------------------------------------------------------

## 🧭 六、调试技巧

-   用 `Theme.of(context).colorScheme` 查看当前主题色；
-   在 `MaterialApp` 根部包一个 `Theme` 调试；
-   Flutter 3.24+ 可用 `MaterialDebugTheme` 工具查看层级色彩分布；
-   Flutter DevTools → "Flutter Inspector" → "Theme"
    标签可实时预览色表。

------------------------------------------------------------------------

## 🧩 七、快速自定义模板

``` dart
ThemeData customTheme(Color seed, Brightness mode) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: mode,
    ),
    useMaterial3: true,
  );
}
```
