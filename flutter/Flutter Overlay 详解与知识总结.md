Flutter 
## 一、Overlay 基础知识
Overlay 是 Flutter 中一个非常强大的 Widget，允许你在应用的界面上创建一个浮动层，用于展示其他的 widget，比如弹窗、提示、菜单、工具提示等。Overlay 提供了一个独立于正常 widget 层次结构的空间，可以覆盖在应用的其他部分之上。

1. Overlay 的基本概念
Overlay 是一个特殊的 widget，它管理一组由 OverlayEntry 对象组成的栈。
OverlayEntry 是 Overlay 中的每个独立项，负责在 Overlay 层中显示 widget。
Overlay 可以用于创建临时的 UI 层，如提示框、模态框、菜单等，而不会干扰其他 widget 的布局和渲染。
2. 常见用法场景
悬浮操作按钮：比如从屏幕边缘弹出的按钮或操作栏。
弹窗、对话框：可以用来显示提示、确认等对话框。
工具提示（Tooltip）：鼠标悬停或长按时显示的浮动信息。
自定义加载动画：显示全屏加载动画而不阻碍其他 UI。
3. Overlay 的工作原理
Overlay 维护一个栈，OverlayEntry 可以随时被插入或移除。
使用 Overlay.of(context) 可以获取当前的 Overlay 实例。
通过 Overlay.insert() 或 OverlayEntry.insert() 可以将 OverlayEntry 插入到 Overlay 中。
OverlayEntry.remove() 用于从 Overlay 中移除某个 entry。
4. 使用 Overlay 的步骤
获取 OverlayState：使用 Overlay.of(context) 获取当前的 OverlayState，它用于操作 Overlay 层。

创建 OverlayEntry：定义一个 OverlayEntry，其中包含需要显示的 widget。


```dart
OverlayEntry overlayEntry = OverlayEntry(
  builder: (context) => Positioned(
    top: 100.0,
    left: 50.0,
    child: Material(
      child: Text('This is an overlay'),
    ),
  ),
);
```

插入 OverlayEntry：将 OverlayEntry 插入到 OverlayState 中。

```dart
Overlay.of(context)?.insert(overlayEntry);
```
移除 OverlayEntry：在不需要时移除它。

```dart
overlayEntry.remove();
```

5. 示例代码
以下是一个简单的 Overlay 示例，展示如何在屏幕上动态显示和移除一个浮动的消息框。

```dart
import 'package:flutter/material.dart';

class OverlayExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overlay Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 获取当前 Overlay 的状态
            OverlayState? overlayState = Overlay.of(context);
            // 创建一个 OverlayEntry
            OverlayEntry overlayEntry = OverlayEntry(
              builder: (context) => Positioned(
                top: 100.0,
                left: 50.0,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.black54,
                    child: Text(
                      'Hello from Overlay!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );

            // 插入 OverlayEntry
            overlayState?.insert(overlayEntry);

            // 2 秒后移除 OverlayEntry
            Future.delayed(Duration(seconds: 2), () {
              overlayEntry.remove();
            });
          },
          child: Text('Show Overlay'),
        ),
      ),
    );
  }
}
```

6. 注意事项
Overlay 中的 widget 是独立渲染的，不会受其他 widget 的影响。
如果你需要在 Overlay 中操作手势或输入事件，确保这些 widget 被正确管理，否则可能导致事件未被响应。
7. 性能考量
Overlay 适合展示临时内容，过多或长时间使用 OverlayEntry 可能影响性能。
需要时及时移除不再需要的 OverlayEntry 以释放资源。
Overlay 是一个非常灵活且强大的工具，可以帮助你在 Flutter 中创建出色的用户体验。在理解其工作原理后，你可以用它来实现复杂的 UI 动画和效果。

