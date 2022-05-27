### 第1条:  了解Objective-C语言的起源
```
//Messaging  (objective-C)
object *obj =  [object new];
 [obj performWith: parameter1 and: parameter2];

// Function calling  (C++)
object *obj = new object;
obj-&gt; perform(parameter1, pa rameter2)

关键区别在于：使用消息结构的语言，其运行时所应执行的代码由运行环境来决定；而使用函数调用的语言，则由编译器决定。
如果范例代码中调用的函数是多态的，那么在运行时就要按照’虚方法表‘（virtual table）日来查出到底应该执行哪个函数实现。
而采用消息结构的语言，不论是否多态，总是在运行时才会去查找所要执行的方法。实际上，编译器甚至不关心接收消息的对象是何种类型。
接收消息的对象问题也要在运行时处理，其过程叫做“动态绑定“ (dynamic binding）
```
### 第2条: 在类的头文件中尽量少引入其他头文件
```
除非确有必要，否则不要引人头文件。一般来说，应在某个类的头文件中使用向前声明(@class)来提及别的类，
并在实现文件中引人那些类的头文件。这样做可以尽量降低类之间的耦合。
```
### 第3条: 多用字面量语法,少用与之等价的方法
```
字面量语法有个小小的限制，就是除了字符串以外，所创建出来的对象必须属于 Foundation 框架才行。如果自定义了这些类的子类，
则无法用字面量语法创建其对象。
使用字面量语法创建出来的字符串、数组、字典对象都是不可变的（immutabl）。
```
### 第4条: 多用类型常量,少用#define预处理指令
```
Static const NSTimeInterval kAnimationDuration = 0.3;
常用的命名法是：若常量局限于某'编译单元'（也就是'实现文件'，implementation file）之内，则在前面加字母 k；若常量在类之外可见，则通常以类名为前缀。
有时候需要对外公开某个常量。此类常量需放在'全局符号表'（global symbol table）中应该这样来定义：

// EOCAnimatedView. H
extern NSString *const EOCStringConstant;
extern const NSTimeInterval EOCAn imatedViewAnimationDuration;

// EOCAnimatedView. M
NSString *const EOCStringConstant = @'VALUE';
const NSTimeInterval EOCAnimatedViewAnimationDuration = 0.3;
这样定义常量要优于使用#define 预处理指令，因为编译器会确保常量值不变。
```
### 第5条: 用枚举表示状态、选项、状态码
```
凡是需要以按位或操作来组合的枚举都应使用 NS_ OPTIONS 定义。若是枚举不需要互相组合，则应使用 NS_ ENUM 来定义。
```
### 第6条: 理解“属性”这一概念
```
编译器会把'点语法'转换为对存取方法的调用，使用'点语法'的效果与直接调用存取方法相同。两者等效。
@synthesize 语法来指定实例变量的 @name = _myFirstName
@dynamic 关键字，它会告诉编译器：不要自动创建实现属性所用的实例变量，也不要为其创建存取方法。这些方法能在运行期找到。
@dynamic firs tName, las tName;
```
### 第7条: 在对象内部尽量直接访问实例变量
```
建议大家在读取实例变量的时候采用直接访问的形式，而在设置实例变量的时候通过属性来做（内存管理语义执行）。
```
### 第8条: 理解“对象等同性”这概念
```
按照==操作符比较的是两个指针本身，而不是其所指的对象。应该使用 NSObject 协议中声明的'isEqual'：方法来判断两个对象的等同性(请提供'isEqual：'与 hash 方法)。
-  (BOOL) isEqual:  (id) object {
 if  (self == object) return YES;
 if  (lself class]! =  [object class]) return NO;
 EOCPerson *otherPerson =  (EOCPerson*) object;
 if  (!  [firstName isEqualToString: otherPerson. FirstName])
  return NO;
 if  (! [_ lastName isEqua lToString: otherPerson. LastName])
  re turn NO;
 if  (_ age! = otherPerson. Age)
 return NO;
}
-  (NSUInteger) hash {
 NSUInteger firstNameHash =  [_ firstName hash]; NSUInteger las tNameHash =  [_  lastName hash]; NSUInteger ageHash =_ age;
 return firstNameHash ^ las tNameHash ^ ageHash;
}
//特定类所具有的等同性判定方法
-  (BOOL) isEqualToPerson:  (EOCPerson*) otherPerson {
 if  (self == object) return YES;
 if  (! [_ firstName isEqualToStr ing: otherPerson. Firs tName])
  return NO;
 if  (! [_ lastName isEqualToStr ing: otherPerson. LastName])
  return NO;
 if  (_ age! = otherPerson. Age)
  return NO;
 return YES;
}
-  (BOOL) isEqual:  (id) object {
 if  (lself class] == lobject class]) {
  return  [self isEqualToPerson:  (EoCPerson*) object];
 } else {
  return  [super isEqual: object];
 }
}
```
### 第9条: 以“类族模式,隐藏实现细节
```
+  (EOCEmployee*) employeeWithType:  (EOCEmployeeType) type {
 switch  (type) {
  case EOCEmployeeTypeDeveloper:
   return  [EOCEmployeeDeveloper new];
  break;
  case EOCEmployeeTypeDes igner:
   return  [EOCEmployeeDesigner new];
  break;
  case EOCEmployeeTypeF inance:
   return  [EOCEmployeeFinance new];
  break;
}
-  (void) doADaysWork {
 // Subclasses implement this.
 }
```
### 第10条:  在既有类中使用关联对象存放自定义数据
```
在设置关联对象值时，若想令两个键匹配到同一个值，则二者必须是完全相同的指针才行。在设置关联对象值时，通常使用静态全局变量做键（每次运行时的值相等即可）。
```
### 第11条:  理解objc-msgSend的作用
```
Objc_msgSend 函数会依据接收者与选择子的类型来调用适当的方法。为了完成此操作，该方法需要在接收者所属的类中搜寻其'方法列表'（list of methods），
如果能找到与选择子名称相符的方法，就跳至其实现代码。若是找不到，那就沿着继承体系继续向上查找，等找到合适的方法之后再跳转。如果最终还是找不到相符的方法，
那就执行'消息转发'（message forwarding）操作。
```
### 第12条:  理解消息转发机制
```
动态方法解析：对象在收到无法解读的消息后，首先将调用其所属类的下列类方法：
+  (BOOL) resolveInstanceMethod:  (SEL) selector
备援接收者：运行期系统会问它：能不能把这条消息转给其他接收者来处理。与该步骤对应的处理方法如下：
-  (id) forwardingTargetForSelector:  (SEL) selector
完整的消息转发

这一步就是启用完整的消息转发机制了。首先创建 NSInvocation 对象，把与尚未处理的那条消息有关的全部细节都封于其中。
此对象包含选择子、目标（target）及参数。在触发 NSInvocation 对象时，'消息派发系统'（message- dispatch system）将亲自出马，把消息指派给目标对象。
此步骤会调用下列方法来转发消息：
-  (void) forwardInvocation:  (NSInvocation*) invocation

这个方法可以实现得很简单：只需改变调用目标，使消息在新目标上得以调用即可。然而这样实现出来的方法与'备援接收者'方案所实现的方法等效，
所以很少有人采用这么简单的实现方式。比较有用的实现方式为：在触发消息前，先以某种方式改变消息内容，比如追加另外- - 个参数，或是改换选择子，等等。
实现此方法时，若发现某调用操作不应由本类处理，则需调用超类的同名方法。这样的话，继承体系中的每个类都有机会处理此调用请求，直至 NSObject。
如果最后调用了 NSobjcct 类的方法，那么该方法还会继而调用'doesNotRecognizeSelector:'以抛出异常，此异常表明选择子最终未能得到处理。
```
### 第13条:  用“方法调配技术”调试 “黑盒方法
```
在运行期，可以向类中新增或替换选择子所对应的方法实现。
```
### 第14条:  理解“类对象”的用意
```
Typedef struct obic class *Class;
struct obic class {
 Class isa
 Class super class;
 const char *name:
 long version;
 long info;
 long instance size;
 struct objc ivar list ivars;
 struct objc method list **methodists
 struct obic cache *cache;
 struct objc protocol list *protocols:
};
```
### 第15条:  用前缀避免命名空间冲突"
### 第16条:  提供“全能初始化方法”
```
一个源方法，其他初始化方法调用它
```
### 第17条:  实现description方法

