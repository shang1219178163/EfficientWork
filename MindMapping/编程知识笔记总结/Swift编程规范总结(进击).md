
#Swift编程规范(进击第二步)

* self推断,请避免使用 self 关键词
```
	•	在 init 中设置参数时显性地使用 self 。
	•	在 non-escaping closures 中显性地使用 self 。
	•	在避免命名冲突时使用 self 。 例：
class BoardLocation  {
    let row: Int, column: Int
    init(row: Int, column: Int)  {
        self.row = row
        self.column = column
        let closure = {
            print(self.row)    
         }  
    }
}
```

* 对于可选绑定，适当时使用原始名称
```
var subview: UIView?
var volume: Double?
if let subview = subview, let volume = volume {
  // 使用展开的 subview 和 volume 做某件事
}
当用 guard 或 if let 解包多个可选值时，在可能的情况下使用最下化复合版本嵌套。举例：
推荐：
guard let number1 = number1,
      let number2 = number2,
      let number3 = number3 else {
  fatalError("impossible")
}
```

* 避免强制类型转换(force cast) as!

```
// Correct
NSNumber() as? Int

// Wrong
NSNumber() as! Int

// 建议写法
navigationController?.pushViewController(myViewController, animated: true)
		
// 不建议写法
navigationController!.pushViewController(myViewController, animated: true)

let url = NSURL(string: "http://www.baidu.com")!
print(url)

return cell!
```

* 内存管理(延长对象的生命周期)
```
使用惯用语法 [weak self] 和 guard let self = self else { return } 来延长对象的生命周期。 在 self 超出闭包生命周期不明显的地方，[weak self] 更优于 [unowned self]。 明确地延长生命周期优于可选解包。
推荐：
resource.request().onComplete { [weak self] response in
  guard let self = self else {
    return
  }
  let model = self.updateModel(response)
  self.updateUI(model)
}
不推荐：
// 如果在响应返回前 self 被释放，则可能导致崩溃
resource.request().onComplete { [unowned self] response in
  let model = self.updateModel(response)
  self.updateUI(model)
}
不推荐：
// 内存回收可以发生在更新模型和更新 UI 之间
resource.request().onComplete { [weak self] response in
  let model = self?.updateModel(response)
  self?.updateUI(model)
}
```

* 可以使用do/try/catch机制，避免使用try!和try?

```
// Correct
func a() throws {}; do { try a() } catch {}
// Wrong
func a() throws {}; try! a()
```

* 使用尾随闭包时，避免使用空的圆括号

```
// Correct
[1, 2].map { $0 + 1 }
[1, 2].map { number in
	number + 1 
}
let isEmpty = [1, 2].isEmpty()
UIView.animateWithDuration(0.3, animations: {
   self.disableInteractionRightView.alpha = 0
}, completion: { _ in
   ()
})

// Wrong
[1, 2].map() { $0 + 1 }

[1, 2].map( ) { $0 + 1 }
[1, 2].map() { number in
	number + 1 
}
[1, 2].map(  ) { number in
	number + 1 
}

```

* 委托(Delegate)协议应当为class类，可以被弱引用
```
protocol workSelectViewDelegate: class {
@objc protocol workSelectViewDelegate {
（oc类型的protocol只有class实现。）
```

* 委托(Delegate)协议中声明属性时，应该设置访问器的顺序为get set
```
// Correct
protocol Foo {
	var bar: String { get set }
}
```

* 单例 Swift 的 runtime 会保证单例的创建并且采用线程安全的方式访问：
```
class ControversyManager {
    static let sharedInstance = ControversyManager()
    private init() {}
}
```
* 尽量避免显式调用.init()
* 避免使用fallthrough

```
// Correct
switch foo {
case .bar, .bar2, .bar3:
    something()
}

// Wrong
switch foo {
case .bar:
    fallthrough
case .bar2:
    something()
}
```
* 尽量避免使用强制解包。

```
// 建议写法
navigationController?.pushViewController(myViewController, animated: true)
```

* 只读属性不使用get关键字

```
 var foo: Int {
     return 20 
  } 
```

* 用扩展只读属性 代替 单参数函数（不强制）

```
正确代码：
extension Int {
    var doubleValue: Double {
        return Double(self)
    }
}

//调用
intValue.doubleValue
错误代码：
func doubleValue(_ value: Int) -> Double {
    return Double(value)
}

//调用
doubleValue(intValue)
```
* 一般的类型参数应该是描述性的、大写驼峰法命名。当类名没有富有含义的关系或角色时，使用传统的单个大写字母来命名，例如 T 、 U 或 V。

* 协议遵循

```
推荐为协议方法加一个单独的扩展，尤其是为一个模型加入协议遵循的时候。这可以让有关联的协议方法被分组在一起，也可以简化用类关联方法向这个类添加协议的指令。

推荐：

class MyViewController: UIViewController {
  // 类填充在这
}

// MARK: - UITableViewDataSource
extension MyViewController: UITableViewDataSource {
  // table view 的数据源方法
}

// MARK: - UIScrollViewDelegate
extension MyViewController: UIScrollViewDelegate {
  // scroll view 的代理方法
}
```

* 无用代码
无用代码（僵尸代码），包括 Xcode 模板代码和占位注释，应该被移除掉。教程或书籍中教用户使用的注释代码除外。

* 函数声明返回Void是冗余的

* 在弃置函数结果时，优先使用_ = foo()而不是let _ = foo()
