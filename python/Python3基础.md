# Python基础

## 数据类型

### Numbers（数字）
int（有符号整型）
long（长整型，也可以代表八进制和十六进制）
float（浮点型）
complex（复数）

### String（字符串）
字符串或串(String)是由数字、字母、下划线组成的一串字符。
子字符串用 [头下标:尾下标] 来截取，下标是从 0 开始算起，可以是正数或负数，下标可以为空表示取到头或尾。子字符串包含头下标的字符，但不包含尾下标的字符。

### List（列表）
列表用 [ ] 标识，是 python 最通用的复合数据类型。
子列表切割也可以用到变量 [头下标:尾下标] ，从左到右索引默认 0 开始，从右到左索引默认 -1 开始，下标可以为空表示取到头或尾。

函数

	1	cmp(list1, list2)
		比较两个列表的元素
	2	len(list)
		列表元素个数
	3	max(list)
		返回列表元素最大值
	4	min(list)
		返回列表元素最小值
	5	list(seq)
		将元组转换为列表
		
方法

	1	list.append(obj)
		在列表末尾添加新的对象
	2	list.count(obj)
		统计某个元素在列表中出现的次数
	3	list.extend(seq)
		在列表末尾一次性追加另一个序列中的多个值（用新列表扩展原来的列表）
	4	list.index(obj)
		从列表中找出某个值第一个匹配项的索引位置
	5	list.insert(index, obj)
		将对象插入列表
	6	list.pop([index=-1])
		移除列表中的一个元素（默认最后一个元素），并且返回该元素的值
	7	list.remove(obj)
		移除列表中某个值的第一个匹配项
	8	list.reverse()
		反向列表中元素
	9	list.sort(cmp=None, key=None, reverse=False)
		对原列表进行排序
		
### Set（集合）
	一种无序、可变、不重复的数据类型。
	集合使用大括号 {} 表示，元素之间用逗号 , 分隔。
	
### Tuple（元组）
	元组是另一个数据类型，类似于 List（列表）。
	元组用 () 标识。内部元素用逗号隔开。但是元组不能二次赋值，相当于只读列表。
	tup2 = (20,)； 一个元素的元祖，需要在元素后添加逗号。
	
### Dictionary（字典）
	字典用"{ }"标识。字典由索引(key)和它对应的值value组成。
	内置函数
		len(dict)
			计算字典元素个数，即键的总数。
		str(dict)
			输出字典，可以打印的字符串表示。>>> str(tinydict)："{'Name': 'Runoob', 'Class': 'First', 'Age': 7}"
		type(variable)
			返回输入的变量类型，如果变量是字典就返回字典类型。>>> type(tinydict)： <class 'dict'>
			
### bytes 类型
	不可变的二进制序列（byte sequence）。用于处理二进制数据，比如图像文件、音频文件、视频文件等等。在网络编程中，也经常使用 bytes 类型来传输二进制数据。
	创建 bytes 对象的方式有多种，最常见的方式是使用 b 前缀。
	与字符串类型类似，bytes 类型也支持许多操作和方法，如切片、拼接、查找、替换等等。
补充：
	所有非零的数字和非空的字符串、列表、元组等数据类型都被视为 True，只有 0、空字符串、空列表、空元组等被视为 False。
	索引值以 0 为开始值，-1 为从末尾的开始位置。

## 数学函数
	abs(x)	返回数字的绝对值，如abs(-10) 返回 10
	ceil(x)	返回数字的上入整数，如math.ceil(4.1) 返回 5
	cmp(x, y)	如果 x < y 返回 -1, 如果 x == y 返回 0, 如果 x > y 返回 1
	exp(x)	返回e的x次幂(ex),如math.exp(1) 返回2.718281828459045
	fabs(x)	以浮点数形式返回数字的绝对值，如math.fabs(-10) 返回10.0
	floor(x)	返回数字的下舍整数，如math.floor(4.9)返回 4
	log(x)	如math.log(math.e)返回1.0,math.log(100,10)返回2.0
	log10(x)	返回以10为基数的x的对数，如math.log10(100)返回 2.0
	max(x1, x2,...)	返回给定参数的最大值，参数可以为序列。
	min(x1, x2,...)	返回给定参数的最小值，参数可以为序列。
	modf(x)	返回x的整数部分与小数部分，两部分的数值符号与x相同，整数部分以浮点型表示。
	pow(x, y)	x**y 运算后的值。
	round(x [,n])	返回浮点数x的四舍五入值，如给出n值，则代表舍入到小数点后的位数。
	sqrt(x)	返回数字x的平方根
