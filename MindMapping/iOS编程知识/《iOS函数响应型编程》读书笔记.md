### 函数式编程



1. 基本概念

函数式编程的核心是：在你的开发语言中函数本身是一个对象，且是所有类对象中的一等公民。

因为函数式反应型编程是命令行编程与函数式编程两者相互妥协的最佳平衡点。

函数式编程的一个关键的概念是高阶函数。

一个高阶函数需要满足下面两个条件:

一个或者多个函数作为输入。

有且仅有一个函数输出。

2.

高阶函数映射map.

映射是在函数的层次上把一个列表变成相同长度的另一个列表，原始列表中的每一个值，在新的列表中都有一个对应的值。

高阶函数过滤器filter。

一个列表通过过滤能够返回一个只包含了原列表中符合条件的元素的新列表，





高阶函数折叠Flod

她把列表中的所有元素变成一个值。





 3.

流是值的序列化的抽象，你可以认为一个流就像一条水管，而值就是流淌在水管中的水，值从管道的一端流入从另一端流出。当值从管道的另一端流出的时候，我们可以读取过去所有的值，甚至是刚刚进入管道的值(即当前值)。



ReactiveCocoa具有左折叠和右折叠的概念。左折叠时折叠算法将从头到尾遍历数组，反之称为右折叠。这样的命名(即左、右折叠)暗示了编程语言对列表的理解，这种概念在Objective-C中是没有的。





4.

信号是另一种类型的流。与序列流相反，信号是push-driven的。新的值能够通过管道发布但不能像pull-driven一样在管道中获取，他们所抽象出来的数据会在未来的某个时间传送过来。

Push-driven : 在创建信号的时候，信号不会被立即赋值，之后才会被赋值(举个栗子：网络请求回来的结果或者是任意的用户输入的结果)

Pull-driven : 在创建信号的同时序列中的值就会被确定下来，我们可以从流中一个个地查询值。





信号发送三种类型的值：Next Values代表了下一个发送到管道内的值。Error Value代表signal无法成功完成,Completion Values代表signal成功完成





一个事情响应中，一个signal(信号)发送了一个Error value或者一个Completion Value后，就不会再发送任何其他的value.

错误或者成功将只会发送其中一个，绝不会有两个同时发送的情况！

信号是ReactiveCocoa的核心组件之一。ReactiveCocoa为UIKit的每一个控件内置了一套信号选择器。



当你随时都想知道某一个值的改变时(不管是next、error或者completion),你就会订阅流—-一种最常见的signal.使用信号通常都会有副作用





5.

状态推导是ReactiveCocoa的另一个核心组件。这里并非指类的某个属性(设置一个新的值就代表状态发生了改变那样)，这里我们指的是把属性抽象为流。

RAC()宏需要两个参数:‘对象’以及这个对象的某个属性的’keyPath’。然后将表达式右边的值和’keyPath’做一个单向的绑定，这个值必须是NSObject类型，所以我们会把boolean量封装成NSNumber。



**///  RAC(self, objectProperty) = objectSignal;**

**///  RAC(self, stringProperty, @'foobar') = stringSignal;**

**///  RAC(self, integerProperty, @42) = integerSignal;**







6.

指令，RACCommand类的代表，创建并订阅动作的信号响应，可以很容易地实现一些用户与应用交互时的边界效果。

指令(行为触发的)通常是UI驱动的，比如按键的点击。指令也可以通过信号自动禁用，这种禁用状态呈现在UI上就是禁用与该指令相关联的任何操作。





7.

RACSubject是一个有趣的信号类型。在’ReactiveCocoa’的世界中，她是一个可变的状态。她是一个你可以主动发送新值的信号。出于这个原因，除非情况特殊，我们不推荐使用她。





信号是典型的懒鬼，除非有人订阅他们，他们是不会启动并发送的。每增加一个订阅，它们都会重复地多发送一个信号。

有的时候我们希望让信号立即工作(不需要中间这么繁琐的设置),ReactiveCocoa中称为’热(信号)’。这种信号用的非常少。







8.

组播是用多个订阅者共享一个订阅信号的术语。

由于信号是冷启动的，每增加一个订阅者，她就会被执行一次。这种情况是我们不希望看到的，可以使用组播连接来改善。

信号的组播连接订阅，当她传送一个新值的时候，是通过公共频道来传送给信号的。只要你喜欢你可以随意订阅这个信号，但这个信号在订阅相关的操作上有且仅会执行一次，不再像以前那样增加一个订阅者这个信号上就执行一次订阅相关的操作。







9.

空存根方法：源于C++的一个非常不错的函数设计方法。

存根是一个仅仅返回某个意义不大的值的空函数。存根可以用来测试整个程序的逻辑关系，以及分块实现程序的不同部分。



RACSignal *photosLoaded = [photoSignal catch:^RACSignal *(NSError *error) {



​    NSLog(@'Couldn't fetch photos from 500px : %@',error);



​    return [RACSignal empty];



}];









比起subscribeError:方法，catch:方法处理的更为巧妙：它允许无错误值的信号穿透它，仅在信号有错误事件发生时才会调用它的block并发送其在发生错误时的返回值。这里我们使用catch:方法，来过滤无错误的值。

RAC(self.imageView, image) = [[RACObserve(self, photoModel.thumbnailData) ignore:nil]



​                            map:^(NSData *data){



​                                return [UIImage imageWithData:data];

 }];





 return [[[NSURLConnection rac_sendAsynchronousRequest:request]



​                map:^id (RACTuple *value) {



​                    return [value second];



​                }] deliverOn:[RACScheduler mainThreadScheduler]];





RACTuple它所发送的内容分别包含响应和数据。有网络错误发生时，它会抛出错误。 最后我们改变线程的调度，将signal切换到主线程上。 (一个线程的调度者类似于一个线程。)

publish返回一个RACMulitcastConnection,当信号连接上时，他将订阅该接收信号。autoconnect为我们做的是：当它返回的信号被订阅，连接到

该(订阅背后的)信号（underly signal）。





用下面的reduceEach:替代使用RACTuple的第一个map:，以便提供编译时检查。

reduceEach:^id(NSURLResponse *response, NSData *data) {

​    return data;



}]





总结：

函数式编程可在任何地方起作用

为函数的副作用使用subscribeNext:

避免显示状态下进行订阅处理

ReactiveCocoa中也一样。唯一要注意的是，不能在任何signal的block中捕捉self。





备注：

BTY:函数副作用：指当调用函数时，除了返回函数值之外，还对主调用函数产生附加影响。

严格的函数式语言要求函数必须无副作用。





MVVM



在传统的MVC架构的应用中，你有三种组件：数据模型、视图以及试图控制器。数据模型保持你的数据，而视图用来呈现这些数据。控制器介于这两个组件之间调解所有的交互。

当新的数据到达时，model会通知ViewController（通常是通过键-值观察(KVO)的方式），然后ViewController会更新View。当View接收交互时，ViewController会更新Model。

ReactiveCocoa将会监控数据模型(model)的变化，并将这个变化映射到视图模型(viewModel)的属性上，执行任意必要的业务逻辑。