---
#### Overlay相关组件 - OverlayPortal
1、源码
```dart
  const OverlayPortal({
    super.key,
    required this.controller,
    required this.overlayChildBuilder,
    this.child,
  }) : _targetRootOverlay = false;

  /// The controller to show, hide and bring to top the overlay child.
  final OverlayPortalController controller;

  /// the [Overlay] on which it is rendered.
  final WidgetBuilder overlayChildBuilder;

  /// A widget below this widget in the tree.
  final Widget? child;
```
使用示例
```dart
  final _portalController = OverlayPortalController();

  Widget buildOverlayPortal() {
    return TextButton(
      onPressed: _portalController.toggle,
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 16),
        child: OverlayPortal(
          controller: _portalController,
          overlayChildBuilder: (BuildContext context) {
            return Positioned(
              right: 30,
              bottom: 30,
              child: Container(
                width: 300,
                height: 200,
                color: Colors.amberAccent,
                child: Text('tooltip'),
              ),
            );
          },
          child: const Text('Press to show/hide tooltip'),
        ),
      ),
    );
  }

class OverlayPortalController {

  void show() {

  void hide() {

  bool get isShowing {

  void toggle() => isShowing ? hide() : show();

}
```
演示示例：
OverlayDemo
OverlayPortalDemo
AlignmentDrawDemo

## 二、组件 CompositedTransformTarget

CompositedTransformTarget 是 Flutter 中的一个 widget，用于配合 CompositedTransformFollower 实现两个 widget 之间的动态定位和对齐，通常用于创建类似于菜单、弹出框、工具提示等需要动态调整位置的场景。

1. CompositedTransformTarget 的基本概念
CompositedTransformTarget 是一个容器 widget，用来标记一个特定的目标区域。
它不会直接对其子 widget 产生视觉上的改变，但会为与之配合的 CompositedTransformFollower 提供位置信息。
通过 CompositedTransformTarget 与 CompositedTransformFollower 的配合，可以在视觉上将两个分离的 widget 进行动态关联和对齐。
2. 常见用法场景
弹出菜单：比如当点击一个按钮时弹出菜单，这个菜单需要对齐到按钮的位置。
工具提示（Tooltip）：在特定的 UI 元素上方显示额外的信息。
弹出窗或浮动面板：需要依附于某个元素并动态调整位置。
3. 工作原理
CompositedTransformTarget 通过 LayerLink 提供自身的位置和尺寸信息。
CompositedTransformFollower 使用相同的 LayerLink，并依赖此位置信息来定位自身，达到与 CompositedTransformTarget 对齐的效果。
这种动态的跟随效果是通过 Flutter 的 Layer 系统实现的，因此具有高效的性能。
4. 关键属性
link：类型为 LayerLink，用于在 CompositedTransformTarget 和 CompositedTransformFollower 之间建立连接。
5. 使用步骤
创建 LayerLink：先定义一个 LayerLink 实例，这个实例将会在 CompositedTransformTarget 和 CompositedTransformFollower 之间共享。

创建 CompositedTransformTarget：包裹目标 widget，并将 LayerLink 传入其中。

创建 CompositedTransformFollower：使用相同的 LayerLink，并包裹需要动态定位的 widget。

6. 示例代码
以下是一个简单的示例，展示了如何使用 CompositedTransformTarget 和 CompositedTransformFollower 创建一个长按弹出菜单。