## 数据类型转换
	int(x [,base])
		将x转换为一个整数
	long(x [,base] )
		将x转换为一个长整数
	float(x)
		将x转换到一个浮点数
	complex(real [,imag])
		创建一个复数
	str(x)
		将对象 x 转换为字符串
	repr(x)
		将对象 x 转换为表达式字符串
	eval(str)
		用来计算在字符串中的有效Python表达式,并返回一个对象
	tuple(s)
		将序列 s 转换为一个元组
	list(s)
		将序列 s 转换为一个列表
	set(s)
		转换为可变集合
	dict(d)
		创建一个字典。d 必须是一个序列 (key,value)元组。
	frozenset(s)
		转换为不可变集合
	chr(x)
		将一个整数转换为一个字符
	unichr(x)
		将一个整数转换为Unicode字符
	ord(x)
		将一个字符转换为它的整数值
	hex(x)
		将一个整数转换为一个十六进制字符串
	oct(x)
		将一个整数转换为一个八进制字符串
## 运算符
	算术运算符
	成员运算符
		in	如果在指定的序列中找到值返回 True，否则返回 False。x 在 y 序列中 , 如果 x 在 y 序列中返回 True。例如 if ( a in list ):
		not in	如果在指定的序列中没有找到值返回 True，否则返回 False。x 不在 y 序列中 , 如果 x 不在 y 序列中返回 True。例如 if ( b not in list ):
	身份运算符
		is 是判断两个标识符是不是引用自一个对象	x is y, 类似 id(x) == id(y) , 如果引用的是同一个对象则返回 True，否则返回 False
		is not 是判断两个标识符是不是引用自不同对象	x is not y ， 类似 id(a) != id(b)。如果引用的不是同一个对象则返回结果 True，否则返回 False。
## 循环语句
	while
	for  in  遍历任何序列的项目，如一个列表或者一个字符串。
	continue 语句跳出本次循环，而break跳出整个循环。
	pass 不做任何事情，一般用做占位语句。
## 条件控制
	match...case，_ 可以匹配一切。一个 case 也可以设置多个匹配条件，条件使用 ｜ 隔开。例如：
	
    match type
    case 401|403|404: 
         return "Not allowed"
    case _:
         return "default"
     
## 推导式
	Python 推导式是一种独特的数据处理方式，可以从一个数据序列构建另一个新的数据序列的结构体。适用于生成列表、字典、集合和生成器。
	格式
		[表达式 for 变量 in 列表]
			[out_exp_res for out_exp in input_list]
		[表达式 for 变量 in 列表 if 条件]
			[out_exp_res for out_exp in input_list if condition]
		解释
			out_exp_res：列表生成元素表达式，可以是有返回值的函数。
			for out_exp in input_list：迭代 input_list 将 out_exp 传入到 out_exp_res 表达式中。
			if condition：条件语句，可以过滤列表中不符合条件的值。
	字典推导式
		{ key_expr: value_expr for value in collection }
			list = ['Google','Runoob', 'Taobao']
			
    # 将列表中各字符串值为键，各字符串的长度为值，组成键值对
    >>> newdict = {key:len(key) for key in list}
    >>> newdict
    {'Google': 6, 'Runoob': 6, 'Taobao': 6}
    		{ key_expr: value_expr for value in collection if condition }
    			>>> dic = {x: x**2 for x in (2, 4, 6)}
    >>> dic
    {2: 4, 4: 16, 6: 36}
    >>> type(dic)
    <class 'dict'>
    	集合推导式
    		{ exp for item in Sequence }
    			>>> setnew = {i**2 for i in (1,2,3)}
    >>> setnew
    {1, 4, 9}
    		{ exp for item in Sequence if conditional }
    			>>> a = {x for x in 'abracadabra' if x not in 'abc'}
    >>> a
    {'d', 'r'}
    >>> type(a)
    <class 'set'>
    	元组推导式（生成器表达式）
    		(exp for item in Sequence )
    			>>> a = (x for x in range(1,10))
    >>> a
    <generator object <genexpr> at 0x7faf6ee20a50>  # 返回的是生成器对象
    
    >>> tuple(a)       # 使用 tuple() 函数，可以直接将生成器对象转换成元组
    (1, 2, 3, 4, 5, 6, 7, 8, 9)
    		(exp for item in Sequence if conditional )