### 第18条:  尽量使用不可变对象
```
若某属性仅可于对象内部修改，则在'class-continuation 分类'中将其由 readonly 属性扩展为 readwrite 属性。
```
### 第19条:  使用清晰而协调的命名方式

### 第20条:  为私有方法名加前缀
```
-(void) p_privateMethod{}
```
### 第21条:  理解Objective-C错误模型
```
@throw  [NSException exceptionWithName: name  reason: reason userInfo: nil];
NSError 对象里封装了三条信息：
Error domain（错误范围，其类型为字符串）
错误发生的范围。也就是产生错误的根源，通常用一- 个特有的全局变量来定义。比方说，'处理 URL 的子系统'（URL-handling subsystem）在从 URL 中解析或取得数据时如果出错了，那么就会使用 NSURLErrorDomain 来表示错误范围。
Error code（错误码，其类型为整数）
独有的错误代码，用以指明在某个范围内具体发生了何种错误。某个特定范围内可能会发生一系列相关错误，这些错误情况通常采用 enum 来定义。例如，当 HTTP 请求出错时，可能会把 HTTP 状态码设为错误码。
User info（用户信息，其类型为字典）
有关此错误的额外信息，其中或许包含- -段'本地化的描述'（localized description），或许还含有导致该错误发生的另外-一个错误，经由此种信息，可将相关错误串成- - 条'错误链'（chain of errors）。
```
### 第22条:  理解NSCopying协议
```
-(id) copyWithZone:  (NSZone*) zone
Copy 方法由 NSObject 实现，该方法只是以'默认区'为参数来调用'copyWithZone:'。我们总是想覆写 copy 方法，其实真正需要实现的却是'copyWithZone：'方法。
-  (id) copyWithZone:  (NSZone*) zone {
    EOCPerson *copy =  [[[self class] allocWithZone: zone] initWithFirstName: _ firstName
andLastName: _ lastName];
    return copy;
}
```
### 第23条:  通过委托与数据源协议进行对象间通信
### 第24条:  将类的实现代码外散到便于管理的数个分类之中
### 第25条:  总是为第三方类的分类名称加前缀
### 第26条:  勿在分类中声明属性
### 第27条:  使用”class-continuation分类”,隐藏实现细节