```dart
//
//  n_target_follower.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/18 14:05.
//  Copyright © 2023/10/18 shang. All rights reserved.
//

import 'package:flutter/material.dart';
import 'package:yl_ylgcp_app/extension/custom_type_util.dart';

/// 关联组件
class NTargetFollower extends StatefulWidget {
  NTargetFollower({
    Key? key,
    this.targetAnchor = Alignment.topCenter,
    this.followerAnchor = Alignment.bottomCenter,
    this.showWhenUnlinked = true,
    this.offset = Offset.zero,
    this.onTap,
    this.onLongPressEnd,
    required this.target,
    required this.followerBuilder,
    this.entries,
  }) : super(key: key);

  /// 目标对齐方式
  final Alignment targetAnchor;

  /// 跟随者对齐方式
  final Alignment followerAnchor;

  final bool showWhenUnlinked;

  final Offset offset;

  final GestureTapCallback? onTap;

  /// 实现此方法则弹窗不会自动关闭,需手动关闭
  final GestureLongPressEndCallback? onLongPressEnd;

  /// 传入此参数则页面仅显示一个
  final List<OverlayEntry>? entries;

  final Widget target;

  VoidCallbackWidgetBuilder? followerBuilder;

  @override
  _NTargetFollowerState createState() => _NTargetFollowerState();
}

class _NTargetFollowerState extends State<NTargetFollower> {
  final LayerLink layerLink = LayerLink();

  late final _entries = widget.entries ?? <OverlayEntry>[];

  late OverlayEntry _overlayEntry;
  bool show = false;
  Offset indicatorOffset = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    if (widget.followerBuilder == null) {
      return widget.target;
    }

    return GestureDetector(
      onTap: widget.onTap,
      // onTap: _toggleOverlay,
      // onPanStart: (e) => _showOverlay(),
      // onPanEnd: (e) => _hideOverlay(),
      // onPanUpdate: updateIndicator,
      onLongPressStart: (e) => _showOverlay(),
      onLongPressEnd: widget.onLongPressEnd ?? (e) => _hideOverlay(),
      onLongPressMoveUpdate: updateIndicatorLongPress,
      child: CompositedTransformTarget(
        link: layerLink,
        child: widget.target,
      ),
    );
  }

  void _toggleOverlay() {
    if (!show) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
    show = !show;
  }

  void _showOverlay() {
    // if (_entries.isNotEmpty) {
    //   return;
    // }
    _hideOverlay();

    _overlayEntry = _createOverlayEntry(indicatorOffset);
    _entries.add(_overlayEntry);
    Overlay.of(context).insert(_overlayEntry);
  }

  void _hideOverlay() {
    for (final e in _entries) {
      e.remove();
    }
    _entries.clear();
  }

  void updateIndicator(DragUpdateDetails details) {
    indicatorOffset = details.localPosition;
    _overlayEntry.markNeedsBuild();
  }

  void updateIndicatorLongPress(LongPressMoveUpdateDetails details) {
    indicatorOffset = details.localPosition;
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry(Offset localPosition) {
    indicatorOffset = localPosition;
    return OverlayEntry(
      builder: (BuildContext context) => UnconstrainedBox(
        child: CompositedTransformFollower(
          link: layerLink,
          targetAnchor: widget.targetAnchor,
          followerAnchor: widget.followerAnchor,
          offset: widget.offset,
          showWhenUnlinked: widget.showWhenUnlinked,
          child: widget.followerBuilder?.call(context, _hideOverlay),
        ),
      ),
    );
  }
}
```

7. 注意事项
保持 LayerLink 一致性：CompositedTransformTarget 和 CompositedTransformFollower 必须共享同一个 LayerLink 实例。
销毁管理：及时移除 OverlayEntry，避免内存泄漏。
动态更新：在某些情况下需要重新布局时，CompositedTransformFollower 会自动更新其位置，因此对于 UI 动态变化较多的场景非常实用。
8. 性能优化
CompositedTransformTarget 和 CompositedTransformFollower 基于 Flutter 的 Layer 系统工作，性能相对较高，适合于频繁更新的位置跟踪场景。
避免在复杂场景中嵌套过多的 Overlay，可能影响性能。
通过 CompositedTransformTarget 和 CompositedTransformFollower，Flutter 可以实现复杂的 UI 位置关系和动态交互，非常适合需要动态调整位置的组件开发。

**补充： Alignment 坐标系**
| topLeft(-1.0, -1.0) | topCenter(0.0, -1.0) | topRight(1.0, -1.0) |
|---|---|---|
| centerLeft(-1.0, 0.0) | center(0.0, 0.0) | centerRight(1.0, 0.0) |
| bottomLeft(-1.0, 1.0) | bottomCenter(0.0, 1.0) | bottomRight(1.0, 1.0) |

