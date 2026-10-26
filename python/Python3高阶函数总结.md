# Python 3 高阶函数总结

高阶函数（Higher-Order Function）是指接受函数作为参数或返回函数作为结果的函数。

## 一、内建高阶函数
### 1.map(function, iterable, ...)
将函数应用于可迭代对象的每个元素，返回迭代器。

    基础用法
    nums = [1, 2, 3, 4, 5]
    squared = list(map(lambda x: x ** 2, nums))
    print(squared)  # [1, 4, 9, 16, 25]
        
    多参数
    nums1 = [1, 2, 3]
    nums2 = [10, 20, 30]
    result = list(map(lambda x, y: x + y, nums1, nums2))
    print(result)  # [11, 22, 33]
        
    类型转换
    strings = ['1', '2', '3']
    numbers = list(map(int, strings))
    print(numbers)  # [1, 2, 3]

### 2.filter(function, iterable)
过滤出使函数返回 True 的元素，返回迭代器。

    过滤偶数
    nums = [1, 2, 3, 4, 5, 6, 7, 8]
    evens = list(filter(lambda x: x % 2 == 0, nums))
    print(evens)  # [2, 4, 6, 8]
    
    过滤空字符串
    words = ['hello', '', 'world', '', 'python']
    non_empty = list(filter(None, words))  # None 表示过滤假值
    print(non_empty)  # ['hello', 'world', 'python']
        
### 3.reduce(function, iterable[, initial])
需从 functools 导入，累积应用函数到元素，归约为单个值。

    from functools import reduce
    求和
    nums = [1, 2, 3, 4, 5]
    total = reduce(lambda x, y: x + y, nums)
    print(total)  # 15
    
    带初始值
    total = reduce(lambda x, y: x + y, nums, 10)
    print(total)  # 25
    
    求最大值
    max_val = reduce(lambda x, y: x if x > y else y, nums)
    print(max_val)  # 5
    
    字符串连接
    words = ['Hello', ' ', 'World']
    sentence = reduce(lambda x, y: x + y, words)
    print(sentence)  # Hello World
    
 ### 4.sorted(iterable, key=None, reverse=False)
返回排序后的新列表，key 参数接受函数。
        
    按绝对值排序
    nums = [-5, 2, -8, 3, -1]
    sorted_nums = sorted(nums, key=abs)
    print(sorted_nums)  # [-1, 2, 3, -5, -8]
    
    按字符串长度排序
    words = ['python', 'java', 'c', 'rust', 'javascript']
    sorted_words = sorted(words, key=len)
    print(sorted_words)  # ['c', 'java', 'rust', 'python', 'javascript']
    
    按元组第二个元素排序
    pairs = [(1, 'z'), (2, 'a'), (3, 'c')]
    sorted_pairs = sorted(pairs, key=lambda x: x[1])
    print(sorted_pairs)  # [(2, 'a'), (3, 'c'), (1, 'z')]
    
    多级排序
    students = [
        {'name': 'Alice', 'grade': 85},
        {'name': 'Bob', 'grade': 92},
        {'name': 'Charlie', 'grade': 85}
    ]
    sorted_students = sorted(students, key=lambda x: (x['grade'], x['name']))
    print(sorted_students)   
    
### 5.max / min 的 key 参数
    
    按条件取最大值
    words = ['python', 'java', 'c', 'rust']
    longest = max(words, key=len)
    print(longest)  # python
    
    按字典值取最大值
    scores = {'Alice': 85, 'Bob': 92, 'Charlie': 78}
    best_student = max(scores, key=scores.get)
    print(best_student)  # Bob
        
### 6.partial - 固定函数参数

    from functools import partial

    def power(base, exponent):
        return base ** exponent
    
    square = partial(power, exponent=2)
    cube = partial(power, exponent=3)
    
    print(square(5))  # 25
    print(cube(5))    # 125
    
    # 实际应用：固定 print 的结束符
    print_error = partial(print, file=sys.stderr, flush=True)
        
## 二、自定义高阶函数

### 1.函数作为参数

    def apply_operation(x, y, operation):
    """将操作函数应用到两个数上"""
    return operation(x, y)
    
    def add(a, b):
        return a + b
    
    def multiply(a, b):
        return a * b
    
    print(apply_operation(5, 3, add))       # 8
    print(apply_operation(5, 3, multiply))  # 15
    print(apply_operation(5, 3, lambda x, y: x - y))  # 2
        
### 2.函数作为返回值（闭包）


    def make_multiplier(factor):
        """创建乘法函数"""
        def multiplier(x):
            return x * factor
        return multiplier
    
    double = make_multiplier(2)
    triple = make_multiplier(3)
    
    print(double(10))  # 20
    print(triple(10))  # 30
    
    # 计数器示例
    def counter():
        count = 0
        def increment():
            nonlocal count
            count += 1
            return count
        return increment
    
    c1 = counter()
    print(c1())  # 1
    print(c1())  # 2
    
