### dynamic和Object

dynamic与var一样都是关键词,声明的变量可以赋值任意对象。 而dynamic与Object相同之处在于,他们声明的变量可以在后期改变赋值类型。

dynamic与Object不同的是,dynamic声明的对象编译器会提供所有可能的组合, 而Object声明的对象只能使用Object的属性与方法, 否则编译器会报错。

### final和const

const 变量是一个编译时常量，final变量在第一次使用时被初始化。被final或者const修饰的变量，变量类型可以省略