## 迭代器与生成器
	迭代器
		迭代器是一个可以记住遍历的位置的对象。两个基本的方法：iter() 和 next()。
		StopIteration 异常用于标识迭代的完成，防止出现无限循环的情况，在 __next__() 方法中我们可以设置在完成指定循环次数后触发 StopIteration 异常来结束迭代。

	生成器
		使用了 yield 的函数被称为生成器（generator）。yield 是一个关键字，用于定义生成器函数，生成器函数是一种特殊的函数，可以在迭代过程中逐步产生值，而不是一次性返回所有结果。


## 关键字
	with
		with 用于上下文管理协议（Context Management Protocol）。它简化了资源管理代码，特别是那些需要明确释放或清理的资源（如文件、网络连接、数据库连接等）。
			with 语句背后上下文管理协议，该协议要求对象实现两个方法：

    __enter__()：进入上下文时调用，返回值赋给 as 后的变量。
    __exit__()：退出上下文时调用，处理清理工作。
    			__exit__() 方法接收三个参数：
    
    exc_type：异常类型
    exc_val：异常值
    exc_tb：异常追踪信息
    如果 __exit__() 返回 True，则表示异常已被处理，不会继续传播；返回 False 或 None，异常会继续向外传播。
    		示例
    			文件操作
    				# 同时打开多个文件
    with open('input.txt', 'r') as infile, open('output.txt', 'w') as outfile:
    content = infile.read()
    outfile.write(content.upper())
    			数据库连接
    				import sqlite3
    
    with sqlite3.connect('database.db') as conn:
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM users')
    results = cursor.fetchall()
    
    # 连接自动关闭
	 import threading
    lock = threading.Lock()
    
    with lock:
    
    # 临界区代码
    print("这段代码是线程安全的")
	 临时修改系统状态
	 import decimal
    
    with decimal.localcontext() as ctx:
    ctx.prec = 42  # 临时设置高精度

    # 执行高精度计算
    # 精度恢复原设置
	创建自定义的上下文管理器
		class Timer:
        def __enter__(self):
            import time
            self.start = time.time()
            return self
            
        def __exit__(self, exc_type, exc_val, exc_tb):
            import time
            self.end = time.time()
            print(f"耗时: {self.end - self.start:.2f}秒")
            return False

    # 使用示例
    with Timer() as t:
    # 执行一些耗时操作
    sum(range(1000000))
    	contextlib 模块
    		from contextlib import contextmanager
    
    @contextmanager
    def tag(name):
    print(f"<{name}>")
    yield
    print(f"</{name}>")
    
    # 使用示例
    with tag("h1"):
    print("这是一个标题")
    
## 函数
	匿名函数 使用 lambda 来创建。
		定义
			lambda 只是一个表达式，函数体比 def 简单很多。
			lambda 的主体是一个表达式，而不是一个代码块。仅仅能在 lambda 表达式中封装有限的逻辑进去。
			lambda 函数拥有自己的命名空间，且不能访问自己参数列表之外或全局命名空间里的参数。
			虽然 lambda 函数看起来只能写一行，却不等同于 C 或 C++ 的内联函数，内联函数的目的是调用小函数时不占用栈内存从而减少函数调用的开销，提高代码的执行速度。
		语法
			lambda [arg1 [,arg2,.....argn]]:expression
			lambda是 Python 的关键字，用于定义 lambda 函数。
			arguments 是参数列表，可以包含零个或多个参数，但必须在冒号(:)前指定。
			expression 是一个表达式，用于计算并返回函数的结果。
			示例
				x = lambda a : a + 10

            print(x(5))//15
            				sum = lambda arg1, arg2: arg1 + arg2
            
            print ("相加后的值为 : ", sum( 10, 20 ))//30
            				def myfunc(n):
            return lambda a : a * n
            
## 函数式编程    
    函数式编程的一个特点就是，允许把函数本身作为参数传入另一个函数，还允许返回一个函数！
