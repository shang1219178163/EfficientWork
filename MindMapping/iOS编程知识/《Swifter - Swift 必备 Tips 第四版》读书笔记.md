# Swifter - Swift 必备 Tips 第四版
## 第一节 SwiftTips_新元素
### 柯里化 (Currying)
```
Swift 可以将方法柯里化 (Currying)，把接受多个参数的方法进行一些变形，使其更加灵活的方法。Swift 是函数式语言。

func addTo(_ adder: Int) -> (Int) -> Int {
    return { num in
        return num + adder
    }
}

let addTwo = addTo(2)    // addTwo: Int -> Int”
let result = addTwo(6)
```
### 多元组 (Tuple)
```
原始：
func swapMe1<T>( a: inout T, b: inout T) {”
  let temp = a
  a = b
  b = temp
}
元祖：
func swapMe2<T>( a: inout T, b: inout T) {”
   (a,b) = (b,a)
}
```
### 方法嵌套
```
func makeIncrementor(addNumber: Int) -> ((inout Int) -> Void {
    func incrementor(inout variable: Int) -> Void {
        variable += addNumber;
    }
    return incrementor;
}
```
### protocol 的方法声明为 mutating
```
Swift 的 protocol 不仅可以被 class 类型实现，也适用于 struct 和 enum。
mutating 关键字修饰是为了能在该方法中修改 struct 或是 enum 的变量
（因为这个原因，oc和swift混编的情况下，尽量声明class保持统一性）
```
### 命名空间
```
Swift 的命名空间是基于 module 而不是在代码中显式地指明，每个 module 代表了 Swift 中的一个命名空间。也就是说，同一个 target 里的类型名称还是不能相同的。在我们进行 app 开发时，默认添加到 app 的主 target 的内容都是处于同一个命名空间中的，我们可以通过创建 Cocoa (Touch) Framework 的 target 的方法来新建一个 module
```
### static 和 class
```
在 protocol 里定义一个类型域上的方法或者计算属性的话，应该用 static 定义,因为在struct 或 enum 中使用 static

结论：在任何时候使用 static 应该都是没有问题的
```
### 初始化方法顺序
```
某个类的子类中，初始化方法里语句顺序并不是随意的，需要保证在当前子类实例的成员初始化完成后才能调用父类的初始化方法：

一般来说，子类的初始化顺序是：
1.设置子类自己需要初始化的参数，
2.调用父类的相应的初始化方法，super.init()
3.对父类中的需要改变的成员进行设定
```
### Sequence
```
Swift 的 for...in 可以用在所有实现了 Sequence 的类型上，实现 Sequence 你首先需要实现一个 IteratorProtocol
for...in 内部实现思路：
var iterator = arr.makeIterator()
while let obj = iterator.next() {
   print(obj)
}
```
### typealias
```
typealias 是用来为已经存在的类型重新定义名字的，使代码变得更加清晰。
typealias 是单一的，必须指定将某个特定的类型通过 typealias 赋值为新名字，不能将整个泛型类型进行重命名。
错误代码:
class Person<T> {}
typealias Worker = Person
typealias Worker = Person<T>

不过如果我们在别名中也引入泛型，是可以进行对应的：
// This is OK
typealias Worker<T> = Person<T>

另一个使用场景是某个类型同时实现多个协议的组合时。我们可以使用 & 符号连接几个协议，然后给它们一个新的更符合上下文的名字，来增强代码可读性:
protocol Cat { ... }
protocol Dog { ... }
typealias Pat = Cat & Dog”
```
### 初始化返回 nil
```
Swift 中默认初始化方法是不能写 return 语句来返回值的，也就是说我们没有机会初始化一个 Optional 的值。
可能返回 nil 的 init 方法都加上了 ? 标记：
convenience init?(string URLString: String)
```
### @autoclosure
```
@autoclosure 做的事情就是把一句表达式自动地封装成一个闭包 (closure)
func logIfTrue(_ predicate: @autoclosure () -> Bool) {
    if predicate() {
        print("True")
    }
}
logIfTrue(2 > 1)调用，Swift 将会把 2 > 1 这个表达式自动转换为 () -> Bool
(@autoclosure 并不支持带有输入参数的写法，也就是说只有形如 () -> T 的参数才能使用这个特性进行简化。)
```
### func 的参数修饰
```
Swift 默认所有参数都是 let 的。这样不仅可以确保安全，也能在编译器的性能优化上更有作为。
func incrementor(variable: let Int) -> Int {

希望在方法内部直接修改输入的值
func incrementor(variable: inout Int) {

var luckyNumber = 7
incrementor(variable: &luckyNumber)
```
### Designated，Convenience 和 Required
```
在 OC 中，init 方法是非常不安全的,Apple 也明确说明了不应该在 init 中使用属性来访问，但是这并不是编译器强制的，因此还是会有很多开发者犯这样的错误。

所以 Swift 有了严格的初始化方法。一方面，强化了 designated 初始化方法的地位。Swift 中不加修饰的 init 方法都需要在方法中保证所有非 Optional 的实例变量被赋值初始化，而在子类中也强制 (显式或者隐式地) 调用 super 版本的 designated 初始化，所以无论如何走何种路径，被初始化的对象总是可以完成完整的初始化的。

注意在 init 里可以对 let 的实例常量赋值，这是初始化方法的重要特点。在 Swift 中 let 声明的值是常量，无法被赋值，这对于构建线程安全的 API 十分有用。而因为 Swift 的 init 只可能被调用一次，因此在 init 中我们可以为常量进行赋值，而不会引起任何线程安全的问题。

convenience 的初始化方法是不能被子类重写或者是从子类中以 super 的方式被调用的。

希望子类中一定实现的 designated 初始化方法，可以添加 required 关键字限制，强制子类对这个方法重写实现。这样做的最大的好处是可以保证依赖于某个 designated 初始化方法的 convenience 一直可以被使用。
```
### @escaping
```
Swift 中我们可以定义一个接受函数作为参数的函数，而在调用时，使用闭包的方式来传递这个参数是常见手段：
最简单的形式的闭包其实还默认隐藏了一个假设，block 的调用是同步行为。如果将 block 放到一个 Dispatch 中去，让它在返回后被调用的话，我们就需要在 block 的类型前加上 @escaping 标记来表明这个闭包是会“逃逸”出该方法的：
func doWorkAsync(block: @escaping ()->()) {
    DispatchQueue.main.async {
        block()
    }
}

由于需要确保闭包内的成员依然有效，如果在闭包内引用了 self 及其成员的话，Swift 将强制我们明确地写出 self;   [weak self]
（注意：如果你在协议或者父类中定义了一个接受 @escaping 为参数方法，那么在实现协议和类型或者是这个父类的子类中，对应的方法也必须被声明为 @escaping，否则两个方法会被认为拥有不同的函数签名）
```
### 命名空间
```
Swift 的命名空间是基于 module 而不是在代码中显式地指明，每个 module 代表了 Swift 中的一个命名空间。也就是说，同一个 target 里的类型名称还是不能相同的。在我们进行 app 开发时，默认添加到 app 的主 target 的内容都是处于同一个命名空间中的，我们可以通过创建 Cocoa (Touch) Framework 的 target 的方法来新建一个 module

另一种策略是使用类型嵌套的方法来指定访问的范围。常见做法是将名字重复的类型定义到不同的 struct 中，以此避免冲突。这样在不使用多个 module 的情况下也能取得隔离同样名字的类型的效果
```
### 可变参数函数
```
可变参数函数指的是可以接受任意多个参数的函数，我们最熟悉的可能就是 NSString 的 -stringWithFormat: 方法了。
 Swift 写一个可变参数的函数只需要在声明参数时在类型后面加上 ... 就可以了。

func sum(input: Int...) -> Int {
  return input.reduce(0, +)
}
print(sum(input: 1,2,3,4,5))

限制:在同一个方法中只能有一个参数是可变的，比如可变参数都必须是同一种类型的等。对于后一个限制，当我们想要同时传入多个类型的参数时就需要做一些变通(使用Any类型)。
```
### lazy 修饰符和 lazy 方法
```
class ClassA {
    lazy var str: String = {
        let str = "Hello"
        return str
    }()
}
简化：
lazy var str: String = "Hello
```
### final
```
final 关键字可以用在 class，func 或者 var 前面进行修饰，表示不允许对该内容进行继承或者重写操作。
一般来说，不希望被继承和重写会有这几种情况：
1.类或者方法的功能确实已经完备了
2.子类继承和修改是一件危险的事情
3.为了父类中某些代码一定会被执行
4.性能考虑(有限)
```
### 属性观察
```
Swift 中为我们提供了两个属性观察的方法，它们分别是 willSet 和 didSet。
初始化方法对属性的设定，以及在 willSet 和 didSet 中对属性的再次设定都不会再次触发属性观察的调用，可以放心使用。
想在一个属性定义中同时出现 set 和 willSet 或 didSet 是一件办不到的事情。
```
### Optional
```
enum Optional<T> : _Reflectable, NilLiteralConvertible {
    case None
    case Some(T)
    //...
}
```
### Reflection 和 Mirror
```
熟悉 Java 的读者可能会知道反射 (Reflection)。这是一种在运行时检测、访问或者修改类型的行为的特性。
Objective-C 中我们不太会经常提及到 “反射” 这样的词语，因为 Objective-C 的运行时比一般的反射还要灵活和强大。可能很多读者已经习以为常的像是通过字符串生成类或者 selector，并且进而生成对象或者调用方法等，其实都是反射的具体的表现。 
```
### AnyClass，元类型和 .self
```
Swift 中，.self 可以用在类型后面取得类型本身，也可以用在某个实例后面取得这个实例本身。
class A {}
let typeA: AnyClass = A.self

.Type 表示的是某个类型的元类型，而在 Swift 中，除了 class，struct 和 enum 这三个类型外，我们还可以定义 protocol。对于 protocol 来说，有时候我们也会想取得协议的元类型。这时我们可以在某个 protocol 的名字后面使用 .Protocol 来获取，使用的方法和 .Type 是类似的。
```
### ... 和 ..<
```
在 Swift 中，除了数字以外另一个实现了 Comparable 的基本类型就是 String。也就是说，我们可以通过 ... 或者 ..< 来连接两个字符串。
let interval = "a"..."z
```
### 模式匹配
```
Swift 的 switch 就是使用了 ~= 操作符进行模式匹配，case 指定的模式作为左参数输入，而等待匹配的被 switch 的元素作为操作符的右侧参数,只不过这个调用是由 Swift 隐式地完成的。
 switch 的几种常见用法吧：
 switch password {
     case "akfuv(3":
      print("密码通过")
     case nil:
      print("没值")
     case -1.0...1.0:
      print("区间内")
     case let x where x.hasPrefix("王"):
      print("\(x)是笔者本家")
     default:
      print("验证失败")
}
```
###  隐式解包 Optional
```
一切都是历史的错。因为 Objective-C 中 Cocoa 的所有类型变量都可以指向 nil 的，部分 Cocoa 的 API 中在参数或者返回时即使被声明为具体的类型，但是还是有可能在某些特定情况下是 nil，而同时也有另一部分 API 永远不会接收或者返回 nil。在 Objective-C 时，这两种情况并没有被加以区别，因为 Objective-C 里向 nil 发送消息并不会有什么不良影响。在将 Cocoa API 从 Objective-C 转为 Swift 的 module 声明的自动化工具里，是无法判定是否存在 nil 的可能的，因此也无法决定哪些类型应该是实际的类型，而哪些类型应该声明为 Optional。
我们的代码的其他部分，还是少用这样的隐式解包的 Optional 为好，很多时候多写一个 Optional Binding 就可以规避掉不少应用崩溃的风险。
```
### default 参数
```
Swift 的方法是支持默认参数的，也就是说在声明方法时，可以给某个参数指定一个默认使用的值。在调用该方法时要是传入了这个参数，则使用传入的值，如果缺少这个输入参数，那么直接使用设定的默认值进行调用。

当我们指定一个编译时就能确定的常量来作为默认参数的取值时，这个取值是隐藏在方法实现内部，而不应该暴露给其他部分。
```

