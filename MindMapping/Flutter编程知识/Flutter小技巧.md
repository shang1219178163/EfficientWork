# Flutter小技巧

### 1、椭圆边框
```
椭圆边框
//   style: OutlinedButton.styleFrom(
//     shape: StadiumBorder()
//   ),
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
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            print('FAB tapped!');
          },
          backgroundColor: Colors.blueGrey,
        ),
        right: 0,
        left: 0,
        bottom: 0,
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
