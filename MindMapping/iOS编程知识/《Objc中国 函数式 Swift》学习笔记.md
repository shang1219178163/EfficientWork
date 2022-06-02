
# Objc中国 - 函数式 Swift

## 第一节 引言

```
模块化： 相较于把程序认为是一系列赋值和方法调用，函数式开发者更倾向于强调每个程序都能够被反复分解为越来越小的模块单元，而所有这些块可以通过函数装配起来，以定义一个完整的程序。

对可变状态的谨慎处理

面向对象编程专注于类和对象的设计，每个类和对象都有它们自己的封装状态。

函数式编程强调基于值编程的重要性，这能使我们免受可变状态或其他一些副作用的困扰。通过避免可变状态，函数式程序比其对应的命令式或者面向对象的程序更容易组合。


类型： 最后，一个设计良好的函数式程序在使用类型时应该相当谨慎。精心选择你的数据和函数的类型，将会有助于构建你的代码，这比其他东西都重要。

避免使用程序状态和可变对象，是降低程序复杂度的有效方式之一，而这也正是函数式编程的精髓。函数式编程强调执行的结果，而非执行的过程。我们先构建一系列简单却具有一定功能的小函数，然后再将这些函数进行组装以实现完整的逻辑和复杂的运算，这是函数式编程的基本思想。

Swift 函数式编程特性的一些基本概念，包括高阶函数的使用方法，不可变量的必要性，可选值的存在价值，枚举在函数式编程中的意义，以及纯函数式数据结构的优势等内容。
```

## 第二节 函数式思想

```
函数式编程的核心理念就是函数是值，它和结构体、整型或是布尔型没有什么区别 —— 对函数使用另外一套命名规则会违背这一理念。

Objective-C 通过引入 blocks 实现了对一等函数的支持：你可以将函数和闭包作为参数并轻松地使用内联的方式定义它们。然而，在 Objective-C 中使用它们并不像在 Swift 中一样方便，尽管两者在语意上完全相同。
```

## 第三节 案例研究：封装 Core Image

```
滤镜类型
CIFilter 是 Core Image 中的核心类之一，用于创建图像滤镜。当实例化一个 CIFilter 对象时，你 (几乎) 总是通过 kCIInputImageKey 键提供输入图像，再通过 outputImage 属性取回处理后的图像。取回的结果可以作为下一个滤镜的输入值。

高斯模糊滤镜
func blur(radius: Double) -> Filter {
return { image in
    let parameters: [String: Any] = [
        kCIInputRadiusKey: radius,
        kCIInputImageKey: image
        ]
    guard let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameters) else { fatalError() }
    guard let outputImage = filter.outputImage else { fatalError() }
    return outputImage
    }
}
一切就是这么简单。blur 函数返回一个新函数，新函数接受一个 CIImage 类型的参数 image，并返回一个新图像 (return filter.outputImage)。因此，blur 函数的返回值满足我们之前定义的 (CIImage) -> CIImage，也就是 Filter 类型。

IFilter 的初始化及 filter 的 outputImage 属性都返回可选值，我们使用了 guard 语句来解包这些可选值。如果这些值中有 nil，那么就意味着发生了程序错误的情况。比方说，如果我们向滤镜传递了错误的参数，就会导致这种情况。结合 fatalError() 使用 guard 语句而非强制解包可选值使得这种意图更明显。

颜色生成滤镜 (CIConstantColorGenerator) 和图像覆盖合成滤镜 (CISourceOverCompositing)。

func generate(color: UIColor) -> Filter {
    return { _ in
        let parameters = [kCIInputColorKey: CIColor(cgColor: color.cgColor)]
        guard let filter = CIFilter(name:"CIConstantColorGenerator",
        withInputParameters: parameters) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        return outputImage
        }
}

颜色生成滤镜不检查输入图像

合成滤镜：
func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
            ]
    guard let filter = CIFilter(name:"CISourceOverCompositing",
    withInputParameters: parameters) else { fatalError() }
    guard let outputImage = filter.outputImage else { fatalError() }
    return outputImage.cropped(to: image.extent)
    }
}

结合两个滤镜来创建颜色叠层滤镜：
func overlay(color: UIColor) -> Filter {
    return { image in
    let overlay = generate(color: color)(image).cropped(to: image.extent)
    return compositeSourceOver(overlay: overlay)(image)
    }
}

首先使用先前定义的颜色生成滤镜函数 generate(color:) 来生成一个新叠层。然后以颜色作为参数调用该函数，返回 Filter 类型值。而 Filter 类型本身就是一个从 CIImage 到 CIImage 的函数，因此我们还可以向 generate(color:) 函数传递一个 image 参数，最终通过计算能够得到一个 CIImage 类型的新叠层。

理论背景：柯里化
func add1(_ x: Int, _ y: Int) -> Int {
    return x + y
}

func add2(_ x: Int) -> ((Int) -> Int) {
    return { y in x + y }
}

add1 与 add2 的区别在于调用方式：

add1(1, 2) // 3
add2(1)(2) // 3

将一个接受多参数的函数变换为一系列只接受单个参数的函数，这个过程被称为柯里化 (Currying)

安全 — 使用我们构筑的 API 几乎不可能发生由未定义键或强制类型转换失败导致的运行时错误。

模块化 — 使用 >>> 运算符很容易将滤镜进行组合。这样你可以将复杂的滤镜拆解为更小，更简单，且可复用的组件。此外，组合滤镜与组成它的组件是完全相同的类型，所以你可以交替使用它们。

清晰易懂 — 即使你从未使用过 Core Image，也应该能够通过我们定义的函数来装配简单的滤镜。你完全不需要关心 kCIInputImageKey 或 kCIInputRadiusKey 这样的特定键如何进行初始化。单看类型，你几乎就能够知道如何使用 API，甚至不需要更多文档。
```

