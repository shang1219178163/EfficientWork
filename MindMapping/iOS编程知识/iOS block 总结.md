# block

在OC中block的类型分为三类：
1. _NSConcreteGlobalBlock 全局的静态 block，不会访问任何外部变量。
2. _NSConcreteStackBlock 保存在栈中的 block，当函数返回时会被销毁。
3. _NSConcreteMallocBlock 保存在堆中的 block，当引用计数为 0 时会被销毁。

以下说明几点需要注意的：
1. _NSConcreteGlobalBlock 是全局静态block，结构体存储在数据区。
2. 常见的是有捕获外部变量的_NSConcreteStackBlock，需要注意的是如果这种类型的block 定义在函数内部，当函数执行完毕，退栈的时候会将该block结构体所占的内存空间释放掉，这样再引用的话会报错。
3. _NSConcreteMallocBlock 通常不会在源码中直接出现，OC ARC下会对_NSConcreteStackBlock 进行优化，将其copy到堆上，转换成_NSConcreteMallocBlock，所以无特殊处理，OC中将只会有1，3两种类型block;
4. _NSConcreteStackBlock捕获的局部变量，如不加_block修饰符，将会把变量copy一份到其结构体中，所以才会在内部修改不影响外部变量，加_block修饰之后，结构体中会添加一个__Block_byref_i_0 的结构体，且复制的是变量地址，达到可以修改外部变量的效果。

在MRC环境下，__block根本不会对指针所指向的对象执行copy操作，而只是把指针进行的复制。
而在ARC环境下，对于声明为__block的外部对象，在block内部会进行retain，以至于在block环境内能安全的引用外部对象，所以要谨防循环引用的问题！

## 总结
1.block是一个封装了函数调用和函数调用环境的OC对象（因为其结构体的第一个成员是isa指针）。

2.block对auto变量的捕获是值传递，static变量是指针传递，全局变量不会进行捕获。

3.block有三种类型__NSGlobalBlock__ __NSStackBlock__ __NSMallocBlock__ 访问了外部变量的block存在于栈上，经过一次copy操作会将栈上的block拷贝到堆上，即：__NSStackBlock__变为__NSMallocBlock__，__NSGlobalBlock__copy什么也不做，__NSMallocBlock__引用计数加1。

4.mrc下不会自动进行copy，arc环境下在block作为返回值，被强指针引用，在cocoa api中作为usingblock的参数，作为gcd api的参数的时候回自动进行一次copy操作。

5.栈上block访问了对象类型的auto变量的时候不会对其发生强引用。

6.block从栈上copy到堆上的时候，block内部会执行copy操作，_Block_object_assign函数回通过auto变量的修饰符判断发生强弱引用。

7.block从堆中移除的时候，block内部会执行dispose，将引用的对象进行释放。

8.__block修饰的值，会在block内部生成一个对象，对象中存放了__block的地址，当修改这个值得时候block内部会找到这个对象（结构体，因为其第一个成员是isa）的__forwarding(指向其自身)然后在找到这个值得地址，直接修改地址中的存放值。

9.__block生成的对象的强弱引用也是通过_Block_object_assign函数对__block产生的变量产生强引用。从堆中移除的时候调用dispose释放对__block生成的变量的引用。

10.使用__weak修饰在block中访问变量解决循环引用的问题。

### 关于Retain Circle 有3种方式可以解决循环引用:
方法一：手动释放使用之后持有的指针，这样可以打破循环引用。
方法二：直接释放block。因为在使用完对象之后需要人为手动释放，如果忘记释放就会造成循环引用了。如果使用完completion handler之后直接释放block即可。
方法三：使用weakSelf、strongSelf






