# iOS 程序性能优化

### 1. 在正确的地方使用 reuseIdentifier
一个开发中常见的错误就是没有给UITableViewCells， UICollectionViewCells，甚至是UITableViewHeaderFooterViews设置正确的reuseIdentifier。

### 2. 尽量把views设置为不透明，避免混合渲染

### 3. 避免过于庞大的XIB
用xib写的界面加载速度比直接用代码写的要慢好多。

### 4. 不要阻塞主线程
永远不要使主线程承担过多。因为UIKit在主线程上做所有工作，渲染，管理触摸反应，回应输入等都需要在它上面完成。

### 5. 在Image Views中调整图片大小
如果要在UIImageView中显示一个来自bundle的图片，你应保证图片的大小和UIImageView的大小相同。在运行中缩放图片是很耗费资源的，特别是UIImageView嵌套在UIScrollView中的情况下。

如果图片是从远端服务加载的你不能控制图片大小，比如在下载前调整到合适大小的话，你可以在下载完成后，最好是用background thread，缩放一次，然后在UIImageView中使用缩放后的图片。

### 6. 选择正确的Collection
学会选择对业务场景最合适的类或者对象是写出能效高的代码的基础。当处理collections时这句话尤其正确。

一些常见collection的总结：

          • Arrays: 有序的一组值。使用index来lookup很快，使用value lookup很慢，插入/删除很慢。
          • Dictionaries: 存储键值对。用键来查找比较快。
          • Sets: 无序的一组值。用值来查找很快，插入/删除很快。因为Set用到了哈希，所以插入删除查找速度比Array快很多

### 7. 打开gzip压缩
设置header允许使用压缩('Accept-Encoding','gzip')，然后再写入response的header('Content-Encoding','gzip') 

### 8. 重用和延迟加载(lazy load) Views
更多的view意味着更多的渲染，也就是更多的CPU和内存消耗，对于那种嵌套了很多view在UIScrollView里边的app更是如此。

### 9. 模仿UITableView和UICollectionView的操作:
不要一次创建所有的subview，而是当需要时才创建，当它们完成了使命，把他们放进一个可重用的队列中。
这样的话你就只需要在滚动发生时创建你的views，避免了不划算的内存分配。

### 10. Cache, Cache, 还是Cache!注意你的缓存
一个极好的原则就是，缓存所需要的，也就是那些不大可能改变但是需要经常读取的东西。
我们能缓存些什么呢？一些选项是，远端服务器的响应，图片，甚至计算结果，比如UITableView的行高。

NSURLConnection默认会缓存资源在内存或者存储中根据它所加载的HTTP Headers。你甚至可以手动创建一个NSURLRequest然后使它只加载缓存的值。

如果你需要缓存其它不是HTTP Request的东西，你可以用NSCache。NSCache和NSDictionary类似，不同的是系统回收内存的时候它会自动删掉它的内容。

### 11. 权衡渲染方法
在iOS中可以有很多方法做出漂亮的按钮。你可以用整幅的图片，可调大小的图片，或者可以用CALayer， CoreGraphics甚至OpenGL来画它们。当然每个不同的解决方法都有不同的复杂程度和相应的性能。

简单来说，就是用事先渲染好的图片更快一些，因为如此一来iOS就免去了创建一个图片再画东西上去然后显示在屏幕上的程序。问题是你需要把所有你需要用到的图片放到app的bundle里面，这样就增加了体积–这就是使用可变大小的图片更好的地方了:你可以省去一些不必要的空间，也不需要再为不同的元素(比如按钮)来做不同的图。

然而，使用图片也意味着你失去了使用代码调整图片的机动性，你需要一遍又一遍不断地重做他们，这样就很浪费时间了，而且你如果要做一个动画效果，虽然每幅图只是一些细节的变化你就需要很多的图片造成bundle大小的不断增大。

总得来说，你需要权衡一下利弊，到底是要性能能还是要bundle保持合适的大小。

### 12 .处理内存警告
一旦系统内存过低，iOS会通知所有运行中app。在官方文档中是这样记述:

如果你的app收到了内存警告，它就需要尽可能释放更多的内存。最佳方式是移除对缓存，图片object和其他一些可以重创建的objects的strong references.

