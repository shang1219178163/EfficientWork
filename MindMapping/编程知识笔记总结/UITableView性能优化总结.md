## UITableView性能优化

#### 常规优化：

```
正确使用reuseIdentifier来重用Cells。
Cell高度预先计算，缓存。
尽量使所有的view 不透明，包括Cell自身/避免使用透明图层。
尽量少用addView给Cell动态添加View，可以初始化时就添加，然后通过hide来控制是否显示。
减少子视图的层级关系/绘制操作。
避免过于庞大的XIB，用xib写的界面加载速度比直接用代码写的要慢好多，中间有一层不可控的转化工作。
使用shadowPath来画阴影。
```
#### 图片优化

```
本地图片都需要经过TinyPNG压缩。
圆角切割 YYWebImage。
如果Cell内现实的内容来自web，使用异步加载，缓存请求结果。
图片载入在后台进程进行，滚出可视范围的载入进程cancel掉。
图片资源尽可能使用PNG。

//使用CAShapeLayer和UIBezierPath设置圆角
UIImageView *imageView=[[UIImageViewalloc]initWithFrame:CGRectMake(100,100,100,100)];
imageView.image=[UIImageimageNamed:@'myImg'];

UIBezierPath *maskPath=[UIBezierPathbezierPathWithRoundedRect:imageView.boundsbyRoundingCorners:UIRectCornerAllCornerscornerRadii:imageView.bounds.size];
CAShapeLayer *maskLayer=[[CAShapeLayeralloc]init];
//设置大小
maskLayer.frame=imageView.bounds;
//设置图形样子
maskLayer.path=maskPath.CGPath;
imageView.layer.mask=maskLayer;
[self.viewaddSubview: imageView];

解释的是：
CAShapeLayer继承于CALayer,可以使用CALayer的所有属性值；
CAShapeLayer需要贝塞尔曲线配合使用才有意义（也就是说才有效果）
使用CAShapeLayer(属于CoreAnimation)与贝塞尔曲线可以实现不在view的drawRect（继承于CoreGraphics走的是CPU,消耗的性能较大）方法中画出一些想要的图形
CAShapeLayer动画渲染直接提交到手机的GPU当中，相较于view的drawRect方法使用CPU渲染而言，其效率极高，能大大优化内存使用情况。
     
总的来说就是用CAShapeLayer的内存消耗少，渲染速度快。
```
#### 滚动卡顿优化

```
滑动时按需加载
//核心判断：tableView非滚动状态下，才进行图片下载并渲染
if (!tableView.dragging && !tableView.decelerating) {
        
1. 要求 tableView 滚动的时候,滚动到哪行，哪行的图片才加载并显示,滚动过程中图片不加载显示;
2. 页面跳转的时候，取消当前页面的图片加载请求；
```

#### 避免以下操作引发离屏渲染：

```
为图层设置遮罩（layer.mask）
将图层的layer.masksToBounds / view.clipsToBounds属性设置为true
将图层layer.allowsGroupOpacity属性设置为YES和layer.opacity小于1.0
为图层设置阴影（layer.shadow *）。
为图层设置layer.shouldRasterize=true
具有layer.cornerRadius，layer.edgeAntialiasingMask，layer.allowsEdgeAntialiasing的图层
文本（任何种类，包括UILabel，CATextLayer，Core Text等）。
使用CGContext在drawRect :方法中绘制大部分情况下会导致离屏渲染，甚至仅仅是一个空的实现
```
#### 总结

```
Cell相关的高度/子视图/控件/资源都尽量事先/异步生成，用的时候/主线程直接加载
（缓存一切可以缓存的，提前生成一切可以提前生成的，可以异步的尽量异步，元素尽可能少，在滚动期间工作越少越好）
```