### 高阶函数
#### map
map()函数接收两个参数，一个是函数，一个是序列，用于将一个函数作用于一个序列，以此得到另一个序列；。

    >>> def f(x):
    ...     return x * x
    ...
    >>> r = map(f, [1, 2, 3, 4, 5, 6, 7, 8, 9])
    >>> list(r)
    [1, 4, 9, 16, 25, 36, 49, 64, 81]

#### reduce
reduce把一个函数作用在一个序列[x1, x2, x3, ...]上，这个函数必须接收两个参数，reduce把结果继续和序列的下一个元素做累积计算，其效果就是：

    reduce(f, [x1, x2, x3, x4]) = f(f(f(x1, x2), x3), x4)
    
    求和：
    >>> from functools import reduce
    >>> def add(x, y):
    ...     return x + y
    ...
    >>> reduce(add, [1, 3, 5, 7, 9])
    25

#### filter
filter()把传入的函数依次作用于每个元素，然后根据返回值是 True 还是 False 决定保留还是丢弃该元素。
由于使用了惰性计算，所以只有在取 filter() 结果的时候，才会真正筛选并每次返回下一个筛出的元素。
如果要强迫 filter() 完成计算结果，需要用list()函数获得所有结果并返回list。

    #序列中的空字符串删掉
    def not_empty(s):
        return s and s.strip()
    
    list(filter(not_empty, ['A', '', 'B', None, 'C', '  ']))
    # 结果: ['A', 'B', 'C']
    
#### sorted

key指定的函数将作用于list的每一个元素上，并根据key函数返回的结果进行排序。对比原始的list和经过key=abs处理过的list：

list = [36, 5, -12, 9, -21]

keys = [36, 5,  12, 9,  21]

    >>> sorted([36, 5, -12, 9, -21], key=abs)
    [5, 9, -12, -21, 36]

### 返回函数
### 匿名函数
### 装饰器
### 偏函数


## 装饰器
	函数装饰器
		不修改原有函数代码的基础上，动态地增加或修改函数的功能，装饰器本质上是一个接收函数作为输入并返回一个新的包装过后的函数的对象。
		无参
			def my_decorator(func):
    def wrapper():
        print("在原函数之前执行")
        func()
        print("在原函数之后执行")
    return wrapper
    
    @my_decorator
    def say_hello():
    print("Hello!")
    
    say_hello()
    		带参
    			def repeat(num_times):
    def decorator(func):
        def wrapper(*args, **kwargs):
            for _ in range(num_times):
                func(*args, **kwargs)
        return wrapper
    return decorator
    
    @repeat(3)
    def say_hello():
    print("Hello!")
    
    say_hello()
    
## 类装饰器

    类装饰器（Class Decorator）是一种用于动态修改类行为的装饰器，它接收一个类作为参数，并返回一个新的类或修改后的类。
	作用
	 1.添加/修改类的方法或属性.
    2.拦截实例化过程.
    3.实现单例模式、日志记录、权限检查等功能.
		常见形式
			函数形式的类装饰器（接收类作为参数，返回新类）
			
	类装饰器（实现 __call__ 方法）：
	class SingletonDecorator:
    """类装饰器，使目标类变成单例模式"""
    def __init__(self, cls):
        self.cls = cls
        self.instance = None
        
    def __call__(self, *args, **kwargs):
        """拦截实例化过程，确保只创建一个实例"""
        if self.instance is None:
            self.instance = self.cls(*args, **kwargs)
        return self.instance
    
    @SingletonDecorator
    class Database:
    def __init__(self):
        print("Database 初始化")
    
    db1 = Database()
    db2 = Database()
    print(db1 is db2)  # True，说明是同一个实例
---
    def logger(func):
    """日志装饰器，捕获并打印参数"""
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        # 打印位置参数
        print(f"位置参数: {args}")
        # 打印关键字参数
        print(f"关键字参数: {kwargs}")
        
        result = func(*args, **kwargs)
        
        print(f"返回值: {result}")
        return result
    return wrapper


    @logger
    def add(a, b, c=0):
        return a + b + c
    
    add(1, 2, c=3)
    # 位置参数: (1, 2)
    # 关键字参数: {'c': 3}
    # 返回值: 6
    
