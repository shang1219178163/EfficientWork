# Flutter 组件树 diff 算法

Element.updateChild 源码：

```dart
Element? updateChild(Element? child, Widget? newWidget, Object? newSlot) {
  // 情况1：新 Widget 为 null → 移除子 Element
  if (newWidget == null) {
    if (child != null) deactivateChild(child);
    return null;
  }

  final Element newChild;
  if (child != null) {
    // 情况2：Widget 完全相同（identical），直接复用
    if (child.widget == newWidget) {
      newChild = child;
    } 
    // 情况3：类型和 key 相同但实例不同 → 更新 Element
    else if (Widget.canUpdate(child.widget, newWidget)) {
      child.update(newWidget);
      newChild = child;
    } 
    // 情况4：类型或 key 不同 → 销毁重建
    else {
      deactivateChild(child);
      newChild = inflateWidget(newWidget, newSlot);
    }
  } else {
    // 情况5：没有旧 Element → 创建新的
    newChild = inflateWidget(newWidget, newSlot);
  }

  return newChild;
}
```

性能优化关键点：

• 如果新旧 Widget 是同一个实例（const 或缓存），直接复用，不重建
• 如果类型和 key 相同但实例不同，调用 update，然后强制 rebuild(force: true)
• 如果类型或 key 不同，销毁重建