### 3.装饰器（高阶函数的典型应用）

    import functools
    import time
    
    def timer(func):
        """计算函数执行时间的装饰器"""
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            start = time.time()
            result = func(*args, **kwargs)
            elapsed = time.time() - start
            print(f"{func.__name__} took {elapsed:.4f}s")
            return result
        return wrapper
    
    @timer
    def slow_function():
        time.sleep(1)
        return "Done"
    
    print(slow_function())  # slow_function took 1.0012s\nDone
 
## 三、常用高阶函数组合模式
### Map-Filter-Reduce 流水线

    python
    from functools import reduce
    
    # 场景：过滤偶数，平方，求和
    numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    result = reduce(
        lambda x, y: x + y,
        map(lambda x: x ** 2,
            filter(lambda x: x % 2 == 0, numbers))
    )
    print(result)  # 220 (2²+4²+6²+8²+10²)
    
    # 更 Pythonic 的方式（列表推导）
    result = sum(x ** 2 for x in numbers if x % 2 == 0)
    print(result)  # 220
        
### 函数组合

    python
    def compose(*functions):
        """组合多个函数：compose(f, g)(x) = f(g(x))"""
        def composed(x):
            for func in reversed(functions):
                x = func(x)
            return x
        return composed
    
    def add_one(x):
        return x + 1
    
    def multiply_two(x):
        return x * 2
    
    def square(x):
        return x ** 2
    
    # (x + 1) * 2
    func1 = compose(multiply_two, add_one)
    print(func1(5))  # 12
    
    # ((x + 1) * 2)²
    func2 = compose(square, multiply_two, add_one)
    print(func2(5))  # 144

## 四、函数式编程工具库
### itertools - 高效迭代器工具
        
    python
    import itertools
    
    # 无限迭代
    counter = itertools.count(start=1, step=2)
    print(next(counter))  # 1
    print(next(counter))  # 3
    
    # 循环迭代
    cycler = itertools.cycle(['A', 'B', 'C'])
    print(list(itertools.islice(cycler, 5)))  # ['A', 'B', 'C', 'A', 'B']
    
    # 组合
    print(list(itertools.combinations([1,2,3], 2)))  # [(1,2),(1,3),(2,3)]
    print(list(itertools.permutations([1,2,3], 2)))  # [(1,2),(1,3),(2,1),(2,3),(3,1),(3,2)]
        
### functools - 高阶函数工具

    python
    import functools
    
    # lru_cache - 记忆化缓存
    @functools.lru_cache(maxsize=128)
    def fibonacci(n):
        if n < 2:
            return n
        return fibonacci(n-1) + fibonacci(n-2)
    
    print(fibonacci(100))  # 快速计算

    # cmp_to_key - 旧式比较函数转 key 函数
    def compare(a, b):
        return (a > b) - (a < b)  # 返回 1, 0, -1
    
    sorted_list = sorted([3,1,2], key=functools.cmp_to_key(compare))
    print(sorted_list)  # [1,2,3]

### operator - 替代 lambda 的运算符函数

    python
    import operator
    
    # 替代 lambda x: x[0]
    sorted_pairs = sorted([(1,2),(3,1),(2,3)], key=operator.itemgetter(1))
    print(sorted_pairs)  # [(3,1),(1,2),(2,3)]
    
    # 替代 lambda x, y: x + y
    total = reduce(operator.add, [1,2,3,4,5])
    print(total)  # 15
    
    # 属性访问
    from collections import namedtuple
    Person = namedtuple('Person', ['name', 'age'])
    people = [Person('Alice', 30), Person('Bob', 25)]
    sorted_people = sorted(people, key=operator.attrgetter('age'))
    print(sorted_people)
    
## 五、性能对比与最佳实践

方法|性能|可读性|推荐场景
|---|---|---|---|
map/filter  |中	|中	  |简单转换
列表推导式   |高	|高	  |首选（Pythonic）
生成器表达式	|高（省内存）|高	|大数据集
reduce	   |中	|中	    |累积操作


## 六、总结

    核心要点
    map：对每个元素做变换
    
    filter：筛选元素
    
    reduce：累积归约
    
    sorted/max/min：自定义排序/比较逻辑
    
    partial：固定参数创建新函数
    
    装饰器：修改/增强函数行为
    
    闭包：捕获状态的函数
    
    选择建议
    简单场景：列表推导式 > map/filter
    
    复杂逻辑：自定义高阶函数提高复用性
    
    性能关键：生成器表达式 + itertools
    
    函数式风格：functools + operator
    
    高阶函数是 Python 函数式编程的基石，合理使用可以写出更简洁、可复用的代码。



    
 
    
    