内置的装饰器

	@staticmethod: 将方法定义为静态方法，不需要实例化类即可调用。
	@classmethod: 将方法定义为类方法，第一个参数是类本身（通常命名为 cls）。
	@property: 将方法转换为属性，使其可以像属性一样访问。
	
	class MyClass:
    @staticmethod
    def static_method():
        print("This is a static method.")
    
    @classmethod
    def class_method(cls):
        print(f"This is a class method of {cls.__name__}.")
    
    @property
    def name(self):
        return self._name
    
    @name.setter
    def name(self, value):
        self._name = value
    
    # 使用
    MyClass.static_method()
    MyClass.class_method()
    
    obj = MyClass()
    obj.name = "Alice"
    print(obj.name)

## 标准模块
	math	数学运算（如平方根、三角函数等）
	os	操作系统相关功能（如文件、目录操作）
	sys	系统相关的参数和函数
	random	生成随机数
	datetime	处理日期和时间
	json	处理 JSON 数据
	re	正则表达式操作
	collections	提供额外的数据结构（如 defaultdict、deque）
	itertools	提供迭代器工具
	functools	高阶函数工具（如 reduce、lru_cache）
	
## __name__ 与 __main__
	__name__ 一个内置变量，用于表示当前模块的名称。值取决于模块是如何被使用的：
    当模块作为主程序运行时：__name__ 的值被设置为 "__main__"。
    
    当模块被导入时：__name__ 的值被设置为模块的文件名（不包括 .py 扩展名）。
    __main__  一个特殊的字符串，用于表示当前模块是作为主程序运行的。通常与 __name__ 变量一起使用，以确定模块是被导入还是作为独立脚本运行。
    
## 输入和输出
	
	 读取键盘输入 
    str = input("请输入：");   
    print ("你输入的内容是: ", str)
    
    open() 将会返回一个 file 对象：
    open(filename, mode)
    filename：包含了你要访问的文件名称的字符串值。
    
### 文件对象的方法

	#!/usr/bin/python3

    # 打开一个文件
    f = open("/tmp/foo.txt", "r")
    
    str = f.read()//所有内容
    print(str)

    # 关闭打开的文件
    f.close()
	f.readlines()
		返回该文件中包含的所有行。
	f.write()
		f.write(string) 将 string 写入到文件中, 然后返回写入的字符数。
	f.tell()
		用于返回文件当前的读/写位置（即文件指针的位置）。
	f.seek()
		如果要改变文件指针当前的位置, 可以使用 f.seek(offset, from_what) 函数。
		
