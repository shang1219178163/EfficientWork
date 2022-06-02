#深入理解 Swift 派发机制学习


|   | Direct    | Table | Message                          |
|------------|------------------|---------------------|---------------------------------------------|
| NSObject   | @noobjc/final    | Initial Declaration | Extensions dynamic                          |
| Class      | Extensions final | Initial Declaration | dynamic                                     |
| Protocol   | Extensions       | Initial Declaration | Objc Declarations @objc declaration modifer |
| Value Type | All Methods      | N/a                 | N/a                                         |

一张表总结引用类型, 修饰符和它们对于 Swift 函数派发方式的影响.

函数派发就是程序判断使用哪种途径去调用一个函数的机制. 每次函数被调用时都会被触发, 但你又不会太留意的一个东西. 了解派发机制对于写出高性能的代码来说很有必要, 而且也能够解释很多 Swift 里”奇怪”的行为.

####派发方式 (Types of Dispatch )
编译型语言有三种基础的函数派发方式: 直接派发(Direct Dispatch), 函数表派发(Table Dispatch) 和 消息机制派发(Message Dispatch), 下面我会仔细讲解这几种方式. 大多数语言都会支持一到两种, Java 默认使用函数表派发, 但你可以通过 final 修饰符修改成直接派发. C++ 默认使用直接派发, 但可以通过加上 virtual 修饰符来改成函数表派发. 而 Objective-C 则总是使用消息机制派发, 但允许开发者使用 C 直接派发来获取性能的提高. 这样的方式非常好, 但也给很多开发者带来了困扰

程序派发的目的是为了告诉 CPU 需要被调用的函数在哪里, 在我们深入 Swift 派发机制之前, 先来了解一下这三种派发方式, 以及每种方式在动态性和性能之间的取舍.

#####直接派发 (Direct Dispatch)
直接派发是最快的, 不止是因为需要调用的指令集会更少, 并且编译器还能够有很大的优化空间, 例如函数内联等, 但这不在这篇博客的讨论范围. 直接派发也有人称为静态调用.
然而, 对于编程来说直接调用也是最大的局限, 而且因为缺乏动态性所以没办法支持继承.

#####函数表派发 (Table Dispatch )
函数表派发是编译型语言实现动态行为最常见的实现方式. 函数表使用了一个数组来存储类声明的每一个函数的指针. 大部分语言把这个称为 “virtual table”(虚函数表), Swift 里称为 “witness table”. 每一个类都会维护一个函数表, 里面记录着类所有的函数, 如果父类函数被 override 的话, 表里面只会保存被 override 之后的函数. 一个子类新添加的函数, 都会被插入到这个数组的最后. 运行时会根据这一个表去决定实际要被调用的函数.

#####消息机制派发 (Message Dispatch )
消息机制是调用函数最动态的方式. 也是 Cocoa 的基石, 这样的机制催生了 KVO, UIAppearence 和 CoreData 等功能. 这种运作方式的关键在于开发者可以在运行时改变函数的行为. 不止可以通过 swizzling 来改变, 甚至可以用 isa-swizzling 修改对象的继承关系, 可以在面向对象的基础上实现自定义派发.

###Swift 的派发机制
有四个选择具体派发方式的因素存在:
1. 声明的位置
2. 引用类型
3. 特定的行为
4. 显式地优化(Visibility Optimizations)
在解释这些因素之前, 我有必要说清楚, Swift 没有在文档里具体写明什么时候会使用函数表什么时候使用消息机制. 唯一的承诺是使用 dynamic 修饰的时候会通过 Objective-C 的运行时进行消息机制派发. 

|                  | Initial Declaration | Extensions |
|------------------|---------------------|------------|
| NSObjct Subclass | Table               | Message    |
| Class            | Table               | Static     |
| Protocol         | Table               | Static     |
| Value Type       | Static              | Static     |

这张表格展示了默认情况下 Swift 使用的派发方式.

总结起来有这么几点:

* NSObject 声明作用域里的函数都会使用函数表进行派发; extension 会使用消息机制进行派发
* 而协议和类的 extension 都会使用直接派发
* NSObject 的 * 协议里声明的, 并且带有默认实现的函数会使用函数表进行派发
* 值类型总是会使用直接派发, 简单易懂

###指定派发方式 (Specifying Dispatch Behavior)
Swift 有一些修饰符可以指定派发方式.

####final
final 允许类里面的函数使用直接派发. 这个修饰符会让函数失去动态性. 任何函数都可以使用这个修饰符, 就算是 extension 里本来就是直接派发的函数. 这也会让 Objective-C 的运行时获取不到这个函数, 不会生成相应的 selector.

####dynamic
dynamic 可以让类里面的函数使用消息机制派发. 使用 dynamic, 必须导入 Foundation 框架, 里面包括了 NSObject 和 Objective-C 的运行时. dynamic 可以让声明在 extension 里面的函数能够被 override. dynamic 可以用在所有 NSObject 的子类和 Swift 的原声类.

####@objc & @nonobjc
@objc 和 @nonobjc 显式地声明了一个函数是否能被 Objective-C 的运行时捕获到. 使用 @objc 的典型例子就是给 selector 一个命名空间 @objc(abc_methodName), 让这个函数可以被 Objective-C 的运行时调用. @nonobjc 会改变派发的方式, 可以用来禁止消息机制派发这个函数, 不让这个函数注册到 Objective-C 的运行时里. 我不确定这跟 final 有什么区别, 因为从使用场景来说也几乎一样. 我个人来说更喜欢 final, 因为意图更加明显.

译者注: 我个人感觉, 这这主要是为了跟 Objective-C 兼容用的, final 等原生关键词, 是让 Swift 写服务端之类的代码的时候可以有原生的关键词可以使用.

####final @objc
可以在标记为 final 的同时, 也使用 @objc 来让函数可以使用消息机制派发. 这么做的结果就是, 调用函数的时候会使用直接派发, 但也会在 Objective-C 的运行时里注册响应的 selector. 函数可以响应 perform(selector:) 以及别的 Objective-C 特性, 但在直接调用时又可以有直接派发的性能.

####@inline
Swift 也支持 @inline, 告诉编译器可以使用直接派发. 有趣的是, dynamic @inline(__always) func dynamicOrDirect() {} 也可以通过编译! 但这也只是告诉了编译器而已, 实际上这个函数还是会使用消息机制派发. 这样的写法看起来像是一个未定义的行为, 应该避免这么做.

###修饰符总结 (Modifier Overview)

| final   | Static                                  |
|---------|-----------------------------------------|
| dynamic | Message                                 |
| @objc   | Modify Objc Visibility                  |
| @inline | Code generation hint for direct dispatch|