```
若想使类所遵循的协议不为人所知，则可于'class-continuation 分类'中声明。
```
### 第28条:  通过协议提供匿名对象
### 第29条:  理解引用计数
### 第30条:  以ARC简化引用计数
```
ARC 只负责管理 Objective-C 对象的内存。尤其要注意：CoreFoundation 对象不归 ARC管理，开发者必须适时调用CFRetain/CFRelease。
```
### 第31条:  在dealloc方法中只释放引用并解除监听
```
如果对象持有文件描述符等系统资源，那么应该专门编写一个方法来释放此种资源。这样的类要和其使用者约定：用完资源后必须调用 close 方法。
```
### 第32条:  编写“异常安全代码”时留意内存管理问题
```
@try {
    object =  [[EOCSomeClass alloc] init];  [object doSomethingTha tMayThrow];
}
@catch  (...) {
    NSLog  (@ 'Whoops, there was an error. Oh well... '); }
@final1 y {
    [object release];
}
```
### 第33条:  以弱引用避免保留环
    
### 第34条:  以“自动释放池块”降低内存峰值
```
自动释放池排布在栈中，对象收到 autorelease 消息后，系统将其放人最顶端的池里。
@autoreleasepool {
    //…
}
```
### 第35条:  用“僵尸对象”调试内存
    
