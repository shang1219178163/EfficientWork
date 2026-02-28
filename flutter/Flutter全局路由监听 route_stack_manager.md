# 基于 route_stack_manager 的路由监听管理

## 一、为什么需要这个功能组件？
随着迭代持续、模块增多、功能复杂度提升，多模块互相跳转，移动应用App（【执业版】【健管师】【医链健康】【医链临研】）需要一套路由堆栈监听。

    1、用来确认当前路由堆栈中是某个页面是否存活，存活直接返回；不存活时创建新页面。
    2、使路由栈操作透明化，确保跳转逻辑符合业务需求。
    3、识别当前路由队列是否存在底部弹窗 BottomSheet 和页面弹窗 Dialog。

鉴于市面上没有发现公开的第三方库，所以需要我们自己从0到1实现此功能。
基于 RouteObserver，在每次进栈，出栈，覆盖，移出时用RouteManager 进行监听管理，同时支持PageRoute、BottomSheet 和 Dialog类型。
成功实现路由监听管理库route_stack_manager（基于 RouteObserver） ，满足当前 App 功能的要求。从根源解决了之前无法识别存活页面的问题，最终提升了应用的交互体验。

## 二、如何集成

```yaml
dependencies:
    route_stack_manager:
    git:
      url: http://git.yljt.cn/shangbinbin/route_stack_manager.git
      ref: 1.1.0
```

## 三、使用&源码

#### 1、使用
在 main.dart 中如下：
```dart
  navigatorObservers: [
    RouteManagerObserver(),
  ],
```

然后通过 RouteManager 单例类获取需要的一切信息。

#### 2、RouteManager 源码
通过 RouteManager 单例类即可获取到当前路由堆栈的所有信息。

```dart
/// 路由堆栈管理器
class RouteManager {
  static final RouteManager _instance = RouteManager._();
  RouteManager._();
  factory RouteManager() => _instance;
  static RouteManager get instance => _instance;

  /// 监听列表
  final List<VoidCallback> _listeners = [];

  // 添加监听
  void addListener(VoidCallback cb) {
    if (_listeners.contains(cb)) {
      return;
    }
    _listeners.add(cb);
  }

  // 移除监听
  void removeListener(VoidCallback cb) {
    _listeners.remove(cb);
  }

  // 通知所有监听器
  void notifyListeners() {
    for (var ltr in _listeners) {
      ltr();
    }
  }

  /// 是否打印日志
  bool isDebug = false;

  /// 所有路由堆栈
  final List<Route<dynamic>> _routes = [];

  /// 当前路由堆栈
  List<Route<dynamic>> get routes => _routes;

  /// 当前 PageRoute 路由堆栈
  List<PageRoute<dynamic>> get pageRoutes => _routes.whereType<PageRoute>().toList();

  /// 当前 DialogRoute 路由堆栈
  List<DialogRoute<dynamic>> get dialogRoutes => _routes.whereType<DialogRoute>().toList();

  /// 当前 ModalBottomSheetRoute 路由堆栈
  List<ModalBottomSheetRoute<dynamic>> get sheetRoutes => _routes.whereType<ModalBottomSheetRoute>().toList();

  /// 当前路由名堆栈
  List<String?> get routeNames => routes.map((e) => e.settings.name).toList();

  /// 之前路由
  Route<dynamic>? preRoute;

  /// 之前路由 name
  String? get preRouteName => preRoute?.settings.name;

  /// 当前路由
  Route<dynamic>? get currentRoute => routes.isEmpty ? null : routes.last;

  /// 当前路由 name
  String? get currentRouteName => currentRoute?.settings.name;

  /// 最近的 PopupRoute 类型路由
  PopupRoute? get popupRoute {
    for (int i = routes.length - 1; i >= 0; i--) {
      final e = routes[i];
      if (e is PopupRoute) {
        return e;
      }
    }
    return null;
  }

  /// 当前路由类型是 PopupRoute
  bool get isPopupOpen => popupRoute != null;

  /// 路由堆栈包含 DialogRoute 类型
  bool get isDialogOpen => popupRoute is DialogRoute;

  /// 路由堆栈包含 ModalBottomSheetRoute 类型
  bool get isSheetOpen => popupRoute is ModalBottomSheetRoute;

  /// 是否存在路由堆栈中
  bool contain(String routeName) {
    return routeNames.contains(routeName);
  }

  /// 路由对应的参数
  Object? getArguments(String routeName) {
    final index = pageRoutes.indexWhere((e) => e.settings.name == routeName);
    if (index == -1) {
      return null;
    }
    final route = pageRoutes[index];
    return route;
  }

  /// 入栈
  void push(Route<dynamic> route) {
    if (_routes.isEmpty || _routes.isNotEmpty && _routes.last != route) {
      _routes.add(route);
    }
  }

  /// 出栈
  void pop(Route<dynamic> route) {
    _routes.remove(route);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isDebug'] = isDebug;
    data['routes'] = routes.map((e) => e.toString()).toList();
    data['pageRoutes'] = pageRoutes.map((e) => e.toString()).toList();
    if (dialogRoutes.isNotEmpty) {
      data['dialogRoutes'] = dialogRoutes.map((e) => e.toString()).toList();
    }
    if (sheetRoutes.isNotEmpty) {
      data['sheetRoutes'] = sheetRoutes.map((e) => e.toString()).toList();
    }
    data['routeNames'] = routeNames;
    data['preRouteName'] = preRouteName;
    data['currentRouteName'] = currentRouteName;
    data['popupRoute'] = popupRoute.toString();
    data['isPopupOpen'] = isPopupOpen;
    data['isDialogOpen'] = isDialogOpen;
    data['isSheetOpen'] = isSheetOpen;

    return data;
  }

  @override
  String toString() {
    const encoder = JsonEncoder.withIndent('  ');
    final descption = encoder.convert(toJson());
    return "$runtimeType: $descption";
  }

  void logRoutes() {
    notifyListeners();
    if (!isDebug) {
      return;
    }

    developer.log(toString());
  }
}
```
