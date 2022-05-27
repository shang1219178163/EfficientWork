# APP应用启动流程
	  
## 一. pre-main阶段
	
	1. 加载应用的可执行文件
	2. 加载动态链接库加载器dyld（dynamic loader）
	3. dyld递归加载应用所有依赖的dylib（dynamic library 动态链接库）
	
	耗时检测：
	Xcode中Edit scheme-> Run-> Auguments 将环境变量DYLD_PRINT_STATISTICS 设为1 ：
	
	优化：
	1. Load dylibs阶段：
	1）.分析所依赖的动态库
	2）.找到动态库的mach-o文件
	3）.打开文件
	4）.验证文件
	5）.在系统核心注册文件签名
	6）.对动态库的每一个segment调用mmap()
	
	减少dylib的使用个数，合并已有的dylib和使用静态库（static archives）
	
	2. Rebase/Bind阶段：
	Rebase在前，Bind在后，Rebase做的是将镜像读入内存，修正镜像内部的指针，性能消耗主要在IO。
	Bind做的是查询符号表，设置指向镜像外部的指针，性能消耗主要在CPU计算。
	指针数量越少越好
	1）.减少ObjC类（class）、方法（selector）、分类（category）的数量
	2）.减少C++虚函数的的数量（创建虚函数表有开销）
	3）.使用Swift structs（内部做了优化，符号数量更少）
	
	3. Objc setup阶段：
	这一步dyld会注册所有声明过的ObjC类，将分类插入到类的方法列表里，再检查每个selector的唯一性。
	
	4. Initializers阶段：
	这一步dyld开始运行程序的初始化函数，调用每个Objc类和分类的+load方法，调用C/C++ 中的构造器函数（用__attribute__((constructor))修饰的函数），
	和创建非基本类型的C++静态全局变量。Initializers阶段执行完后，dyld开始调用main()函数。
	
	在这一步，我们可以做的优化有：
	1）.少在类的+load方法里做事情，尽量把这些事情推迟到+initiailize
	2）.减少构造器函数个数，在构造器函数里少做些事情
	3）.减少C++静态全局变量的个数
	
	            
## 二. main()阶段
	
	1. dyld调用main()
	2. 调用UIApplicationMain()
	3. 调用applicationWillFinishLaunching
	4. 调用didFinishLaunchingWithOptions
	
	耗时检测：
	测量main()函数开始执行到didFinishLaunchingWithOptions执行结束的耗时，需要自己实现：
	先在main()函数里用变量StartTime记录当前时间：
	
	CFAbsoluteTime StartTime;
	int main(int argc, char * argv[]) {
	      StartTime = CFAbsoluteTimeGetCurrent();
	
	再在AppDelegate.m文件中用extern声明全局变量StartTime
	extern CFAbsoluteTime StartTime;
	最后在didFinishLaunchingWithOptions里，再获取一下当前时间，与StartTime的差值即是main()阶段运行耗时。
	double launchTime = (CFAbsoluteTimeGetCurrent() - StartTime);
	
	优化：
	1）.梳理各个二方/三方库，找到可以延迟加载的库，做延迟加载处理，比如放到首页控制器的viewDidAppear方法里。
	2）.梳理业务逻辑，把可以延迟执行的逻辑，做延迟执行处理。比如检查新版本、注册推送通知等逻辑。
	3）.避免复杂/多余的计算。
	4）.避免在首页控制器的viewDidLoad和viewWillAppear做太多事情，这2个方法执行完，首页控制器才能显示, 尽量懒加载处理。
	5）.采用性能更好的API。
	6）.首页控制器用纯代码方式来构建。
	 
	补充：
	动态链接库包括:iOS 中用到的所有系统 framework，加载OC runtime方法的libobjc，系统级别的libSystem，
	例如libdispatch(GCD) 和libsystem_blocks (Block)。
	系统的动态链接库和App本身的可执行文件，他们都算是image(镜像)，而每个App都是以image(镜像)为单位进行加载的，那么image究竟包括哪些呢?
	
	image包含哪些？
	1.executable可执行文件 比如.o文件。
	2.dylib 动态链接库 framework就是动态链接库和相应资源包含在一起的一个文件夹结构。
	3.bundle 资源文件 只能用dlopen加载，不推荐使用这种方式加载。
	除了我们App本身的可行性文件，系统中所有的framework比如UIKit、Foundation等都是以动态链接库的方式集成进App中的。
	
	系统使用动态链接好处：
	代码共用:很多程序都动态链接了这些 lib，但它们在内存和磁盘中中只有一份。
	易于维护:由于被依赖的 lib 是程序执行时才链接的，所以这些 lib 很容易做更新，比如libSystem.dylib 是 libSystem.B.dylib 的替身，
	哪天想升级直接换成libSystem.C.dylib 然后再替换替身就行了。
	减少可执行文件体积:相比静态链接，动态链接在编译时不需要打进去，所以可执行文件的体积要小很多。
	
	ImageLoader
	image 表示一个二进制文件(可执行文件或 so 文件)，里面是被编译过的符号、代码等，ImageLoader作用是将这些文件加载进内存，且每一个文件对应一个ImageLoader实例来负责加载。
	两步走:
	在程序运行时它先将动态链接的 image 递归加载 (也就是上面测试栈中一串的递归调用的时刻)。
	再从可执行文件 image 递归加载所有符号。
	
	
	            
	总结：
	轻（类库：轻量级的解决方案）；
	少（过期代码在当前工程删除）；
	主（视图相关优先处理）；
	次（可以懒加载的尽量懒加载，同时考虑是否可以在非主线程执行）；
	异（启动时的网络请求，尽量统一在异步线程请求）；
	