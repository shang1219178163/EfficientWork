# Flutter数据库：iSar 集成

## 一、为什么要集成数据库？

目前市场需求，个别医生会有千级别患者，数千个群。APP（三端）会话页面，聊天页面，患者列表会有加载时间过长的问题；在弱网下甚至加载不出来的可能；为优化用户体验，达到秒开（1~2秒）的目的。

## 二、为什么选择 iSar？

### 1、[**Flutter 工程化框架选择 — 搞定数据存储选型**](https://juejin.cn/post/7150064694584475656) 初步对比

### 2、社区活跃度对比：

![flutter数据库对比.png](https://alidocs.oss-cn-zhangjiakou.aliyuncs.com/res/ABmOorZaWZweqawZ/img/0cce81f6-8920-4bd6-af37-58bd43ba2bf7.png)

### 3、 [**isar**](https://link.juejin.cn/?target=https%3A%2F%2Fgithub.com%2Fisar%2Fisar%2Ftree%2Fmain%2Fpackages%2Fisar) 基于 dart:ffi ，支持 Android 、iOS、Linux、MacOS、Window、Web 平台。完全开源，从构建脚本到逻辑代码都是开源。isar 库本身不大，几百K。

### 4、isar 提供可视化工具 ，只需要在 open 时设置 inspector: true  就可以看到 ws 地址访问。

![image.png](https://alidocs.oss-cn-zhangjiakou.aliyuncs.com/res/ABmOorZaWZweqawZ/img/0fd5f033-c733-4023-8c96-bd0ac8af7e33.png)

### 5、集成简单

## 三、如何集成

[官方文档](https://isar.dev/zh/tutorials/quickstart.html)

## 1\. 添加依赖

    flutter pub add isar isar_flutter_libs
    flutter pub add -d isar_generator build_runner

## 2\. 给类添加注解

用  @collection 给你的 Collection 类添加注解，并指定一个  Id 字段。Id 唯一指向了 Collection 中的对象，之后我们可通过 Id 来查询这些对象。

    part 'user.g.dart';
    
    @collection
    class User {
      Id id = Isar.autoIncrement; // 你也可以用 id = null 来表示 id 是自增的
    
      String? name;
    
      int? age;
    
      Brand? brand;
    }
    
    @embedded
    class Brand {
      String? name;
    
      String? country;
    }

嵌套模型添加 @embedded 关键字

## 3\. 运行代码生成器

    dart run build_runner build

## 四、封装使用

1、数据库封装

    //
    //  DbManager.dart
    //  flutter_templet_project
    //
    //  Created by shang on 2024/2/24 09:00.
    //  Copyright © 2024/2/24 shang. All rights reserved.
    //
    
    import 'package:isar/isar.dart';
    import 'package:path_provider/path_provider.dart';
    import 'package:yl_health_app/http/model/im_group_detail_root_model.dart';
    import 'package:yl_health_app/http/model/im_msg_list_root_model.dart';
    import 'package:yl_health_app/http/model/patient_detail_model.dart';
    
    /// 数据库管理类
    class DBManager {
      DBManager._();
      static final DBManager _instance = DBManager._();
      factory DBManager() => _instance;
      static DBManager get instance => _instance;
    
      late Isar isar;
    
      Future<void> init() async {
        isar = await openDB(schemas: [
          IMGroupDetailModelSchema,
          PatientDetailModelSchema,
          IMMsgDetailModelSchema,
        ]);
      }
    
      Future<Isar> openDB({required List<CollectionSchema<dynamic>> schemas,}) async {
        final dir = await getApplicationDocumentsDirectory();
        final result = await Isar.open(
          schemas,
          directory: dir.path,
          inspector: true,
        );
        return result;
      }
    
    }

2、使用方式封装 - GetxController

    //
    //  DbTodoController.dart
    //  flutter_templet_project
    //
    //  Created by shang on 2024/2/24 09:36.
    //  Copyright © 2024/2/24 shang. All rights reserved.
    //
    
    
    
    import 'package:flutter/material.dart';
    import 'package:get/get.dart';
    import 'package:isar/isar.dart';
    import 'package:yl_health_app/db/DBManager.dart';
    import 'package:yl_health_app/http/model/im_group_detail_root_model.dart';
    
    
    class DBGenericController<E> extends GetxController {
      DBGenericController() {
        init();
      }
    
      final isar = DBManager().isar;
    
      final List<E> _entitys = <E>[];
      List<E> get entitys => _entitys;
    
      Future<void> init() async {
        isar.txn(() async {
          await update();
        });
      }
    
      /// 查
      @override
      Future<void> update([List<Object>? ids, bool condition = true]) async {
        if (!Get.isRegistered<DBGenericController<E>>()) {
          return;
        }
        await getAllEntitys();
        super.update(ids, condition);
      }
    
      /// 过滤
      Future<List<E>> filterEntitys({Future<List<E>> Function(QueryBuilder<E, E, QFilterCondition> isarItems)? filterCb}) async {
        final collections = isar.collection<E>();
        final filters = collections.filter();
        final items = await filterCb?.call(filters) ?? await collections.where().findAll();
        _entitys.clear();
        _entitys.addAll(items);
        return _entitys;
      }
    
      /// 获取所有实体
      Future<List<E>> getAllEntitys() async {
        return filterEntitys();
      }
    
      /// 寻找第一个
      Future<E?> filterEntity({required Future<E?> Function(QueryBuilder<E, E, QFilterCondition> isarItems) filterCb}) async {
        final collections = isar.collection<E>();
        final filters = collections.filter();
        final item = await filterCb(filters);
        return item;
      }
    
      /// 增/改
      Future<void> putAll(List<E> list) async {
        await isar.writeTxn(() async {
          await isar.collection<E>().putAll(list);
          await update();
        });
      }
      /// 增/改
      Future<void> put(E e) async {
        await putAll([e]);
      }
    
      /// 删
      Future<void> deleteAll(List<Id> ids) async {
        await isar.writeTxn(() async {
          final count = await isar.collection<E>().deleteAll(ids);
          debugPrint('$this deleted $count');
    
          await update();
        });
      }
    
      /// 删
      Future<void> delete(Id id) async {
        await deleteAll([id]);
      }
    
    }

使用示例：

    final groupDetailModelController = Get.put(DBGenericController<IMGroupDetailModel>());

    final dbGroupDetailModel = await groupDetailModelController.filterEntity(
        filterCb: (list){
          return list.groupIdEqualTo(groupID).findFirst();
        });

3、使用方式封装 - ChangeNotifier

    //
    //  DbProvider.dart
    //  flutter_templet_project
    //
    //  Created by shang on 2024/2/24 09:09.
    //  Copyright © 2024/2/24 shang. All rights reserved.
    //
    
    
    import 'package:flutter/cupertino.dart';
    import 'package:isar/isar.dart';
    import 'package:yl_health_app/db/DBManager.dart';
    
    class DBGenericProvider<E> extends ChangeNotifier {
      DBGenericProvider() {
        init();
      }
    
      final isar = DBManager().isar;
    
      final List<E> _entitys = <E>[];
      List<E> get entitys => _entitys;
    
      Future<void> init() async {
        isar.txn(() async {
          await update();
        });
      }
    
      /// 查
      Future<void> update() async {
        final items = await isar.collection<E>().where().findAll();
        _entitys.clear();
        _entitys.addAll(items);
        notifyListeners();
      }
    
      /// 增/改
      Future<void> putAll(List<E> list) async {
        await isar.writeTxn(() async {
          await isar.collection<E>().putAll(list);
          await update();
        });
      }
      /// 增/改
      Future<void> put(E e) async {
        await putAll([e]);
      }
    
      /// 删
      Future<void> deleteAll(List<Id> ids) async {
        await isar.writeTxn(() async {
          final count = await isar.collection<E>().deleteAll(ids);
          debugPrint('$this deleted $count');
    
          await update();
        });
      }
    
      /// 删
      Future<void> delete(Id id) async {
        await deleteAll([id]);
      }
    
    }

使用示例：

    ChangeNotifierProvider(create: (context) => DBGenericProvider<DBTodo>()),

    DBGenericProvider<DBTodo> get provider => Provider.of<DBGenericProvider<DBTodo>>(context, listen: false);

    Consumer<DBGenericProvider<DBTodo>>(
      builder: (context, value, child) {
    
        final checkedItems = value.entitys.where((e) => e.isFinished == true).toList();
        ...
    
      },
    ),

## 最后

isar 官网文档支持中文。建议大家花一两天时间简单过一遍，知道它支持哪些功能，出现问题去哪找解决办法就可以了！