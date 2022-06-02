### Category如何加载
    通过 dynamic loader 动态加载 

###  简述 Category 的实现原理
    Objective-C 通过 Runtime 运行时来实现动态语言特性，所有的类和对象，在 Runtime 中都是用结构体来表示的，
    Category 在 Runtime 中是用结构体 category_t 来表示的，下面是结构体 category_t 具体表示：

```
typedef struct category_t {
    const char *name;//类的名字 主类名字
    classref_t cls;//类
    struct method_list_t *instanceMethods;//实例方法的列表
    struct method_list_t *classMethods;//类方法的列表
    struct protocol_list_t *protocols;//所有协议的列表
    struct property_list_t *instanceProperties;//添加的所有属性
} category_t;
```

### Category 为什么不能添加实例变量
    通过结构体 category_t ，我们就可以知道，在 Category 中我们可以增加实例方法、类方法、协议、属性。这里没有 objc_ivar_list 结构体，代表我们不可以在分类中添加实例变量。

    因为在运行期，对象的内存布局已经确定，如果添加实例变量就会破坏类的内部布局，这个就是 Category 中不能添加实例变量的根本原因。

### Category中有load方法吗？load方法是什么时候调用的？load 方法能继承吗？
    答：Category中有load方法，load方法在程序启动装载类信息的时候就会调用。load方法可以继承。调用子类的load方法之前，会先调用父类的load方法

### load、initialize的区别，以及它们在category重写的时候的调用的次序。
    答：区别在于调用方式和调用时刻
    调用方式：load是根据函数地址直接调用，initialize是通过objc_msgSend调用
    调用时刻：load是runtime加载类、分类的时候调用（只会调用1次），initialize是类第一次接收到消息的时候调用，每一个类只会initialize一次（父类的initialize方法可能会被调用多次）

    调用顺序：先调用类的load方法，先编译那个类，就先调用load。在调用load之前会先调用父类的load方法。
            分类中load方法不会覆盖本类的load方法，先编译的分类优先调用load方法。initialize先初始化父类，之后再初始化子类。
            如果子类没有实现+initialize，会调用父类的+initialize（所以父类的+initialize可能会被调用多次），如果分类实现了+initialize，就覆盖类本身的+initialize调用。
            
### 方法覆盖
category其实并不是完全替换掉原来类的同名方法，只是category在方法列表的前面而已，所以我们只要顺着方法列表找到最后一个对应名字的方法，就可以调用原来类的方法;

### Category 关联对象又是存在什么地方呢？如何存储？对象销毁时候如何处理关联对象呢？
    由一个静态AssociationsHashMap来存储所有的关联对象的。所有对象的关联对象都存在一个全局map里面。而map的的key是这个对象的指针地址（任意两个不同对象的指针地址一定是不同的），而这个map的value又是另外一个AssociationsHashMap，里面保存了关联对象的kv对。

    runtime的销毁对象函数objc_destructInstance里面会判断这个对象有没有关联对象，如果有，会调用_object_remove_assocations做关联对象的清理工作。

### 项目中用 Category 一般用来实现什么功能
    通过分类来为已知的类扩展方法和属性，Category 不会为我们的属性添加实例变量和存取方法，我们可以通过关联对象这个技术来实现对象绑定
    通过实现分类的 load 方法来实现 Method Swizzling
    将一个类拆分成多个实现文件，典型的就是将项目中 AppDelegate 拆分。 AppDelegate 作为程序的入口，一般都会实现各种第三方 SDK 的初始化、写各种版本的容错代码、实现通知、支付逻辑等等功能，所以 AppDelegate 这个类很容易臃肿，这个时候可以通过实现 AppDelegate 分类来将不同的业务代码分离。