## 第四节 Map、Filter 和 Reduce

```
接受其它函数作为参数的函数有时被称为高阶函数。

func compute(array: [Int], transform: (Int) -> Int) -> [Int] {
    var result: [Int] = []
    for x in array {
        result.append(transform(x))
    }
    return result
}

顶层函数

我们可以使用泛型。不论参数是 transform: (Int) -> Bool 还是 transform: (Int) -> Int，compute 的定义是相同的；唯一的区别在于类型签名 (type signature)。假如我们要定义一个参数为 transform: (Int) -> String 的相似函数来支持 String 类型，其函数体也将会与先前两个函数完全一致。事实上，相同部分的代码可以用于任何类型。我们真正想做的是写一个能够适用于每种可能类型的泛型函数：

func genericCompute<T>(array: [Int], transform: (Int) -> T) -> [T] {
    var result: [T] = []
    for x in array {
        result.append(transform(x))
    }
    return result
}

reduce 会反复分配内存，释放内存，以及复制大量内存中的内容。

泛型和 Any 类型，Any 类型，它能代表任何类型的值。两者之间的区别至关重要：泛型可以用于定义灵活的函数，类型检查仍然由编译器负责；而 Any 类型则可以避开 Swift 的类型系统 (所以应该尽可能避免使用)。

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { x in { y in f(x, y) } }
}

使用泛型允许你无需牺牲类型安全就能够在编译器的帮助下写出灵活的函数；如果使用 Any 类型，那你就真的就孤立无援了。
```

## 第五节 可选值

```
Swift 的可选类型可以用来表示可能缺失或是计算失败的值。

若使用可选链

if let myState = order.person?.address?.state {
    print("This order will be shipped to \(myState)")
} else {
    print("Unknown person, address, or state.")
}
我们使用了问号运算符来尝试对可选类型进行解包，而不是强制将它们解包。访问任意属性失败时，都将会导致整条语句链返回 nil。

guard 语句的设计旨在当一些条件不满足时，可以尽早退出当前作用域。
guard let x = optional else { return nil }

func add2(_ optionalX: Int?, _ optionalY: Int?) -> Int? {
    if let x = optionalX, let y = optionalY {
        return x + y
    }
    return nil
}

func add3(_ optionalX: Int?, _ optionalY: Int?) -> Int? {
    guard let x = optionalX, let y = optionalY else { return nil }
    return x + y
}

func populationOfCapital(country: String) -> Int? {
    guard let capital = capitals[country], let population = cities[capital]
else { return nil }
    return population * 1000
}

func add4(_ optionalX: Int?, _ optionalY: Int?) -> Int? {
    return optionalX.flatMap { x in
        optionalY.flatMap { y in
            return x + y
        }
    }
}

func populationOfCapital3(country: String) -> Int? {
    return capitals[country].flatMap { capital in
            cities[capital]
        }.flatMap { population in
            population * 1000
    }
}

是当我们试图将 NSAttributedString 初始化为 nil 时
return [[NSAttributedString alloc] initWithString:capital attributes:attr];

if ([someString rangeOfString:@"swift"].location != NSNotFound) {

若 someString 是 nil，rangeOfString: 将返回一个属性全为零的结构体，location 将返回 0。接着所做的判断结果若为真，if 语句中的代码将被执行。
```

