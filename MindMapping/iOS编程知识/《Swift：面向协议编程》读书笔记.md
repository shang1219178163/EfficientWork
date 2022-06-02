# Swift：面向协议编程

那么面向协议编程到底是什么呢？一句话就能概括：用协议扩展的方式代替继承，实现代码复用。
所以从内存的角度来看，面向协议编程正朝着面向栈内存编程的方向前进。

### 第2章 Swift基础语法
```
1. Swift中的字母采用的是Unicode编码，Unicode的中文翻译是统一编码制，其中不仅有英文，还有亚洲文字，甚至我们常用的表情也在Unicode编码之中，所以如果你够任性，甚至可以使用一个笑脸来作为变量名。

2. 声明一个可选型虽然可以通过编译器设置的安全性检查，但是如果你不慎忘记在之后对其赋值，那么在解包的时候程序就会崩溃。

3. 相比于强制解包，Swift提供了一种更安全的解包方式：可选绑定。可选绑定有两种格式可选：if-let和guard-let-else。首先来看if-let结构：

4. 所有标准C中的比较运算符在Swift中都可以使用。另外，在Swift中，==可以用在任何类型的比较中,而不用像OC中那样使用不同的isEqual方法.

5.  1…5表示闭区间[1,5]，也就是从1到5的范围。
　   1..<5表示半闭区间[1,5)，也就是从1到4。

6. Swift中，连接两个字符串组成新字符串非常方便，使用+即可

7. 方法的拥有者可能是类，也可能是结构体。方法的拥有者为方法提供了命名空间，所以在不同的类或者结构体中可以定义完全相同的方法。而没有拥有者的函数的作用域是全局的，除非重载，否则不能定义两个一模一样的方法。

8. Swift建议在命名函数（方法）时用时态来区分函数是否具有副作用。用sort方法举例，sort是一种常用的对数组排序的方法，sort是动词时态，代表这个方法没有副作用。也就是说，sort方法只会对方法的调用者起作用，是一种原地排序，所以原数组必须是变量：
    var mutableArr = [1,3,2]
    mutableArr.sort()

    let immutableArr = [1,3,2]//原数组可以是常量
    let mutableArr = immutableArr.sorted()//mutableArr的值为[1,2,3]

9. 三者都可以拥有属性和方法，枚举本身不能存储数据，但是可以将数据存储在枚举的关联信息中。

10. NSData很简单，它是一个比特包，不管大小它里面都是无类型的数据。

11. 计算属性可以用于类、结构和枚举里，存储属性只能用于类和结构体里。另外，如果通过方法修改结构体的属性，则需要使用关键字mutating声明方法为变异方法，比如如果下标没有set方法，则可以把get方法中的内容直接写到下标的方法体中，从而省略外面的get{}，这点类似于计算属性。

    let num:Int
        subscript(index: Int) -> Int{
           return num * index
        }
    struct  TimesOfNum{
        let num:Int
        let otherNum:Int

       subscript(index: Int) -> Int {
          return num * index
       }
       subscript(index1:Int,index2:Int)-> Int {
          return num * index1 + index2
       }
    }

12. 由于下标的定义中没有下标名（关键字subscript后面直接跟着参数列表），因此如果定义了多个下标，则在使用不同的下标时需要通过重载的方法，根据传入的参数数量或者类型，系统会自行判断应该调用哪一个下标。

13. 在Swift中一般使用is关键字实现类型检查，使用as关键字实现类型转换;类型检查操作符is可以用来检查一个实例是否属于特定子类型.与is关键字相比，使用as除了可以检查类型外，还可以访问子类的属性或者方法。通常为了使用转型成功的实例，搭配使用可选绑定。

14. 扩展就是给一个现存类、结构体、枚举或者协议添加新的属性或者方法的语法
但有些限制条件需要说明：
　不能添加一个已经存在的方法或者属性。
　添加的属性不能是存储属性，只能是计算属性。

扩展可以用来扩展现有类型的计算属性、构造器、方法和下标

15. 协议用于统一方法和属性的名称，但是协议没有实现，在其他语言中通常叫作接口。

一旦类遵守了这个协议，就必须实现它里面的所有成员，不然无法通过编译。结构体和枚举也是如此。

当两个方法都定义在协议扩展中，并且上下文为String时，methodForOverride会调用被重写的版本，而未被重写的方法methodWithoutOverride会调用协议扩展中默认的版本，并且未被重写的方法内部调用协议中其他方法时获得的也是没有被重写的版本，这就是协议扩展的静态特性

把那些希望被复写的方法定义在协议的方法列表中，把那些不希望被复写的方法的定义与实现统统放在协议扩展中。

协议扩展的优势是，你只需实现协议所暴露给你的底层的逻辑，就可以免费获得协议扩展中基于底层逻辑所实现的便利方法。协议的另一个优势是功能描述的粒度，协议的表意非常清晰，从协议的命名到协议中的方法。

    protocol SearchIntArrayMax {

    }

    extension SearchIntArrayMax where Self:CollectionType, Self.Generator.Element
== Int{
        func showMax() -> String{
            if let max = self.maxElement(){
                return "\(max)"
            }
            return "无最大值"
        }
    }

Element是使用节点声明的，它代表一个泛型，可以看到这里的泛型名是Element，相比上面的T、U、V，要长得多。这是因为此处的Element不仅仅是一个占位符的作用，它还声明了这个泛型代表数组中的元素类型，有具体的意义，这种API的设计原则值得我们借鉴.

有时候节点中的泛型需要有更多的限制，需要使用where子句来补充约束条件：

    func anyCommonElements<T : SequenceType, U : SequenceType where
        T.Generator.Element: Equatable,
        T.Generator.Element == U.Generator.Element>(lhs: T, _ rhs: U) -> Bool {
        ...
    }
```
## 第3章 Swift进阶语法
```
1. 可选型通常用在变量之中，可选型的默认值是nil。

2. 将必须执行的逻辑放在defer{}中，可以保证无论方法从哪个出口结束，defer{}中的代码都会执行，通常会将defer放在方法体的最上方。
    func track(code:String) throws{
        defer{
            print("一定执行")
        }
        guard let stuent =  example(code) else{
            throw TrackError.NoStudent
        }
        guard let age = stuent.age else{
            throw TrackError.NoAge
        }
        print("找到了年龄")
    }

defer代码段总是在方法生命周期的最后才执行的.

3. 可能还遇到过X!这样的类型，这种类型叫隐式解包。隐式解包是一种特殊的可选型，在系统中，由于一些历史原因会出现这样的类型，但是我们自己不要定义这样的类型。隐

可选型本身是一个枚举，即便它所保存的真实值是空值，在解包之前可选型依旧可以在程序中传递，而不会引起程序崩溃。另外，空值nil也是有价值的。

笔者的建议是在条件足够完备的时候，尽量不要定义一个可选型。

4. 对于Swift的集合数据来说，有同构和异构之分。如果你需要讨论一群鸟类或者一批飞机，那么这样的数据是同构的，比如包含鸟类的数组[Bird]和包含飞机的数组[Airplane]。有时你想要探讨的是这些空中家伙们的共性：飞翔，因此你的数据源可能同时包含Bird和Airplane，这样的数据源叫作异构数据。

Swift协议的一个重要作用就是构建异构数据，数组的定义是泛型的，当你把协议作为类型去初始化一个数组的时候，实际是为数组中的成员的泛型定义增加了一层协议的约束。

    protocol CanFly {
        func fly()
    }

    struct Bird:CanFly {
        var name = ""
        func fly() {
            print("鸟类在飞翔")
        }
    }

    struct Airplane:CanFly {
        var company = ""
        func fly() {
            print("飞机在飞行")
        }
    }

现在创建一个异构的数组：
 var flyArray:[CanFly] = [Bird(name:"麻雀"),Airplane(company:"中国东方航空")]

如果你只想确定异构的数据是某个类型的但是却不会用到数据本身，可以使用is关键字：

使用协议实现数据的异构除了功能划分更明确、粒度更小之外，还有一个好处是运行的效率要高于使用类的继承实现的数据异构。使用协议实现异构，这也是苹果官方推荐的写法。

5. @noescape关键字声明的闭包参数可以避免循环引用, 现为默认参数，不用手动添加。

6. 高阶函数
filter：用来过滤数组中的元素，返回数组中满足过滤条件的元素组成的新数组。
map：根据选定的逻辑对数组中的元素进行处理，返回加工后的元素组成的新数组。
flatMap：类似于map的功能，但是可以拆分组合数组嵌套的数组。
reduce：对数组中的元素按照某种规则进行合并，得到一个返回值。

sort：根据指定的规则对数组中的元素排序。
forEach：闭包风格的数组遍历。

7. 然而在Swift中，大部分词义比较抽象的名词都是协议，这些协议会有众多的遵守者。

8. 系统为我们提供了把中文转成拼音的API，把这个API封装成一个方法：
    func transform(chinese:String) -> String {
        let mutableStr = NSMutableString(string: chinese) as        CFMutableStringRef
        if CFStringTransform(mutableStr, nil, kCFStringTransformToLatin, false) &&
CFStringTransform(mutableStr,  nil,  kCFStringTransformStripCombiningMarks,
false){
            return mutableStr as String
        } else {
            return ""
        }
    }

as关键字需要被用来触发系统的桥接，我们自己定义的类型依旧需要使用as?和as!来转型。
9. class Singleton {
        static let sharedInstance = Singleton()
        privite init(){}
    }

sharedInstance属性所对应的Singleton实例是采用懒加载的方式加载的，并且是线程安全的，如此简便的写法是编译器的功劳。

10. 当闭包作为方法参数的时候，即便闭包中会持有self，也不会引起循环引用。

noescape的用法是为方法提供灵活的外部代码，并且noescape的闭包不会产生循环引用，noescape成为了闭包的默认状态。

方法是Swift中的一个重要概念，在了解了柯里化之后我觉得不需要过分区分方法和函数.

11. OC程序员应该不会对动态派发感到陌生，OC中的方法都是动态派发的，也就是我们常说的消息转发。Swift中的动态派发和OC中的动态派发类似，在运行时程序会根据被调用的方法的名字去内存中的方法表中查表，找到方法的实现并执行。静态派发是指在运行时调用方法不需要查表，直接跳转到方法的代码中执行。很明显静态派发是一种更加高效的方法，因为静态派发免去了查表操作。不过静态派发是有条件的，方法内部的代码必须对编译器透明，并且在运行时不能被更改，这样编译器才能帮助我们。静态派发为内联或者其他优化提供了支持，支持内联的方法要求方法本身必须是静态派发的。Swift中的值类型不能被继承，也就是说值类型的方法实现不能被修改或者复写，因此值类型中的方法满足静态派发的要求。不像[…]

内联是指在编译期把每一处方法调用替换为直接执行方法内部的代码

需要在运行时找到方法的具体实现的模式叫做动态派发。虽然动态派发的执行效率不如静态派发高，但是在很多情况下动态派发是合理的。比如异构数组中的方法调用使用的就是动态派发，这是因为静态派发的设计哲学与异构数组的设计初衷在本质上是互斥的。

当你需要静态多态时，使用泛型。

泛型特化具体来说就是：编译器会为每一个满足泛型要求的数据类型生成一个特化方法，编译期遇到泛型方法被调用时，会根据参数类型使用对应的特化方法进行替换，对于能进行内联优化的方法会继续优化，泛型特化之后，在运行时泛型方法已经不存在了。

因为flyable属性是内联的，所以Airplane会被直接存放在栈上，不会再开辟堆上的内存空间。

有时候泛型特化需要跨越不同的．swift文件，记得开启Xcode的Whole Module Optimization

使用模式匹配的一个必要条件是：重载~=操作符
```
## 第4章 iOS开发入门 （略）

## 第5章 面向协议编程
```

控制器中包含了视图和模型

Swift的方法会被转化成全局函数，然后进行柯里化，所以引入协议不会带来循环引用的风险

    override func drawRect(rect: CGRect) {
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
