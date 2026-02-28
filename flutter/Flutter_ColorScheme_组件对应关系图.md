# Flutter ColorScheme → 组件对应关系图（视觉版）

> **版本**：Flutter 3.24 / Material 3\
> **目标**：帮助开发者快速理解 ColorScheme 每个属性在 UI
> 中的实际作用区域。

------------------------------------------------------------------------

## 🎨 一、主色系（Primary）

  ----------------------------------------------------------------------------------------------
  语义色                   示例用途                    对应组件
  ------------------------ --------------------------- -----------------------------------------
  **primary**              应用主品牌色                AppBar、FAB、按钮、激活状态、滑块、开关

  **onPrimary**            主色背景上的前景文字/Icon   按钮文字、AppBar 标题

  **primaryContainer**     主色容器背景                Card、SegmentedButton、选中标签等

  **onPrimaryContainer**   容器文字/Icon               Container 内文字或图标

  **inversePrimary**       暗面上的主色                暗模式下反转使用，如 Tooltip、状态栏
  ----------------------------------------------------------------------------------------------

------------------------------------------------------------------------

## 💠 二、辅助色（Secondary）

  语义色                     示例用途              对应组件
  -------------------------- --------------------- -----------------------------
  **secondary**              辅助品牌色            Badge、Chip、Secondary 按钮
  **onSecondary**            辅助色背景文字/Icon   Chip 文字、次级按钮文字
  **secondaryContainer**     辅助容器背景          选中项背景、侧边栏选项高亮
  **onSecondaryContainer**   容器文字/Icon         侧边栏文字、Chip 内容

------------------------------------------------------------------------

## 💜 三、三级强调色（Tertiary）

  语义色                    示例用途                  对应组件
  ------------------------- ------------------------- ------------------------
  **tertiary**              装饰性强调色              图标、选中标识、信息色
  **onTertiary**            第三级背景上的文字/Icon   图标前景、强调文案
  **tertiaryContainer**     第三级容器背景            特殊组件底色、图表背景
  **onTertiaryContainer**   容器文字/Icon             信息提示、Badge

------------------------------------------------------------------------

## ❌ 四、错误色（Error）

  语义色                 示例用途                对应组件
  ---------------------- ----------------------- ----------------------------------
  **error**              错误提示主色            TextField 错误边框、验证错误提示
  **onError**            错误背景上的文字/Icon   错误文字、提示图标
  **errorContainer**     错误信息容器背景        Snackbar、提示框
  **onErrorContainer**   容器文字/Icon           错误提示文字

------------------------------------------------------------------------

## 🧱 五、背景与表面（Surface / Background）

  语义色                        示例用途         对应组件
  ----------------------------- ---------------- ----------------------------
  **background**                页面主背景       Scaffold、Drawer、页面底色
  **onBackground**              背景上的前景色   文本、图标
  **surface**                   表面主层         Card、Dialog、BottomSheet
  **onSurface**                 表面文字/Icon    Card 文字、Dialog 内容
  **surfaceVariant**            次级表面层       分隔区域、表格背景
  **onSurfaceVariant**          次级文字/Icon    次级信息文字
  **surfaceTint**               表面叠加层       Material 动态色调阴影
  **surfaceBright**             亮层容器         Light 模式层次分布
  **surfaceDim**                暗层容器         Dark 模式层次分布
  **surfaceContainerLowest**    最浅层容器       页面底部背景
  **surfaceContainerLow**       较浅容器         次级分组区
  **surfaceContainer**          默认容器层       普通卡片背景
  **surfaceContainerHigh**      深容器           浮层、卡片阴影层
  **surfaceContainerHighest**   最深容器         顶层对话框、弹窗背景

------------------------------------------------------------------------

## ✏️ 六、描边与结构（Outline）

  语义色               示例用途       对应组件
  -------------------- -------------- -------------------------
  **outline**          边框、分割线   TextField 边框、Divider
  **outlineVariant**   次级边框色     Disabled 状态边框

------------------------------------------------------------------------

## 🌗 七、反向与层叠（Inverse）

  语义色                 示例用途         对应组件
  ---------------------- ---------------- --------------------
  **inverseSurface**     暗面或反色背景   SnackBar、底部栏
  **onInverseSurface**   暗面文字/Icon    SnackBar 文字
  **inversePrimary**     暗面上的主色     暗背景中按钮、图标

------------------------------------------------------------------------

## ☁️ 八、阴影与遮罩

  语义色       示例用途   对应组件
  ------------ ---------- ------------------------------
  **shadow**   阴影层     Card、Dialog、FAB 阴影
  **scrim**    遮罩层     BottomSheet、Drawer 背景遮罩

------------------------------------------------------------------------

## 🧭 九、组件 → ColorScheme 快速映射表

  组件                            主要颜色属性
  ------------------------------- -------------------------------------------
  **AppBar**                      primary / onPrimary
  **FAB**                         primary / onPrimary
  **ElevatedButton**              primary / onPrimary
  **OutlinedButton**              outline / onSurface
  **TextButton**                  primary
  **IconButton**                  onSurface / primary
  **Chip / Badge**                secondaryContainer / onSecondaryContainer
  **Card**                        surfaceContainer / onSurfaceVariant
  **Dialog / BottomSheet**        surface / onSurface
  **TextField**                   surface / onSurfaceVariant / outline
  **Switch / Checkbox / Radio**   primary / onPrimaryContainer
  **SnackBar**                    inverseSurface / onInverseSurface
  **Divider / Border**            outline / outlineVariant
  **Scaffold 背景**               background / onBackground

------------------------------------------------------------------------

## 🌈 十、视觉分层关系图（语义视图）

    ┌──────────────────────────────────────┐
    │ Scaffold (background / onBackground) │
    │   ├─ Card (surface / onSurface)      │
    │   │   ├─ Button (primary / onPrimary)│
    │   │   ├─ Chip (secondaryContainer)   │
    │   │   └─ Error Text (error)          │
    │   ├─ Divider (outline)               │
    │   ├─ Dialog (surfaceContainerHigh)   │
    │   └─ SnackBar (inverseSurface)       │
    └──────────────────────────────────────┘

------------------------------------------------------------------------

## ✅ 推荐实践

-   使用 `ColorScheme.fromSeed(seedColor: Colors.blue)`
    自动生成主题色。\
-   优先使用 `Theme.of(context).colorScheme` 获取颜色。\
-   禁止直接硬编码颜色值。\
-   明暗主题共用语义层，便于维护。

------------------------------------------------------------------------

> © 2025 Flutter Material 3 深入指南 · 由 ChatGPT 自动整理\
> 版本：Flutter 3.24 及以上兼容