## 输出
    1、print() 函数
    	str.format() 函数来格式化输出值。
    	print('{}网址： "{}!"'.format('菜鸟教程', 'www.runoob.com'))
    
    	str()： 函数返回一个用户易读的表达形式。
    	repr()： 产生一个解释器易读的表达形式。
	
    2、表达式语句
    		使用文件对象的 write() 方法，标准输出文件可以用 sys.stdout 引用。
    	序列化
    		pickle模块实现了基本的数据序列和反序列化。
    
            通过pickle模块的序列化操作我们能够将程序中运行的对象信息保存到文件中去，永久存储。
            
            通过pickle模块的反序列化操作，我们能够从文件中创建上一次程序保存的对象。
    			pickle.dump(obj, file, [,protocol])
    			x = pickle.load(file)
            			
			
			#!/usr/bin/python3
        import pickle
        
        # 使用pickle模块将数据对象保存到文件
        data1 = {'a': [1, 2.0, 3, 4+6j],
             'b': ('string', u'Unicode string'),
             'c': None}
        
        selfref_list = [1, 2, 3]
        selfref_list.append(selfref_list)
        
        output = open('data.pkl', 'wb')
        
        # Pickle dictionary using protocol 0.
        pickle.dump(data1, output)
        
        # Pickle the list using the highest protocol available.
        pickle.dump(selfref_list, output, -1)
        
        output.close()
        
        #使用pickle模块从文件中重构python对象
        pkl_file = open('output, 'rb')
        data1New = pickle.load(pkl_file)
        pkl_file.close()

## File文件
	open
		open(file, mode='r', buffering=-1, encoding=None, errors=None, newline=None, closefd=True, opener=None)
		参数说明
			file: 必需，文件路径（相对或者绝对路径）。
			mode: 可选，文件打开模式
				mode：决定了打开文件的模式：只读，写入，追加等。所有可取值见如下的完全列表。这个参数是非强制的，默认文件访问模式为只读(r)。
					r	以只读方式打开文件，文件指针将会放在文件的开头（默认模式）。
					rb	以二进制格式打开一个文件用于只读。
					r+	打开一个文件用于读写。
					rb+	以二进制格式打开一个文件用于读写。
					w	打开一个文件只用于写入。如果该文件已存在则打开文件，并从开头开始编辑，即原有内容会被删除。如果该文件不存在，创建新文件。
					wb	以二进制格式打开一个文件只用于写入。如果该文件已存在则打开文件，并从开头开始编辑，即原有内容会被删除。如果该文件不存在，创建新文件。
					w+	打开一个文件用于读写。如果该文件已存在则打开文件，并从开头开始编辑，即原有内容会被删除。如果该文件不存在，创建新文件。
					wb+	以二进制格式打开一个文件用于读写。如果该文件已存在则打开文件，并从开头开始编辑，即原有内容会被删除。如果该文件不存在，创建新文件。
					a	打开一个文件用于追加。如果该文件已存在，文件指针将会放在文件的结尾。也就是说，新的内容将会被写入到已有内容之后。如果该文件不存在，创建新文件进行写入。
					ab	以二进制格式打开一个文件用于追加。如果该文件已存在，文件指针将会放在文件的结尾。也就是说，新的内容将会被写入到已有内容之后。如果该文件不存在，创建新文件进行写入。
					a+	打开一个文件用于读写。如果该文件已存在，文件指针将会放在文件的结尾。文件打开时会是追加模式。如果该文件不存在，创建新文件用于读写。
					ab+	以二进制格式打开一个文件用于追加。如果该文件已存在，文件指针将会放在文件的结尾。如果该文件不存在，创建新文件用于读写。
			buffering: 设置缓冲
			encoding: 一般使用utf8
			errors: 报错级别
			newline: 区分换行符
			closefd: 传入的file参数类型
			opener: 设置自定义开启器，开启器的返回值必须是一个打开的文件描述符。
## OS 文件/目录方法
	1. 获取当前工作目录
		os.getcwd() 函数用于获取当前工作目录的路径。当前工作目录是 Python 脚本执行时所在的目录。
		import os

    current_directory = os.getcwd()
    print("当前工作目录:", current_directory)
    	2. 改变当前工作目录
    		os.chdir(path) 函数用于改变当前工作目录。path 是你想要切换到的目录路径。
    		os.chdir("/path/to/new/directory")
    print("新的工作目录:", os.getcwd())
    	3. 列出目录内容
    		os.listdir(path) 函数用于列出指定目录中的所有文件和子目录。如果不提供 path 参数，则默认列出当前工作目录的内容。
    		files_and_dirs = os.listdir()
    print("目录内容:", files_and_dirs)
    	4. 创建目录
    		os.mkdir(path) 函数用于创建一个新的目录。如果目录已经存在，会抛出 FileExistsError 异常。
    		os.mkdir("new_directory")
    	5. 删除目录
    		os.rmdir(path) 函数用于删除一个空目录。如果目录不为空，会抛出 OSError 异常。
    		os.rmdir("new_directory")
    	6. 删除文件
    		os.remove(path) 函数用于删除一个文件。如果文件不存在，会抛出 FileNotFoundError 异常。
    		os.remove("file_to_delete.txt")
    	7. 重命名文件或目录
    		os.rename(src, dst) 函数用于重命名文件或目录。src 是原始路径，dst 是新的路径。
    		os.rename("old_name.txt", "new_name.txt")
    	8. 获取环境变量
    		os.getenv(key) 函数用于获取指定环境变量的值。如果环境变量不存在，返回 None。
    		home_directory = os.getenv("HOME")
    print("HOME 目录:", home_directory)
    	9. 执行系统命令
    		os.system(command) 函数用于在操作系统的 shell 中执行命令。命令执行后，返回命令的退出状态。
    		os.system("ls -l")
    		
## 面向对象
	类(Class): 用来描述具有相同的属性和方法的对象的集合。它定义了该集合中每个对象所共有的属性和方法。对象是类的实例。
	方法：类中定义的函数。
	类变量：类变量在整个实例化的对象中是公用的。类变量定义在类中且在函数体之外。类变量通常不作为实例变量使用。
	数据成员：类变量或者实例变量用于处理类及其实例对象的相关的数据。
	方法重写：如果从父类继承的方法不能满足子类的需求，可以对其进行改写，这个过程叫方法的覆盖（override），也称为方法的重写。
	局部变量：定义在方法中的变量，只作用于当前实例的类。
	实例变量：在类的声明中，属性是用变量来表示的，这种变量就称为实例变量，实例变量就是一个用 self 修饰的变量。
	继承：即一个派生类（derived class）继承基类（base class）的字段和方法。继承也允许把一个派生类的对象作为一个基类对象对待。例如，有这样一个设计：一个Dog类型的对象派生自Animal类，这是模拟"是一个（is-a）"关系（例图，Dog是一个Animal）。
	实例化：创建一个类的实例，类的具体对象。
	对象：通过类定义的数据结构实例。对象包括两个数据成员（类变量和实例变量）和方法。
	
## 命名空间和作用域
	命名空间(Namespace)是从名称到对象的映射，大部分的命名空间都是通过 Python 字典来实现的。
    
    总结
		全局变量在函数外部定义，可以在整个文件中访问。
		局部变量在函数内部定义，只能在函数内访问。
		使用 global 可以在函数中修改全局变量。
		使用 nonlocal 可以在嵌套函数中修改外部函数的变量。
## 虚拟环境
	虚拟环境（Virtual Environment）是一个独立的 Python 运行环境，它允许你在同一台机器上为不同的项目创建隔离的 Python 环境。每个虚拟环境都有自己的：
    Python 解释器。
    安装的包/库。
    环境变量。
## 类型注解（Type Hints）
	# 没有类型注解
    def greet(name):
    return f"Hello, {name}"

    # 有类型注解
    def greet(name: str) -> str:
    return f"Hello, {name}"
## 标准库
	os 模块：os 模块提供了许多与操作系统交互的函数，例如创建、移动和删除文件和目录，以及访问环境变量等。
	sys 模块：sys 模块提供了与 Python 解释器和系统相关的功能，例如解释器的版本和路径，以及与 stdin、stdout 和 stderr 相关的信息。
	time 模块：time 模块提供了处理时间的函数，例如获取当前时间、格式化日期和时间、计时等。
	datetime 模块：datetime 模块提供了更高级的日期和时间处理函数，例如处理时区、计算时间差、计算日期差等。
		import datetime

    #获取当前日期和时间
    current_datetime = datetime.datetime.now()
    print(current_datetime)

    # 获取当前日期
    current_date = datetime.date.today()
    print(current_date)

    # 格式化日期
    date_str = current_datetime.strftime("%Y-%m-%d %H:%M:%S")
    print(date_str)  # 输出：2023-07-17 15:30:45
    	random 模块：random 模块提供了生成随机数的函数，例如生成随机整数、浮点数、序列等。
    	math 模块：math 模块提供了数学函数，例如三角函数、对数函数、指数函数、常数等。
    	re 模块：re 模块提供了正则表达式处理函数，可以用于文本搜索、替换、分割等。
    	json 模块：json 模块提供了 JSON 编码和解码函数，可以将 Python 对象转换为 JSON 格式，并从 JSON 格式中解析出 Python 对象。
    	urllib 模块：urllib 模块提供了访问网页和处理 URL 的功能，包括下载文件、发送 POST 请求、处理 cookies 等。
    	
# 高级特性
## 切片
可以理解为切片参数【from:to:by】
from 默认值最小索引；
to 默认最大索引；
by 间隔，默认1, 负数倒序；
    
    1、取一个list或tuple的部分元素是非常常见的操作。
    >>> L = ['Michael', 'Sarah', 'Tracy', 'Bob', 'Jack']
    
    2、获取子序列：从索引1开始，取出2个元素出来
    >>> L[1:3]
    ['Sarah', 'Tracy']

    >>> L[-2:]
    ['Bob', 'Jack']
    >>> L[-2:-1]
    ['Bob']

    3、序列倒数第一个元素的索引是 -1。
    >>> L = list(range(100))
    
    前10个数：
    >>> L[:10]
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    后10个数：
    >>> L[-10:]
    [90, 91, 92, 93, 94, 95, 96, 97, 98, 99]
    
    前11-20个数：
    >>> L[10:20]
    [10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
    
    前10个数，每两个取一个：
    >>> L[:10:2]
    [0, 2, 4, 6, 8]
    
    所有数，每5个取一个：
    >>> L[::5]
    [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95]
    甚至什么都不写，只写[:]就可以原样复制一个list：
    
    >>> L[:]
    [0, 1, 2, 3, ..., 99]

## 迭代

## 列表生成式
列表生成式即List Comprehensions，是Python内置的非常简单却强大的可以用来创建list的生成式。

    1、生成列表 [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    >>> list(range(1, 11))
    
    2、生成[1x1, 2x2, 3x3, ..., 10x10]
    或[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
    >>> [x * x for x in range(1, 11)]
    
    3、筛选出仅偶数的平方 [4, 16, 36, 64, 100]
    >>> [x * x for x in range(1, 11) if x % 2 == 0]
    

    4、两层循环，可以生成全排列：['AX', 'AY', 'AZ', 'BX', 'BY', 'BZ', 'CX', 'CY', 'CZ']
    >>> [m + n for m in 'ABC' for n in 'XYZ']

    5、列出当前目录下的所有文件和目录名：
    >>> import os # 导入os模块，模块的概念后面讲到
    >>> [d for d in os.listdir('.')] # os.listdir可以列出文件和目录
    
    6、同时迭代key和value
    >>> d = {'x': 'A', 'y': 'B', 'z': 'C' }
    >>> [k + '=' + v for k, v in d.items()]
    ['y=B', 'x=A', 'z=C']

    7、把一个list中所有的字符串变成小写
    >>> L = ['Hello', 'World', 'IBM', 'Apple']
    >>> [s.lower() for s in L]
    ['hello', 'world', 'ibm', 'apple']

    8、if ... else
    for前面的部分是一个表达式，它必须根据x计算出一个结果。
    >>> [x for x in range(1, 11) if x % 2 == 0]
    [2, 4, 6, 8, 10]

    跟在for后面的if是一个筛选条件，不能带else。
    >>> [x if x % 2 == 0 else -x for x in range(1, 11)]
    [-1, 2, -3, 4, -5, 6, -7, 8, -9, 10]


## 生成器
在Python中，一边循环一边计算的机制，称为生成器：generator。generator保存的是算法，每次调用next(g)，就计算出g的下一个元素的值，直到计算到最后一个元素，没有更多的元素时，抛出StopIteration的错误。

### 创建一个generator：
    第一种方法很简单，只要把一个列表生成式的[]改成()，就创建了一个generator。
    
    >>> L = [x * x for x in range(10)]
    >>> L
    [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
    >>> g = (x * x for x in range(10))
    >>> g
    <generator object <genexpr> at 0x1022ef630>
    可以通过next()函数获得generator的下一个返回值；
    
    不断调用next(g)实在是太变态了，正确的方法是使用for循环，因为generator也是可迭代对象：
    >>> g = (x * x for x in range(10))
    >>> for n in g:
    ...     print(n)
    

## 迭代器
可以直接作用于for循环的数据类型有以下几种：
一类是集合数据类型，如list、tuple、dict、set、str等；
一类是generator，包括生成器和带yield的generator function。

这些可以直接作用于for循环的对象统称为可迭代对象：Iterable。Iterator 对象表示的是一个数据流。
可以使用 isinstance() 判断一个对象是否是Iterable对象：

    >>> from collections.abc import Iterable
    >>> isinstance([], Iterable)
    True
    >>> isinstance({}, Iterable)
    True
    >>> isinstance('abc', Iterable)
    True
    >>> isinstance((x for x in range(10)), Iterable)
    True
    >>> isinstance(100, Iterable)
    False
    
    凡是可作用于for循环的对象都是Iterable类型；

凡是可作用于 next() 函数的对象都是 Iterator 类型，它们表示一个惰性计算的序列；

集合数据类型如 list、dict、str 等是 Iterable 但不是 Iterator，不过可以通过 iter()函数获得一个 Iterator 对象。

Python的 for 循环本质上就是通过不断调用 next() 函数实现的。
