# ColorScheme 颜色说明

```dart
/// 当前颜色方案的整体亮度。
final Brightness brightness;

/// 在应用界面和组件中最常使用的颜色。
final Color primary;

/// 在 [primary] 背景上清晰可见的颜色。
///
/// 为保证应用的可访问性，建议 [primary] 与 [onPrimary]
/// 之间的对比度至少达到 4.5:1。参见：
/// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
final Color onPrimary;

/// 用于强调程度低于 [primary] 的元素颜色。
Color get primaryContainer => _primaryContainer ?? primary;

/// 在 [primaryContainer] 背景上清晰可见的颜色。
///
/// 为保证应用的可访问性，建议 [primaryContainer] 与
/// [onPrimaryContainer] 之间的对比度至少达到 4.5:1。
/// 参见：
/// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
Color get onPrimaryContainer => _onPrimaryContainer ?? onPrimary;

/// [primaryContainer] 的固定颜色替代方案，
/// 在深色主题和浅色主题中保持相同颜色。
Color get primaryFixed => _primaryFixed ?? primary;

/// 用于显示在 [primaryFixed] 颜色元素之上的文本和图标颜色。
Color get onPrimaryFixed => _onPrimaryFixed ?? onPrimary;

/// 相较于 [onPrimaryFixed] 提供更低强调级别的文本和图标颜色。
Color get onPrimaryFixedVariant => _onPrimaryFixedVariant ?? onPrimary;

/// 用于 UI 中较低视觉权重组件的强调色，例如筛选芯片（Filter Chip），
/// 同时扩展整体色彩表达能力。
final Color secondary;

/// 在 [secondary] 背景上清晰可见的颜色。
///
/// 为保证应用的可访问性，建议 [secondary] 与 [onSecondary]
/// 之间的对比度至少达到 4.5:1。参见：
/// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
final Color onSecondary;

/// 用于强调程度低于 [secondary] 的元素颜色。
Color get secondaryContainer => _secondaryContainer ?? secondary;

/// 在 [secondaryContainer] 背景上清晰可见的颜色。
///
/// 为保证应用的可访问性，建议 [secondaryContainer] 与
/// [onSecondaryContainer] 之间的对比度至少达到 4.5:1。
/// 参见：
/// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
Color get onSecondaryContainer => _onSecondaryContainer ?? onSecondary;

/// [secondaryContainer] 的固定颜色替代方案，
/// 在深色主题和浅色主题中保持相同颜色。
Color get secondaryFixed => _secondaryFixed ?? secondary;

/// 用于强调程度高于 [secondaryFixed] 的元素颜色。
Color get secondaryFixedDim => _secondaryFixedDim ?? secondary;

/// 用于显示在 [secondaryFixed] 颜色元素之上的文本和图标颜色。
Color get onSecondaryFixed => _onSecondaryFixed ?? onSecondary;

/// 相较于 [onSecondaryFixed] 提供更低强调级别的文本和图标颜色。
Color get onSecondaryFixedVariant => _onSecondaryFixedVariant ?? onSecondary;

/// 第三强调色，用于与 [primary]、[secondary] 形成对比，
/// 或为某些元素提供更高关注度，例如输入框。
Color get tertiary => _tertiary ?? secondary;

/// 在 [tertiary] 背景上清晰可见的颜色。
///
/// 为保证应用的可访问性，建议 [tertiary] 与 [onTertiary]
/// 之间的对比度至少达到 4.5:1。参见：
/// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
Color get onTertiary => _onTertiary ?? onSecondary;

/// 用于强调程度低于 [tertiary] 的元素颜色。
Color get tertiaryContainer => _tertiaryContainer ?? tertiary;

/// 在 [tertiaryContainer] 背景上清晰可见的颜色。
///
/// 为保证应用的可访问性，建议 [tertiaryContainer] 与
/// [onTertiaryContainer] 之间的对比度至少达到 4.5:1。
/// 参见：
/// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
Color get onTertiaryContainer => _onTertiaryContainer ?? onTertiary;

/// [tertiaryContainer] 的固定颜色替代方案，
/// 在深色主题和浅色主题中保持相同颜色。
Color get tertiaryFixed => _tertiaryFixed ?? tertiary;

/// 用于强调程度高于 [tertiaryFixed] 的元素颜色。
Color get tertiaryFixedDim => _tertiaryFixedDim ?? tertiary;

/// 用于显示在 [tertiaryFixed] 颜色元素之上的文本和图标颜色。
Color get onTertiaryFixed => _onTertiaryFixed ?? onTertiary;

/// 相较于 [onTertiaryFixed] 提供更低强调级别的文本和图标颜色。
Color get onTertiaryFixedVariant => _onTertiaryFixedVariant ?? onTertiary;

/// 用于输入校验错误等场景的颜色，例如 [InputDecoration.errorText]。
final Color error;

/// 在 [error] 背景上清晰可见的颜色。
///
/// 为保证应用的可访问性，建议 [error] 与 [onError]
/// 之间的对比度至少达到 4.5:1。参见：
/// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
final Color onError;

/// 用于强调程度低于 [error] 的错误状态颜色。
Color get errorContainer => _errorContainer ?? error;

/// 在 [errorContainer] 背景上清晰可见的颜色。
///
/// 为保证应用的可访问性，建议 [errorContainer] 与
/// [onErrorContainer] 之间的对比度至少达到 4.5:1。
/// 参见：
/// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
Color get onErrorContainer => _onErrorContainer ?? onError;

/// 用于 [Scaffold] 等组件的背景色。
final Color surface;

/// 在 [surface] 背景上清晰可见的颜色。
///
/// 为保证应用的可访问性，建议 [surface] 与 [onSurface]
/// 之间的对比度至少达到 4.5:1。参见：
/// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
final Color onSurface;

/// 在深色主题和浅色主题中始终最暗的表面颜色。
Color get surfaceDim => _surfaceDim ?? surface;

/// 在深色主题和浅色主题中始终最亮的表面颜色。
Color get surfaceBright => _surfaceBright ?? surface;

/// 最浅色调、相对于 surface 强调程度最低的表面容器颜色。
Color get surfaceContainerLowest => _surfaceContainerLowest ?? surface;

/// 比 [surfaceContainer] 强调程度更低、
/// 但高于 [surfaceContainerLowest] 的浅色表面容器颜色。
Color get surfaceContainerLow => _surfaceContainerLow ?? surface;

/// 用于表面区域内部独立内容区块的推荐颜色角色。
///
/// Surface Container 系列颜色与海拔（Elevation）无关。
/// 它们取代了旧版基于透明度叠加的模型，
/// 旧模型会根据海拔高度在表面颜色上叠加一层着色蒙版。
///
/// Surface Container 包括：
/// [surfaceContainerLowest]、
/// [surfaceContainerLow]、
/// [surfaceContainer]、
/// [surfaceContainerHigh]、
/// [surfaceContainerHighest]。
Color get surfaceContainer => _surfaceContainer ?? surface;

/// 色调更深的表面容器颜色。
///
/// 强调程度高于 [surfaceContainer]，
/// 但低于 [surfaceContainerHighest]。
Color get surfaceContainerHigh => _surfaceContainerHigh ?? surface;

/// 色调最深的表面容器颜色。
///
/// 用于在表面背景上产生最强的视觉强调效果。
Color get surfaceContainerHighest => _surfaceContainerHighest ?? surface;

/// 在 [surfaceVariant] 背景上清晰可见的颜色。
///
/// 为保证应用的可访问性，建议 [surfaceVariant]
/// 与 [onSurfaceVariant] 之间的对比度至少达到 4.5:1。
/// 参见：
/// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
Color get onSurfaceVariant => _onSurfaceVariant ?? onSurface;

/// 用于创建边界和强调效果的辅助颜色，
/// 以提升界面的可用性。
Color get outline => _outline ?? onBackground;

/// 用于装饰性边界的辅助颜色。
///
/// 当不需要达到 3:1 对比度要求时可使用，
/// 例如分割线或纯装饰元素。
Color get outlineVariant => _outlineVariant ?? onBackground;

/// 用于绘制具有海拔效果组件阴影的颜色。
Color get shadow => _shadow ?? const Color(0xff000000);

/// 用于绘制模态组件外围遮罩层（Scrim）的颜色。
Color get scrim => _scrim ?? const Color(0xff000000);

/// 反向表面颜色。
///
/// 用于显示与周围 UI 相反的视觉效果，
/// 例如 SnackBar 中的背景色，
/// 以增强提示信息的关注度。
Color get inverseSurface => _inverseSurface ?? onSurface;

/// 在 [inverseSurface] 背景上清晰可见的颜色。
///
/// 为保证应用的可访问性，建议 [inverseSurface]
/// 与 [onInverseSurface] 之间的对比度至少达到 4.5:1。
/// 参见：
/// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
Color get onInverseSurface => _onInverseSurface ?? surface;

/// 用于 [inverseSurface] 背景上的强调色。
///
/// 常见于 SnackBar 中的按钮文字等需要突出显示的元素。
Color get inversePrimary => _inversePrimary ?? onPrimary;

/// 用于表示组件海拔高度的表面着色颜色。
///
/// 通常作为覆盖层叠加在 surface 上。
Color get surfaceTint => _surfaceTint ?? primary;
