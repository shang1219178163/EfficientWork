## StatefulWidget 的 State 解析

abstract class State<T extends StatefulWidget> with Diagnosticable {
  /// The current StatefulWidget.
  T get widget => _widget!;

  /// 树上的 StatefulElement 对象
  BuildContext get context {
    assert(() {
      if (_element == null) {
      return true;
    }());
    return _element!;
  }
  StatefulElement? _element;

  /// 挂载状态 
  bool get mounted => _element != null;

  /// 将此对象插入树时调用。您不能从此使用 [BuildContext.dependOnInheritedWidgetOfExactType]
   方法。但是，[didChangeDependencies] 将立即被调用
   按照这个方法，[BuildContext.dependOnInheritedWidgetOfExactType] 可以
   在那里使用。
  void initState() { }

  /// 每当小组件配置更改时调用
  void didUpdateWidget(covariant T oldWidget) { }

  /// 元素重新组装
  void reassemble() { }

  /// 通知框架此对象的内部状态已更改。
  void setState(VoidCallback fn) {
    final Object? result = fn() as dynamic;
    _element!.markNeedsBuild();
  }

  /// 当此对象从树中移除时调用。
  void deactivate() { }

  /// 当这个对象被重新插入到树中时被调用，之前调用过[deactivate]。
  void activate() { }

  /// 从树中永久删除此对象时调用。
  void dispose() { }

  /// 描述此小组件表示的用户界面部分。
  Widget build(BuildContext context);

  /// 当此 [State] 对象的依赖项更改时调用。
  void didChangeDependencies() { }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<T>('_widget', _widget, ifNull: 'no widget'));
    properties.add(ObjectFlagProperty<StatefulElement>('_element', _element, ifNull: 'not mounted'));
  }
}
