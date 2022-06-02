## iOS中常见的设计模式

#### 1.工厂方法模式（Factory Method）
提供一个创建一系列相关或相互依赖对象的接口，而无需指定它们具体的类。

+(instancetype)buttonWithType:(UIButtonType)buttonType;
[NSNumber numberWithBool:YES] 
[NSNumber numberWithInt:1]

#### 2.享元模式（Flyweight）
运用共享技术有效地支持大量细粒度的对象。

UITableViewCell的复用

#### 3.迭代器模式（Iterator）
提供一种方法顺序访问一个聚合对象中各个元素，而又不暴露该对象的内部表示。

iOS的Block迭代、数组迭代都是迭代器模式的典型实现。

#### 4.单例模式（Singleton）
保证一个类仅有一个实例，并提供一个访问它的全局访问点。

iOS的UIApplicationDelegate就是一个单列模式的实现。

#### 5.观察者模式（Observer）
定义了一种一对多的依赖关系，让多个观察者对象同时监听某一个主题对象。这个主题对象在状态发生变化时，会通知所有观察者对象，使它们能够自动更新自己。

iOS中的KVO、NSNotication都是观察者模式。

#### 6.职责链模式（Chain of Responsibility）
使多个对象都有机会处理请求，从而避免请求的发送者和接收者之间的耦合关系。将这个对象连成一条链，并沿着这条链传递该请求，直到有一个对象处理它为止。

iOS事件的传递和响应就是职责链模式的实现。

#### 7.备忘录模式（Memento）
在不破坏封装性的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态。这样以后就可将该对象恢复到原先保存的状态。

iOS对对象的归档接档。

#### 8.原型模式（Prototype）
用原型实例指定创建对象的种类，并且通过拷贝这些原型创建新的对象。原型模式是非常简单的一种设计模式, 在多数情况下可被理解为一种深复制的行为。在Objective-C中使用原型模式, 首先要遵循NSCoping协议(OC中一些内置类遵循该协议, 例如NSArray, NSMutableArray等)。还有KVO的实现原理也是原型模式。