## 第二节 SwiftTips_从OC/C到Swift

### UnsafePointer(不安全、不建议使用)
```
指针在 Swift 中不被鼓励，语言标准中完全没有与指针完全等同的概念的。为了与 C 系帝国合作，Swift 定义了一套对 C 语言指针的访问和转换方法，那就是 UnsafePointer 和它的一系列变体。对于使用 C API 时如果遇到接受内存地址作为参数，或者返回是内存地址的情况，在 Swift 里会将它们转为 UnsafePointer<Type> 的类型， 

void method(const int *num) {
其对应的 Swift 方法应该是：
func method(_ num: UnsafePointer<CInt>) {

对于 C 中基础类型，在 Swift 中对应的类型都遵循统一的命名规则：在前面加上一个字母 C 并将原来的第一个字母大写：比如 int，bool 和 char 的对应类型分别是 CInt，CBool 和 CChar。在上面的 C 方法中，我们接受一个 int 的指针，转换到 Swift 里所对应的就是一个 CInt 的 UnsafePointer 类型。这里原来的 C API 中已经指明了输入的 num 指针的不可变的 (const)，因此在 Swift 中我们与之对应的是 UnsafePointer 这个不可变版本。如果只是一个普通的可变指针的话，我们可以使用 UnsafeMutablePointer 来对应：

在 C 中，对指针取值用 *，而Swift 中用 memory 属性来读取相应内存中存储的内容。通过传入指针地址进行方法调用的时候就都比较相似了，都是在前面加上 & 符号，C 的版本和 Swift 的版本只在声明变量的时候有所区别：
//C
int a = 123;
//Swift
var a: CInt = 123
```
### String 还是 NSString
```
1.尽可能的话还是使用原生的 String 类型。原因：Swift 中 String 是 struct，相比 NSObject 的 NSString 类来说，更切合字符串的 "不变" 特性。配合常量赋值 (let) ，在多线程编程时就非常重要了，它从原理上将程序员从内存访问和操作顺序的担忧中解放出来。另外，在不触及 NSString 特有操作和动态特性的时候，使用 String 的方法，在性能上也会有所提升。

2.我们更愿意和基于 Int 的 NSRange 一起工作，而不喜欢使用麻烦的 Range<String.Index>。这种情况下，将 String 转为 NSString 也许是个不错的选择
```
### 内存管理，weak 和 unowned”
```
所有的自动引用计数机制都有一个从理论上无法绕过的限制，那就是循环引用 (retain cycle) 的情况。
Apple 建议是能够确定在访问时不会已被释放的话，使用 unowned，如果存在被释放的可能，那就用 weak。[weak self]
```
### 动态类型和多方法
```
Swift 默认情况下是不采用动态派发的，因此方法的调用只能在编译时决定
```
### @objc 和 dynamic
```
1.首先通过添加 {product-module-name}-Bridging-Header.h 文件，在其中填写想要使用的头文件名称，就能在在 Swift 中使用 OC 代码了。
2.想要在 OC 里使用项目中的 Swift 的源文件的话，导入自动生成的头文件 {product-module-name}-Swift.h 来完成。
3.对于项目来说，外界框架是由 Swift 写的还是 Objective-C 写的，两者并没有太大区别。使用@import 来引入即可。
```
### Selector
```
在 Swift 中没有 @selector 了，取而代之 #selector 
类似地，在 Swift 里原来 SEL 的类型是一个叫做 Selector 的结构体。
在 Swift 4 中，默认所有方法在 OC 中都是不可见的，需要在前面加上 @objc 关键字
```
### 单例
```
class MyManager  {
    static let shared = MyManager()
    private init() {}
}
这种写法不仅简洁，而且保证了单例的独一无二。在初始化类变量的时候，Apple 将会把这个初始化包装在一次 swift_once_block_invoke 中，以保证它的唯一性。不仅如此，对于所有的全局变量，Apple 都会在底层使用这个类似 dispatch_once 的方式来确保只以 lazy 的方式初始化一次。

另外，我们在这个类型中加入了一个私有的初始化方法，来覆盖默认的公开初始化方法，这让项目中的其他地方不能够通过 init 来生成自己的 MyManager 实例，也保证了类型单例的唯一性。如果你需要的是类似 default 的形式的单例 (也就是说这个类的使用者可以创建自己的实例) 的话，可以去掉这个私有的 init 方法。
```
### Protocol Extension
```
Swift 中标准库的功能基本都是基于 protocol 来实现的
protocol extension 为 protocol 中定义的方法提供了一个默认的实现。
使用场景：给某个协议的所有类型添加一些共通的功能时
1.如果类型推断得到的是实际的类型：
那么类型中的实现将被调用；如果类型中没有实现的话，那么协议扩展中的默认实现将被使用。
2.如果类型推断得到的是协议，而不是实际类型：
并且方法在协议中进行了定义，那么类型中的实现将被调用；如果类型中没有实现，那么协议扩展中的默认实现被使用
否则 (也就是方法没有在协议中定义)，扩展中的默认实现将被调用
```
### 条件编译
```
在 C 系语言中，可以使用 #if 或者 #ifdef 之类的编译条件分支来控制哪些代码需要编译，而哪些代码不需要。
#if DEBUGE
#else
#endif

用 DEBUGE 这个编译符号来代表测试接口版本。需要在项目的编译选项中Build Settings 中，找到 Swift Compiler - Custom Flags，并在其中的 Other Swift Flags 加上 -D DEBUGE 就可以了。
```
### @autoreleasepool
```
在 app 中，整个主线程其实是跑在一个自动释放池里的，并且在每个主 Runloop 结束时进行 drain 操作。这是一种必要的延迟释放的方式，因为我们有时候需要确保在方法内部初始化的生成的对象在被返回后别人还能使用，而不是立即被释放掉。

OC 中建立一个自动释放池使用 @autoreleasepool 就行了
Swift中变成一个方法：func autoreleasepool(code: () -> ())
```
### delegate
```
因为 Swift 的 protocol 可以被除了 class 以外的其他类型遵守的，而对于像 struct 或是 enum 这样的类型，本身就不通过引用计数来管理内存，所以也不可能用 weak 这样的 ARC 的概念来进行修饰。

想要在 Swift 中使用 weak delegate，我们就需要将 protocol 限制在 class 内。一种做法是将 protocol 声明为 Objective-C 的，这可以通过在 protocol 前面加上 @objc 关键字来达到，Objective-C 的 protocol 都只有类能实现，因此使用 weak 来修饰就合理了：
@objc protocol MyClassDelegate {
或者
protocol MyClassDelegate: class {
```
### Options
```
通过 typedef 的定义，可以使用 NS_OPTIONS 来把 UIViewAnimationOptions 映射为每一位都不同的一组 NSUInteger。不需要特殊的选项的话，使用 kNilOptions ，它被定义为数字 0。

OptionSetType 是实现了 SetAlgebraType 的，因此我们可以对两个集合进行各种集合运算，包括并集 (union)、交集 (intersect) 等等。另外，对于不需要选项输入的情况，也就是对应原来的 kNilOptions，现在我们直接使用一个空的集合 [] 来表示
```
### 类簇
```
在 OC 中，init 开头的初始化方法实际做的事情和其他方法并没无不同。类簇在 OC 中实现起来很自然，在所谓的“初始化方法”中将 self 进行替换，根据调用的方式或者输入的类型，返回合适的私有子类对象就可以了。
Swift 中的情况不同。因为 Swift 拥有真正的初始化方法，在初始化的时候我们只能得到当前类的实例，并且要完成所有的配置。也就是说对于一个公共类来说，是不可能在初始化方法中返回其子类的信息的。对于 Swift 中的类簇构建，一种有效的方法是使用工厂方法来进行。  
```
### 判等
```
在 Objective-C 中 == 这个符号的意思是判断两个对象是否指向同一块内存地址。
OC 中使用 == 进行的对象指针的判定，Swift 中是 ===。在 Swift 中 === 只有一种重载：
func ===(lhs: AnyObject?, rhs: AnyObject?) -> Bool
它用来判断两个 AnyObject 是否是同一个引用。
```
### 自省/类型判断
```
对于不确定的类型，我们使用 is 来进行判断。is 在功能上相当于原来的 isKindOfClass，检查一个对象是否属于某类型或其子类型。is 和原来的区别在于，不仅可以用于 class 类型上，也可以对 Swift 的其他像是 struct 或 enum 类型进行判断。
```
### KeyPath 和 KVO
```
KVO 的目的并不是为当前类的属性提供一个钩子方法，而是为了其他不同实例对当前的某个属性 (严格来说是 keypath) 进行监听时使用的。
KVO 仅限于在 NSObject 的子类中，因为 KVO 是基于 KVC (Key-Value Coding) 以及动态派发技术实现的，而这些东西都是 Objective-C 运行时的概念。另外由于 Swift 为了效率，默认禁用了动态派发，因此想用 Swift 来实现 KVO，我们还需要做额外的工作，那就是将想要观测的对象标记为 dynamic 和 @objc。
Swift 4 中 Apple 引入了新的 KeyPath 的表达方式:
var observation: NSKeyValueObservation?

observation = myObject.observe(\MyClass.date, options: [.new]) { (_, change) in
    if let newDate = change.newValue {
        print("AnotherClass 日期发生变化 \(newDate)")
    }
}

非 NSObject 的 Swift 类型：因为 Swift 类型并没有通过 KVC 进行实现，所以更不用谈什么对属性进行 KVO 了。语言中现在暂时还没有原生的类似 KVO 的观察机制。我们可能只能通过属性观察来实现一套自己的类似替代了
```
### 局部 scope
```
C 系语言中在方法内部我们是可以任意添加成对的大括号 {} 来限定代码的作用范围的。两个好处，首先是超过作用域后里面的临时变量就将失效，这不仅使方法内的命名更加容易，也使得那些不被需要的引用的回收提前进行了，可以稍微提高一些代码的效率；
Swift 中，直接使用大括号的写法是不支持的，因为这和闭包的定义产生了冲突。如果我们想类似地使用局部 scope 来分隔代码的话，一个不错的选择是定义一个接受 ()->() 作为函数的全局方法，然后执行它：
func local(_ closure: ()->()) {
Swift 2.0 为了处理异常，Apple 加入了 do 关键字来作为捕获异常的作用域。这一功能恰好为我们提供了一个完美的局部作用域，现在我们可以简单地使用 do 来分隔代码了：
do {

}
在 OC 中一个技巧是使用 GNU C 的声明扩展来在限制局部作用域的时候同时进行赋值，运用得当的话，可以使代码更加紧凑和整洁。在 OC 中可以写为：

self.titleLabel = ({
    UILabel *label = [[UILabel alloc]
    label;
});

Swift 里当然没有 GNU C 的扩展，但是使用匿名的闭包的话，写出类似的代码也不是难事：
let titleLabel: UILabel = {
    let label = UILabel(frame: CGRect(x: 150, y: 30, width: 200, height: 40))
    
    return label
}()
```
### Lock
```
@synchronized 在幕后做的事情是调用了 objc_sync 中的 objc_sync_enter 和 objc_sync_exit 方法，并且加入了一些异常判断。
func synchronized(_ lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
```
##  第三节 SwiftTips_开发环境及一些实践
### 文档注释
```
对于程序设计的文档，业界的标准做法都是自动生成。一般我们会将文档嵌入地以某种规范的格式以注释的形式写在实际代码的上方，这样文档的自动生成器就可以扫描源代码并读取这些符合格式的注释，最后生成漂亮的文档了。对于 Objective-C 来说，这方面的自动生成工具有 Apple 标准的 HeaderDoc，以及第三方的 appledoc 或者 Doxygen 等。

方法/**...*/
属性使用 /// 

现在有一个叫做 jazzy 的新项目在这方面已经做出了一些成果。现在 jazzy 已经被 CocoaPods 用作提取 Swift 文档的工具，成为事实上的标准了。
```
### 断言与fatalError
```
断言 (assertion) 在 Cocoa 开发里一般用来在检查输入参数是否满足一定条件，并对其进行“论断”。
Swift 为我们提供了一系列的 assert 方法来使用断言
断言是一个开发时的特性，只有在 Debug 编译的时候有效，而在运行时是不被编译执行的，因此并不会消耗运行时的性能

fatalError强制
在遇到确实因为输入的错误无法使程序继续运行的时候，我们一般考虑以产生致命错误 (fatalError) 的方式来终止程序。
例如只希望被 switch 的内容在某些范围内，在不属于这些范围的 default 块里直接写 fatalError 而不再需要指定返回值。
```
### 随机数生成
```
func arc4random_uniform(_: UInt32) -> UInt32

func random(in range: Range<Int>) -> Int {
    let count = UInt32(range.endIndex - range.startIndex)
    return  Int(arc4random_uniform(count)) + range.startIndex
}
```
### 重写description
```
extension Meeting: CustomStringConvertible {

var description: String {
    return "于 \(self.date) 在 \(self.place) 与 \(self.attendeeName) 进行会议"
    }
}
```
### 错误和异常处理
```
open func write(toFile path: String,  options writeOptionsMask: NSData.WritingOptions) throws

do {
    try d.write(toFile: "Hello", options: [])
} catch let error as NSError {
    print ("Error: \(error.domain)")
}

这其实主要是针对 Cocoa 现有的 API 的一种兼容。对于新写的可抛出异常的 API，应当抛出一个实现了 Err 协议的类型，enum 就非常合适，举个例子：
enum LoginError: Error {
case UserNotFound, UserPasswordNotMatch
}

func login(user: String, password: String) throws {
//users 是 [String: String]，存储[用户名:密码]
if !users.keys.contains(user) {
    throw LoginError.UserNotFound
}
if users[user] != password {
    throw LoginError.UserPasswordNotMatch
}
print("Login successfully.")
}

在调用时，catch 语句实质上是在进行模式匹配：
do {
    try login(user: "onevcat", password: "123")
} catch LoginError.UserNotFound {
    print("UserNotFound")
} catch LoginError.UserPasswordNotMatch {
    print("UserPasswordNotMatch")
}
另一个限制是对于非同步的 API 来说，抛出异常是不可用的 -- 异常只是一个同步方法专用的处理机制。Cocoa 框架里对于异步 API 出错时，保留了原来的 Error 机制，比如很常用的 URLSession 中的 dataTask API:
func dataTask(with: URLRequest,  completionHandler: (Data?, URLResponse?, Error?) -> Void)
```
### try 和 throws
```
想再多讲两个小点。首先，try 接 ! 表示强制执行，调用中出现了异常的话，程序将崩溃，这和我们在对 Optional 值用 ! 进行强制解包时的行为是一致的。另外，我们也可以在 try 接 ? 表示尝试性的运行。try? 会返回一个 Optional 值：如果运行成功，没有抛出错误的话，它会包含这条语句的返回值，否则将为 nil。和其他返回 Optional 的方法类似，一个典型的 try? 的应用场景是和 if let 这样的语句搭配使用，不过如果你用了 try? 的话，就意味着你无视了错误的具体类型
```
### 闭包歧义
```
Swift 的闭包写法很多，但是最正规的应该是完整地将闭包的输入和输出都写上，然后用 in 关键字隔离参数和实现。
```
### @dynamic
```
在 OC 中，某个属性实现为 @dynamic 的话，就意味着告诉编译器我们不会在编译时就确定这个属性的行为实现，因此不需要在编译期间对这个属性的 getter 或/及 setter 做检查和关心。表示我们将在运行时来提供这个属性的存取方法 (当然相应地，如果在运行时你没有履行这个承诺的话，应用就会挂给你看)
```
### 属性访问控制
```
Swift 中提供了 private，fileprivate，internal，public 和 open 五种访问控制的权限。
默认的 internal 在绝大部分时候是适用的，另外由于它是 Swift 中的默认的控制级，因此它也是最为方便的。
private 让代码只能在当前作用域或者同一文件中同一类型的作用域中被使用，
fileprivate 表示代码可以在当前文件中被访问，而不做类型限定。
public 和 open 的区别在于，只有被 open 标记的内容才能在别的框架中被继承或者重写。因此，如果你只希望框架的用户使用某个类型和方法，而不希望他们继承或者重写的话，应该将其限定为 public 而非 open。

属性的访问控制可以通过两次的访问权限指定来实现
public class MyClass {
    public private(set) var name: String?
}
```
### 溢出
```
如果我们想要其他编程语言那样的对溢出处理温柔一些，不是让程序崩溃，而是简单地从高位截断的话，可以使用溢出处理的运算符，在 Swift 中，我们可以使用以下这五个带有 & 的操作符，这样 Swift 就会忽略掉溢出的错误：
溢出加法 (&+)
溢出减法 (&-)
溢出乘法 (&*)
溢出除法 (&/)
溢出求模 (&%)
```
### 性能考虑
```
如果遇到性能敏感和关键的代码部分，我们最好避免使用 Objective-C 和 NSObject 的子类。
```
### Log 输出
```
public func DDLog(_ msgs: Any..., fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
#if DEBUG
let params = msgs.compactMap{ "\($0)" }.joined(separator: "\n__");
let formatter = DateFormatter.format("yyyy-MM-dd HH:mm:ss.SSS");
print(formatter.string(from: Date()),"\((fileName as NSString).lastPathComponent).\(methodName)[\(lineNumber)]:\n__\(params)")
#endif
}
```
### 宏定义 define
```
Swift 中没有宏定义了。
1.使用合适作用范围的 let 或者 get 属性来替代原来的宏定义值
2.对于宏定义的方法，类似地在同样作用域写为 Swift 方法。一个最典型的例子是 NSLocalizedString 的转变： 
```
### 兼容性
```
项目 app target 的编译设置中 Build Options 下的 Embedded Content Contains Swift Code 设置为 Yes，以确保 Swift 的运行库被打包进 app 中。

另外还需一提的是对于第三方框架的使用。虽然我们在 Framework 一节中提到了使用 Swift 构建框架并提供使用，但是现在直接使用编译好的 Swift 框架并不是一件明智的事情。对于第三方 Swift 代码的正确使用方式，要么是直接将源代码添加到项目中进行编译，要么是将生成 framework 的项目作为依赖添加到自己的项目中一起编译。总之，我们最好是取得源代码并确保让其与我们的项目共用同一套运行环境，任何已编译好的二进制包在运行使用时都是要承担 Swift 版本升级所带来的兼容性风险的。
```
### 泛型扩展
```
Swift 对于泛型类型，使用 extension 为泛型类型添加新的方法
```
### 尾递归
```
对于递归，解决栈溢出的一个好方法是采用尾递归的写法。顾名思义，尾递归就是让函数里的最后一个动作是一个函数调用的形式，这个调用的返回值将直接被当前函数返回，从而避免在栈上保存状态。
```