### 第36条:  不要使用retainCount(arc废弃)
    
### 第37条:  理解“块”这一概念
```
多线程编程的核心就是'块'（block）与'大中枢派发'（Grand Central Dispatch, GCD）。这虽然是两种不同的技术，但它们是一并引人的。'块'是一种可在 C、C++及 Objective-C 代码中使用的'词法闭包'（lexical closure），它极为有用，这主要是因为借由此机制，开发者可将代码像对象-'样传递，令其在不同环境（context）下运行。还有个关键的地方是，在定义'块'的范围内，它可以访问到其中的全部变量。
    
GCD 是一种与块有关的技术，它提供了对线程的抽象，而这种抽象则基于'派发队列'（dispatch queue)。开发者可将块排人队列中，由GCD 负贵处理所有调度事宜。GCD会根据系统资源情况，适时地创建、复用、摧毁后台线程（background thread），以便处理每个队列。此外，使用 GCD 还可以方便地完成常见编程任务，比如编写'只执行-次的线程安全代码'（thread-safe single-code execution），或者根据可用的系统资源来并发执行多个操作。
    
始块的强大之处是：在声明它的范围里，所有变量都可以为其所捕获。这也就是说，那个范围里的全部变量，在块里依然可用。默认情况下，为块所捕获的变量，是不可以在块里修改的。不过，声明基础数据类型变量的时候可以加上__block 修饰符，这样就可以在块内修改了。
self 也是个对象，因而块在捕获它时也会将其保留。如果 self 所指代的那个对象同时也保留了块，那么这种情况通常就会导致'保留环'。
    
块是 C、C++、Objective-C 中的词法闭包。块可接受参数，也可返回值。
块可以分配在栈或堆上，也可以是全局的。栈上的块拷贝到堆里，就和标准的 Objective-C 对象一样，具备引用计数了。
```
### 第38条:  为常用的块类型创建typedef
```
typedef int(^EOCSomeBlock)(BOOL flag, int value);
```
### 第39条:  用handler块降低代码分散程度
```
建议使用同一个块来处理成功与失败情况，苹果公司似乎也是这样设计其 API 的。
例如，Twitter 框架中的 TWRequest 及 MapKit 框架中的 MKLocalSearch 都只使用 -一个 handler 块。
```
### 第40条:  用块引用其所属对象时不要出现保留环


### 第41条:  多用派发队列,少用同步锁
```
同步锁:@synchronized(self)
    
_syncQueue = dispatch_ queue_ create  ('com. Effectiveobj ectivec. SyncQueue', NULL);
-  (NSString*) someString {
    __block NSString *local SomeString;
    dispatch_ sync (_ syncQueue, ^{
        localSomeString =_ someString;
    });
    return local SomeString;
}
-  (void) setSomeString:  (NSString*) someString {
    dispatch_barrier_async(_syncQueue,, ^{
        _someString = someString;
    });
}
```
### 第42条:  多用GCD,少用performSelector系列方法
```
Objective-C 本质上是一门非常动态的语言, NSObject 定义了几个方法，令开发者可以随意调用任何方法。
1： performselector 系列方法在内存管理方面容易有硫失。它无法确定将要执行的选择子
具体是什么，因而 ARC 编译器也就无法插入适当的内存管理方法。
2：performselector 系列方法所能处理的选择子太过局限了，选择子的返回值类型及发送给方法的参数个数都受到限制
3：如果想把任务放在另一个线程上执行，那么最好不要用 perform Selector 系列方法，而是应该把任务封装到块里，然后调用大中枢派发机制的相关方法来实现
```
### 第43条:  掌握GCD及操作队列的使用时机
```
在解决多线程与任务管理问题时，派发队列并非唯一方案。
操作队列提供了一套高层的 Objective-c API，能实现纯 GCD 所具备的绝大部分功能而且还能完成一些更为复杂的操作，那些操作若改用 GCD 来实现，则需另外编写代码。
```
### 第44条:  通过Dispatch Group机制,根据系统资源状况来执行任务
```
系列任务可归人一个 dispatchgroup 之中。开发者可以在这组任务执行完毕时获得通知。
通过 dispatch group，可以在并发式派发队列里同时执行多项任务。此时 GCD 会根据系统资源状况来调度这些并发执行的任务。开发者若自已来实现此功能，则需编写大量代码。
```
### 第45条:  使用dispatch once来执行只需运行一次的线程安全代码
    
