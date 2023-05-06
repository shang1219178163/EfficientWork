# Flutter小技巧

### 1、椭圆边框
```
椭圆边框
//   style: OutlinedButton.styleFrom(
//     shape: StadiumBorder()
//   ),
```

### 2、去除 Choice item 上下边距 
```
materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
