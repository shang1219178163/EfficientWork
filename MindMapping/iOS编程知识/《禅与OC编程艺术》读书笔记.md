# 禅与OC编程艺术

### 条件语句体应该总是被大括号包围。尽管有时候你可以不使用大括号
### Error first
```
- (void)someMethod {
    if (![someOther boolValue]) {
        return;
    }

    //Do something important
}
```
### 复杂表达式
```
当你有一个复杂的 if 子句的时候，你应该把它们提取出来赋给一个 BOOL 变量，这样可以让逻辑更清楚.
```
### 三目运算符
```
result = object ? : [self createObject];
```
### Case语句
```
除非编译器强制要求，括号在case语句里面是不必要的。但是当一个case包含了多行语句的时候，需要加上括号。
```
### Constants 常量
```
常量应该以驼峰法命名，并以相关类名作为前缀。
```
### 方法
```
方法名与方法类型 (-/+ 符号)之间应该以空格间隔。方法段之间也应该以空格间隔（以符合 Apple 风格）。参数前应该总是有一个描述性的关键词。
```
### 字面量
```
使用字面值来创建不可变的 NSString, NSDictionary, NSArray, 和 NSNumber 对象。
```
### 类名
```
类名应该以三个大写字母作为前缀（双字母前缀为 Apple 的类预留）。
```
### Initializer 和 dealloc
```
推荐的代码组织方式是将 dealloc 方法放在实现文件的最前面（直接在 @synthesize 以及 @dynamic 之后），
init 跟在dealloc后面。如果有多个初始化方法， 指定初始化方法 (designated initializer)
应该放在最前面，间接初始化方法 (secondary initializer) 跟在后面，这样更有逻辑性。
```
### alloc 和 init
```
alloc 负责创建对象，这个过程包括分配足够的内存来保存对象，写入 isa 指针，初始化引用计数，以及重置所有实例变量。
init 负责初始化对象，这意味着使对象处于可用状态。这通常意味着为对象的实例变量赋予合理有用的值。
alloc 方法将返回一个有效的未初始化的对象实例。每一个对这个实例发送的消息会被转换成一次 objc_msgSend() 函数的调用，
形参 self 的实参是 alloc 返回的指针；这样 self 在所有方法的作用域内都能够被访问。
init 方法在被调用的时候可以通过重新给 self 重新赋值来返回另一个实例，而非调用的那个实例。例如类簇，
还有一些 Cocoa 类为相等的（不可变的）对象返回同一个实例。
```
### 类簇 （class cluster)
```
class cluster 的想法很简单: 使用信息进行(类的)初始化处理期间，会使用一个抽象类（通常作为初始化方法的参数或者判定环境的可用性参数）
来完成特定的逻辑或者实例化一个具体的子类。而这个'Public Facing（面向公众的）'类，必须非常清楚他的私有子类，以便在面对具体任务的时候
有能力返回一个恰当的私有子类实例。对调用者来说只需知道对象的各种API的作用即可。
这个模式的精妙的地方在于，调用者可以完全不管子类，事实上，这可以用在设计一个库，可以用来交换实际的返回的类，而不用去管相关的细节，
因为它们都遵从抽象超类的方法。我们的经验是使用类簇可以帮助移除很多条件语句。
```
### Designated Initializer
```
一个类应该有且只有一个 designated 初始化方法，其他的初始化方法应该调用这个 designated 的初始化方法（虽然这个情况有一个例外）
instancetype允许编译器进行类型检查。（发送到 alloc 或者 init 方法的消息会有同样的静态类型检查是否为接受类的实例。）
一个相关的返回类型可以明确地规定用 instancetype 关键字作为返回类型，并且它可以在一些工厂方法或者构造器方法的场景下很有用。
它可以提示编译器正确地检查类型，并且更加重要的是，这同时适用于它的子类。
id 可以被编译器提升到instancetype 。alloc或init 中，我们强烈建议对所有返回类的实例的类方法和实例方法使用instancetype 类型。
```
### 单例
```
+ (instancetype)sharedInstance{
   static id sharedInstance = nil;
   static dispatch_once_t onceToken = 0;
   dispatch_once(&amp;onceToken, ^{
      sharedInstance = [[self alloc] init];
   });
   return sharedInstance;
}
```
### Init 和 Dealloc
```
永远不要在 init 方法（以及其他初始化方法）里面用 getter 和 setter 方法，你应当直接访问实例变量。这样做是为了防止有子类时，
出现这样的情况：它的子类最终重载了其 setter 或者 getter 方法，因此导致该子类去调用其他的方法、访问那些处于不稳定状态，
或者称为没有初始化完成的属性或者 ivar 。记住一个对象仅仅在 init 返回的时候，才会被认为是达到了初始化完成的状态。
```
### 可变对象
```
任何可以用来用一个可变的对象设置的（(比如 NSString,NSArray,NSURLRequest)）属性的的内存管理类型必须是 copy 的。
这是为了确保防止在不明确的情况下修改被封装好的对象的值。
```
### 相等性
```
当你要实现相等性的时候记住这个约定：你需要同时实现isEqual 和 hash方法。如果两个对象是被isEqual认为相等的，
它们的 hash 方法需要返回一样的值。但是如果 hash 返回一样的值，并不能确保他们相等。

一个完整的 isEqual 方法应该是这样的：
```
### 美化代码
```
推荐:
if (user.isHappy) {
    //Do something
}
else {
    //Do something else
}
[UIView animateWithDuration:1.0
                 animations:^{
                     // something
                 }
                 completion:^(BOOL finished) {
                     // something
                 }];
```
### 利用代码块
```
代码块如果在闭合的圆括号内的话，会返回最后语句的值，可以减少对其他作用域的命名污染。


```
### Pragma Mark
```
#pragma mark - 是一个在类内部组织代码并且帮助你分组方法实现的好办法。

- (void)dealloc;
- (instancetype)init;

#pragma mark - View Lifecycle （View 的生命周期）

- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;

#pragma mark - Custom Accessors （自定义访问器）

- (void)setCustomProperty:(id)value;
- (id)customProperty;

“#pragma mark - Public

- (void)publicMethod;

#pragma mark - Private

- (void)zoc_privateMethod;

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - ZOCSuperclass

// ... 重载来自 ZOCSuperclass 的方法

#pragma mark - NSObject

- (NSString *)description;
```
### 忽略警告
```
如果你知道你的代码不会导致内存泄露，你可以通过加入这些代码忽略这些警告

#pragma clang diagnostic push
#pragma clang diagnostic ignored '-Warc-performSelector-leaks'

[myObj performSelector:mySelector withObject:name];

#pragma clang diagnostic pop
```
### 明确编译器警告和错误
```
编译器是一个机器人，它会标记你代码中被 Clang 规则定义为错误的地方。
#error Whoa, buddy, you need to check for zero here!
#warning Dude, don't compare floating point numbers like this!
```
### Block 是OC版本的lambda/closure（闭包）
```
block 是在栈上创建的”
block 可以复制到堆上
Block会捕获栈上的变量(或指针)，将其复制为自己私有的const(变量)。
(如果在Block中修改Block块外的)栈上的变量和指针，那么这些变量和指针必须用__block关键字申明(译者注：
  否则就会跟上面的情况一样只是捕获他们的瞬时值)。
当block 被复制后，__block 声明的栈变量的引用被复制到了堆里，复制完成之后，无论是栈上的block还是
刚刚产生在堆上的block(栈上block的副本)都会引用该变量在堆上的副本。
```
### 委托/数据源模式
```
委托模式(delegate pattern)：事件发生的时候，委托者需要通知代理者。对象之间耦合较松，
发送方仅需知道它的代理方是否遵守相关 protocol 即可。
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

数据源模式(datasource pattern): 委托者需要从数据源对象拉取数据。委托者 ==Data==&gt; 代理者。
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
```
### 面向切面编程
```
Aspect Oriented Programming (AOP，面向切面编程) 在 Objective-C 社区内没有那么有名，但是 AOP 在运行时可以有巨大威力。
在 Objective-C 的世界里，这意味着使用运行时的特性来为指定的方法追加 切面 。切面所附加的行为可以是这样的：

在类的特定方法调用前运行特定的代码
在类的特定方法调用后运行特定的代码
增加代码来替代原来的类的方法的实现

Aspects 完美地适配了 AOP 的思路。
```
