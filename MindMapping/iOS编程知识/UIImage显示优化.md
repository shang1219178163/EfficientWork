# UIImage显示优化
### 一. 问题：
UIImage只有在屏幕上渲染时再解码的。而关于UIImageView的操作一定是在主线程，所以如果在tableview滑动中频繁的创建UIImage，会造成主线程阻塞。

### 二. 必知：
1. 下采样
当你缩小一幅图像的时候，会按照取平均值的办法把多个像素点变成一个像素点，这个过程称为 Downsampling。
2. 图像到屏幕上显示需要经过：缓存-》解码 -》 渲染

3. 图像缓冲区(Image Buffers)是一种特殊缓冲区。
    1). 在内存中以图像的形式展现
    2). 每个元素描述了图像中每个像素的颜色和透明度
    3). 此缓冲区的内存大小与它包含图像的大小成正比
4. 帧缓冲区(frame buffer)负责在 App 中保存实际渲染后的输出。
当你的 App 更新其视图层级结构时， UIKit 将重新渲染 App 的窗口及其所有子视图到帧缓冲区。该帧缓冲区提供每个像素的颜色信息，显示硬件将读取这些信息，以便点亮显示器上对应的像素。显示器读取以固定的时间间隔发生， 60Hz -120Hz 读取一次。如果 App 没有任何改变，则显示硬件会将它上次看到的相同数据从帧缓冲区取出。

1. 数据缓冲区(data buffer)，一种包含一系列字节的缓冲区。 包含图像文件的数据缓冲区通常以某些元数据开头，这些元数据描述了存储在数据缓冲区中的图像大小。
总结： data buffer 解码到 Image Buffers 填充到 frame buffer，供显示器读取数显示

#### 图片的下载与加载：
##### 下载图片主要流程：

1. 从网络下载图片源数据，默认放入内存和磁盘缓存中（）
2. 异步解码，解码后的数据放入内存缓存中
3. 回调主线程渲染图片
（内部维护磁盘和内存的cache，支持设置定时过期清理，内存cache的上限等）

##### 加载图片的主要流程：
1. 从内存中查找图片数据，如果有并且已经解码，直接返回数据，如果没有解码，异步解码缓存内存后返回
2. 内存中未查找到图片数据，从磁盘查找，磁盘查找到后，加载图片源数据到内存，异步解码缓存内存后返回，如果没有去网络下载图片。走上面的流程。
分析: 这样滴的程解决了UIImage imageNamed这种加载一定在主线程解码图片的问题，异步加载，避免了主线程阻塞。同时通过缓存内存方式，避开了频繁的磁盘IO，通过缓存解码后的图片数据，避开了频繁解码的CPU消耗。

### 三. 优化方法：

1. 对于需要离屏渲染的场景推荐使用UIGraphicsImageRenderer替代UIGraphicsBeginImageContext，性能更好，并且支持广色域。

2. 调整解码时机，下载完之后子线程主动解码一次，缓存起来，缓存图片可以用NSCache

3. 预加载+子线程
可以在Prefetching的时候把降采样放到子线程进行处理，因为降采样过程就包括解码操作。

```
let serialQueue = DispatchQueue(label: "Decode queue") 

func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
 // Asynchronously decode and downsample every image we are about to show
  for indexPath in indexPaths {
  serialQueue.async {
   let downsampledImage = downsample(images[indexPath.row]) 
   DispatchQueue.main.async {
    self.update(at: indexPath, with: downsampledImage) 
    } 
  } 
}


/// 将原来的 UIImage 剪裁出圆角
func imageWithRoundedCorner(_ radius: CGFloat, size: CGSize) -> UIImage {
    let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
    guard let ctx = UIGraphicsGetCurrentContext() else { return self}
    
UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
    let path: CGPath = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: radius, height: radius)).cgPath
    ctx.addPath(path)
    ctx.clip()

    self.draw(in: rect)
    ctx.drawPath(using: .fillStroke)
    let output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output!
}

```

### （附）大图片的处理
1. 网络图片可以不解码下载好的图片（原图）。
2. 超大图加载在小的view上
解决方法: 使用苹果推荐的缩略图下采样 DownSampling 方案即可

3. 加载超大图拖动显示
解决方法: 使用苹果的CATiledLayer去加载。原理是分片渲染，滑动时通过指定目标位置，通过映射原图指定位置的部分图片数据解码渲染。这里不再累述，有兴趣的小伙伴可以自行了解下官方API。