### 第46条:  不要使用dispatch-get. current_queue
```
Dispatch_ get current queue 函数的行为常常与开发者所预期的不同。此函数已经废弃，只应做调试之用。
```
### 第47条:  熟悉系统框架"
### 第48条:  多用块枚举,少用for循环
### 第49条:  对自定义其内存管理语义的collection使用无缝桥接
```
__ bridge 本身的意思是：ARC 仍然具备这个 Objective-C 对象的所有权。
__ bridge_ retained 则与之相反，意味着 ARC 将交出对象的所有权。与之相似，反向转换可通过__ bridge_ transfer 来实现。
比方说，想把 CFArrayRef 转换为 NSArray*，并且想令 ARC 获得对象所有权，那么就可以采用此种转换方式。这三种转换方式称为'桥式转换'（bridgedcast）。
```
### 第50条:  构建缓存时选用NSCache而非NSDictionary
```
NSCache 胜过 NSDictionary 之处在于，当系统资源将要耗尽时，它可以自动删减缓存。如果采用普通的字典，那么就要自己编写挂钩，在系统发出'低内存'（low memory）通知时手工删减缓存。
此外，NSCache 还会先行删减'最久未使用的'（lease recently used）对象。若想自已编写代码来为字典添加此功能，则会十分复杂。
NSCache 并不会'拷贝'键，而是会'保留'它。此行为用 NSDictionary 也可以实现，然而需要编写相当复杂的代码。NSCache 对象不拷贝键的原因在于：很多时候，键都是由不支持拷贝操作的对象来充当的。
另外，NSCache 是线程安全的,在开发者自己不编写加锁代码的前提下，多个线程便可以同时访问 NSCache。
```
### 第51条:  精简initialize与load的实现代码
```
想执行与类相关的初始化操作，就是覆写方法：+  (void) initialize
对于每个类来说，该方法会在程序首次用该类之前调用，且只调用-次。它是由运行期系统来调用的，绝不应该通过代码直接调用。
其虽与 load 相似，但却有几个非常重要的区别。首先，它是'惰性调用的'，只有当程序用到了相关的类时，才会调用。如果某个类一直都没有使用，那么其 initialize 方法就-直不会运行。
对于 load 来说，应用程序必须阻塞并等着所有类的 load 都执行完，才能继续。
    
还有个区别，就是运行期系统在执行该方法时，是处于正常状态的，因此，从运行期系统完整度上来讲，此时可以安全使用并调用任意类中的任意方法。而且，运行期系统也能确保 initialize 方法
一定会在'线程安全的环境'（thread-safe environment）中执行，这就是说，只有执行 initialize 的那个线程可以操作类或类实例。其他线程都要先阻塞，等着 initialize 执行完。
    
最后一个区别是：initialize 方法与其他消息一-样，如果某个类未实现它，而其超类实现了，那么就会运行超类的实现代码。这听起来并不稀奇，但却经常为开发者所忽视。比方说有下面这两个类：
    
```
### 第52条:  别忘了NSTimer会保留其目标对象
```
//NSTimer 分类
+ (NSTimer *)scheduledTimer:(NSTimeInterval)interval
                      block:(void(^)(NSTimer *timer))block
                    repeats:(BOOL)repeats{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(handleInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)handleInvoke:(NSTimer *)timer {
    void(^block)(NSTimer *timer) = timer.userInfo;
    if(block) {
        block(timer);
    }
}                                                        
```
