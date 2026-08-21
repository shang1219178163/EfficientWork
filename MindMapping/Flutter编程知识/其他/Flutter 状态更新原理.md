# Flutter 状态更新原理

1. Flutter 的三棵树
要理解状态更新的原理，必须先了解 Flutter 的三棵树：

| 树 | 角色 | 特点 |
|:--|:--|:--|
| Widget 树 | 配置描述（immutable） | 轻量，每次 build 都可能重建 |
| Element 树 | 中间层，连接 Widget 和 RenderObject | 随 Widget diff 复用/创建/销毁 |
| RenderObject 树 | 实际布局和绘制 | 与 Element 同生共死 |

关键区别：

• Widget 只是配置数据，不持有运行时状态
• Element 持有 widget、renderObject、parent 等引用
• Element 管理生命周期和 dirty 状态

2. setState 的原理
当调用 setState 时，发生了什么？

```dart
void setState(VoidCallback fn) {
  fn();  // 同步执行状态变更
  _element!.markNeedsBuild();  // 标记 Element 需要重建
}
```

完整流程：
```dart
setState(fn)
    │
    ├── 1. 同步执行 fn()，更新状态
    │
    └── 2. _element.markNeedsBuild()
            │
            ├── 标记 _dirty = true
            │
            └── owner.scheduleBuildFor(this)
                    │
                    ├── 加入 _dirtyElements 列表
                    │
                    └── 调度下一帧 build
                            │
                            ▼
                WidgetsBinding.drawFrame()
                            │
                            ▼
                BuildOwner.buildScope()
                            │
                            ├── 按 depth 排序 dirty elements
                            │
                            └── 遍历调用 element.rebuild()
                                    │
                                    ├── performRebuild()
                                    │     ├── build() → 得到新 Widget
                                    │     └── updateChild() → diff 更新子树
                                    │
                                    └── _dirty = false

```
核心要点：

• setState 不是立即重建，而是"预约"下一帧重建
• 同一帧内多次 setState 只会重建一次（幂等设计）
• Element 按 depth 排序，保证父组件先于子组件重建

3. updateChild 的 diff 算法
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

1. 无状态组件的更新过程
2. 对于 StatelessWidget，当父组件 rebuild 时：

```dart
class StatelessElement extends ComponentElement {
  @override
  Widget build() => (widget as StatelessWidget).build(this);
 
  @override
  void update(StatelessWidget newWidget) {
    super.update(newWidget);
    rebuild(force: true);  // 强制重建
  }
}
```



流程：

1. 父组件 rebuild，生成新的 Widget 树
2. updateChild 检测到新旧 Widget 类型相同但实例不同
3. 调用 child.update(newWidget)
4. StatelessElement.update 调用 rebuild(force: true)
5. performRebuild 调用 build()，获取新的子 Widget
6. 递归执行 updateChild 更新子树