## 第六节 案例研究：QuickCheck

```
测试框架都遵循一个相似的模式：测试通常由一些代码片段和预期结果组成。执行代码之后，将它的结果与测试中定义的预期结果相比较。
```

## 第七节 不可变性的价值

```
Swift 数组就是这样的：它们使用低层级的可变数据结构，但提供一个高效且不可变的接口。这里使用了一个被称为写入时复制 (copy-on-write) 的技术。

那些函数的输出值都只取决于输入值。像这样只要输入值相同则得到的输出值一定相同的函数有时被称为引用透明函数。
```

## 第八节 枚举

```
在设计和实现 Swift 应用时，类型扮演着非常重要的角色，这也是本书想说明的重点之一。

Swift 函数式编程中的一条核心原则：高效地利用类型排除程序缺陷。

enum Result<T> {
case success(T)
case error(Error)
}
```

## 第九节 纯函数式数据结构

```
纯函数式数据结构 (Purely Functional Data Structures) 指的是那些具有不变性的高效的数据结构。

extension Diagram {
    var size: CGSize {
    switch self {
    case .primitive(let size, _):
        return size
    case .attributed(_, let x):
        return x.size
    case let .beside(l, r):
        let sizeL = l.size
        let sizeR = r.size
        return CGSize(width: sizeL.width + sizeR.width, height: max(sizeL.height, sizeR.height))
    case let .below(l, r):
        return CGSize(width: max(l.size.width, r.size.width), height: l.size.height + r.size.height)
    case .align(_, let r):
        return r.size
        }
    }
}

extension CGContext {
    func draw(_ primitive: Primitive, in frame: CGRect) {
        switch primitive {
        case .rectangle:
            fill(frame)
        case .ellipse:
            fillEllipse(in: frame)
        case .text(let text):
            let font = UIFont.systemFont(ofSize: 12)
            let attributes = [NSAttributedStringKey.font: font]
            let attributedText = NSAttributedString(string: text, attributes: attributes)
            attributedText.draw(in: frame)
        }
    }
}

extension CGContext {
    func draw(_ diagram: Diagram, in bounds: CGRect) {
    switch diagram {
    case let .primitive(size, primitive):
        let bounds = size.fit(into: bounds, alignment: .center)
        draw(primitive, in: bounds)
    case .align(let alignment, let diagram):
        let bounds = diagram.size.fit(into: bounds, alignment: alignment)
        draw(diagram, in: bounds)
    case let .beside(left, right):
        let (lBounds, rBounds) = bounds.split(
        ratio: left.size.width/diagram.size.width, edge: .minXEdge)
        draw(left, in: lBounds)
        draw(right, in: rBounds)
    case .below(let top, let bottom):
        let (tBounds, bBounds) = bounds.split(
        ratio: top.size.height/diagram.size.height, edge: .minYEdge)
        draw(top, in: tBounds)
        draw(bottom, in: bBounds)
    case let .attributed(.fillColor(color), diagram):
        saveGState()
        color.set()
        draw(diagram, in: bounds)
        restoreGState()
        }
    }
}
```

## 第十节 案例研究：图表（略）

## 第十一节 迭代器和序列