幸运的是，UIKit提供了几种收集低内存警告的方法:

        • 在app delegate中使用applicationDidReceiveMemoryWarning:的方法
        • 在你的自定义UIViewController的子类(subclass)中覆盖didReceiveMemoryWarning
        • 注册并接收 UIApplicationDidReceiveMemoryWarningNotification的通知

### 13. 重用大开销对象
一些objects的初始化很慢，比如NSDateFormatter和NSCalendar。确保一种格式只创建一个。

### 14. 避免反复处理数据
这一点在处理大量数据的时候极为重要，字典缓存用空间换时间的方法也许是极好的。

### 15. 选择正确的数据格式
从app和网络服务间传输数据有很多方案，最常见的就是JSON和XML。你需要选择对你的app来说最合适的一个。

解析JSON会比XML更快一些，JSON也通常更小更便于传输。从iOS5起有了官方内建的JSON deserialization就更加方便使用了。

但是XML也有XML的好处，比如使用SAX来解析XML就像解析本地文件一样，你不需像解析json一样等到整个文档下载完成才开始解析。当你处理很大的数据的时候就会极大地减低内存消耗和增加性能。

现在基本上都是JSON了。

### 16. 正确设定背景图片
如果你使用全画幅的背景图，你就必须使用UIImageView

如果你用小图平铺来创建背景UIColor的colorWithPatternImage来做会更快地渲染也不会花费很多内存

### 17. 设定Shadow Path，阴影用shadowPath

### 18. 优化Table View
Table view需要有很好的滚动性能，不然用户会在滚动过程中发现动画的瑕疵。为了保证table view平滑滚动，确保你采取了以下的措施:

        • 正确使用reuseIdentifier来重用cells
        • 尽量使所有的view opaque，包括cell自身
        • 避免渐变，图片缩放，后台选人
        • 缓存行高
        • 如果cell内现实的内容来自web，使用异步加载，缓存请求结果
        • 使用shadowPath来画阴影
        • 减少subviews的数量
        • 尽量不使用cellForRowAtIndexPath:，如果你需要用到它，只用一次然后缓存结果
        • 使用正确的数据结构来存储数据
        • 使用rowHeight, sectionFooterHeight和 sectionHeaderHeight来设定固定的高，不要请求delegate
        
### 19. 选择正确的数据存储选项当存储大块数据时你会怎么做？你有很多选择，比如：

        •   使用NSUerDefaults
        •   使用XML, JSON, 或者 plist
        •   使用NSCoding存档
        •   使用类似SQLite的本地SQL数据库
        •   使用 Core Data
        
NSUserDefaults的问题是什么？虽然它很nice也很便捷，但是它只适用于小数据，比如一些简单的布尔型的设置选项，再大点你就要考虑其它方式了

XML这种结构化档案呢？总体来说，你需要读取整个文件到内存里去解析，这样是很不经济的。使用SAX又是一个很麻烦的事情。

NSCoding？不幸的是，它也需要读写文件，所以也有以上问题。
在这种应用场景下，使用SQLite 或者 Core Data比较好。使用这些技术你用特定的查询语句就能只加载你需要的对象。

在性能层面来讲，SQLite和Core Data是很相似的。他们的不同在于具体使用方法。Core Data代表一个对象的graph model，但SQLite就是一个DBMS。Apple在一般情况下建议使用Core Data，但是如果你有理由不使用它，那么就去使用更加底层的SQLite吧。

如果你使用SQLite，你可以用FMDB(https://GitHub.com/ccgus/fmdb)这个库来简化SQLite的操作，这样你就不用花很多经历了解SQLite的C API了。

### 20. 使用Autorelease Pool

NSAutoreleasePool负责释放block中的autoreleased objects。一般情况下它会自动被UIKit调用。但是有些状况下你也需要手动去创建它。

假如你创建很多临时对象，你会发现内存一直在减少直到这些对象被release的时候。这是因为只有当UIKit用光了autorelease pool的时候memory才会被释放。好消息是你可以在你自己的@autoreleasepool里创建临时的对象来避免这个行为（自动释放池创建在for循环里边）

### 21. 选择是否缓存图片

imageNamed的优点是当加载时会缓存图片。

相反的，imageWithContentsOfFile仅加载图片，适合加载一个大图片而且是一次性使用。





