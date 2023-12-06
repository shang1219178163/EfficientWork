# Flutter小技巧

### Text底部黄色双划线
修改根组件为Material 或者 Scaffold组件；
```
    Text("content",
      style: TextStyle(
        decoration: TextDecoration.none,
      )
    );
```

### 1、椭圆边框
```
椭圆边框
//   style: OutlinedButton.styleFrom(
//     shape: StadiumBorder()
//   ),
```

```
椭圆边框
const ShapeDecoration(
  color: bgColor,
  shape: StadiumBorder(),
),
```

圆边框
```
const ShapeDecoration(
  color: Colors.red,
  shape: CircleBorder(),
),


decoration: BoxDecoration(
  color: color,
  shape: BoxShape.circle,
),
```

### 2、去除 Choice item 上下边距 （button同）
```
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
```
```
    style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
```
取消长按背景阴影
```
Theme(
    data: ThemeData(
       canvasColor: Colors.transparent,
       highlightColor: Colors.white,
    ),
    child: ChoiceChip(
      pressElevation: 0,
```

### 3、Stack postion不响应事件
```
  Stack(
    overflow: Overflow.visible,
    children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>
        [
          Container(width: 150, height: 150, color: Colors.yellow),
          Container(width: 150, height: 28, color: Colors.transparent),
        ],
      ),
      Positioned(
        right: 0,
        left: 0,
        bottom: 0,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            print('FAB tapped!');
          },
          backgroundColor: Colors.blueGrey,
        ),
      ),
    ],
  )
      
//stack 底部用 Column 包含弹窗的范围
//Stack外部包一个Container.Container高度大于等于Item1和Item2的高度之和即可
```

### 4、最小 Row、Column
```
  mainAxisSize: MainAxisSize.min,
```

### 5、body内容穿透到导航栏下面
```
   final bool extendBodyBehindAppBar;
```

### 6、关闭按钮水波纹
```
    style: ButtonStyle(
          overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
    ),
```

### 7、Divider 默认高度 16
```
    Divider(
        height: 1, //defaults to 16.0
        color: Colors.red,
    ),
```
```
    VerticalDivider(
       color: Colors.red,
       width: 1, // defaults to 16.0
       thickness: 1,
    ),
```
  ### 8、竖排三个汉字和四个汉字两端对齐
```
    Text('身份证号',style: TextStyle(fontSize: 18.0)),
    Text('注册',style: TextStyle(fontSize: 18.0, letterSpacing: 18.0 * 2)),
    Text('手机号',style: TextStyle(fontSize: 18.0, letterSpacing: 18.0 / 2)),
```
  ### 9、状态栏及字体颜色的设置方法
```
    appBar: AppBar(
		  title: new Text(''),
	  elevation: 0,
	  brightness: Brightness.dark, //设置为白色字体
	  ),
```

```
    @override
     Widget build(BuildContext context) {
    
     return AnnotatedRegion<SystemUiOverlayStyle (
      value: SystemUiOverlayStyle.light,
      child: Material(child:Scaffold(),),);
     }
```

  ### 10、模型转换数组字符串类型报错
```
    attachedImgs = List<String>.from(json["attachedImgs"] ?? []);
    data["attachedImgs"] = List<String>.from(attachedImgs ?? []);
```

### 12、json类型转换
```
import 'dart:convert';

final array = jsonDecode(restructureMsgBody ?? "") ?? 【】;

final json = jsonDecode(customElem?.data ?? "") ;
```

### 13、解决ListView默认的的SliverPadding
```
child: MediaQuery.removePadding(
  removeTop: true,
  context: context,
  child: ListView.builder(
    itemCount: _dataSource.length,
    itemBuilder: (BuildContext context, int index){
      return Material(
        color: Colors.green,
        child: ListTile(
          title: Text(_dataSource[index]),
        ),
      );
    },
  ),
),
```

### 14、解决ListView滚动到底部闪一下
```
倒转 ListView
```

### 15、长文字 Text 直接显示 ...
```
title.replaceAll('', '\u200B')
```

### 16、IconButton 移除 padding
```
IconButton(
    padding: EdgeInsets.zero,
    constraints: BoxConstraints(),
)
```

### 17、WillPopScope 会阻止右滑返回


### 18、键盘高度无法检测

如果是使用了 flutter_screenutil 设置 useInheritedMediaQuery 为true 即可；
```
ScreenUtilInit(
  useInheritedMediaQuery: true,
  designSize: const Size(376, 812),
  builder: (context, child) {
    return const Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Spacer(),
          TextField(),
        ],
      ),
    );
  },
);
```

### 18、禁止键盘推起内容
```
    return Scaffold(
      ...
      resizeToAvoidBottomInset: false,
      
```

### 19、Remove end drawer icon in scaffold

drawer
```
  automaticallyImplyLeading: false,
```
end drawer
```
  actions: <Widget>[Container()],
```

### 20、openEndDrawer
```
Scaffold.of(context).openEndDrawer(); 
```

### 21、flutter_easy_refresh 下拉加载的时候拖拽会导致footer无法收起,并且一直停在成功的状态
```
ClassicFooter中的infiniteOffset设置为null
```