```
在本章中，我们将关注点放在了迭代器 (Iterators) 和序列 (Sequences) 上，正是它们，组成了 Swift 中 for 循环的基础体系。

迭代器
在 Objective-C 和 Swift 中，我们常常使用数据类型 Array 来表示一组有序元素。虽然数组简单而又快捷，但总会有并不适合用数组来解决的场景出现。

从概念上来说，一个迭代器是每次根据请求生成数组新元素的过程。任何类型只要遵守以下协议，那么它就是一个迭代器：

protocol IteratorProtocol {
    associatedtype Element
    mutating func next() -> Element?
}
这个协议需要一个由 IteratorProtocol 定义的关联类型：Element，以及一个用于产生新元素的 next 方法，如果新元素存在就返回元素本身，反之则返回 nil。

迭代器为 Swift 另一个协议提供了基础类型，这个协议就是序列。迭代器提供了一个单次触发的机制以反复地计算出下一个元素。这种机制不支持返查或重新生成已经生成过的元素，我们想要做到这个的话就只能再创建一个新的迭代器。协议 SequenceType 则为这些功能提供了一组合适的接口：

protocol Sequence {
associatedtype Iterator: IteratorProtocol
    func makeIterator() -> Iterator
    // ...
}

注意协议 Sequence 本身无法确保一个序列在被消费时是否会被破坏。

每一个序列都有一个关联的迭代器类型和一个创建新迭代器的方法。我们可以据此使用该迭代器来遍历序列。

命令式版本还是有一个好处的：执行起来更快。它只对序列进行了一次迭代，并且将过滤和映射合并为一步。同时，数组 result 也只被创建了一次。在函数式版本中，不止序列被迭代了两次（过滤与映射各一次），还生成了一个过渡数组用于将 filter 的结果传递至 map 操作。

let lazyResult = (1...10).lazy.filter { $0 % 3 == 0 }.map { $0 * $0 }

在将多个方法同时进行链接时，使用 lazy 来合并所有的循环，就可以写出一段性能足以媲美命令式版本的代码了。

通常而言，一个解析器会接收一组字符 (一个字符串) 作为输入，如果解析成功，则返回一些结果值与剩下的字符串。如果解析失败，则什么也不返回。我们可以将整个过程总结为一个像下面这样的函数类型：

typealias Parser<Result> = (String) -> (Result, String)?

解析器并不只是用于解析字符，它应当能解析任何被传入的符号序列。

顺便一提，手动编写每一个柯里化函数是可能是一件有点枯燥的事。所以，我们也可以定义一个函数，curry，用于将参数个数确定的非柯里化函数转化为柯里化版本。比如，对于双参函数来说，curry 可以这样定义：

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) } }
}

，inout 的作用效果与 Objective-C 中将对某个值的引用进行传递是不同的。我们仍旧可以将该参数当做其它简单的值一样进行操作，区别在于，这个值会在函数返回的同时被复制回去。因此，在使用 inout 时并不会产生危及全局的副作用，因为可变性被严格限制在某个特定的变量上了。
```

## 第十二节 案例研究：解析器组合算子（略）

## 第十三节 案例研究：构建一个表格应用（略）

## 第十四节 函子、适用函子与单子

```
函子 (Functor)、适用函子 (Applicative Functor) 和单子 (Monad) 

理解这些常见的模式，会有助于你设计自己的数据类型，并为你的 API 选择更合适的函数。

每个 map 方法都需要两个参数：一个即将被映射的数据结构，和一个类型为 (T) -> U 的函数 transform。对于数组或可选值参数中所有类型为 T 的值，map 方法会使用 transform 将它们转换为 U。这种支持 map 运算的类型构造体 —— 比如可选值或数组 —— 有时候也被称作函子 (Functor)。

对于任意的类型构造体，如果我们可以为其定义恰当的 pure 与 <*> 运算，我们就可以将其称之为一个适用函子 (Applicative Functor)。或者再严谨一些，对任意一个函子 F，如果能支持以下运算，该函子就是一个适用函子：

func pure<A>(_ value: A) -> F<A>
func <*><A, B>(f: F<A -> B>, x: F<A>) -> F<B>

虽然我们并没有为 Parser 定义 pure 运算，但你自己也可以很容易的实现它。实际上，适用函子一直隐藏在本书的各个角落中。

实际上，flatMap 是单子结构支持的两个函数之一。更通俗地说，如果一个类型构造体 F 定义了下面两个函数，它就是一个单子 (Monad)：

func pure<A>(_ value: A) -> F<A>
func flatMap<A, B>(x: F<A>)(_ f: (A) -> F<B>) -> F<B>
```

## 尾声

```
Swift 函数式程序所应该具有三种特性：模块化、对可变状态的谨慎处理，以及选择合适的类型。
```