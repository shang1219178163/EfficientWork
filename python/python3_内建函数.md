# Python 3 内建函数完整参考

Python 3 的内建函数（Built-in Functions）是指无需导入任何模块即可直接使用的函数。截至 Python 3.12/3.13，共有 **70+** 个。

---

## 一、类型转换

| 函数 | 说明 | 示例 |
|------|------|------|
| `int(x)` | 转换为整数 | `int("123")` → `123` |
| `float(x)` | 转换为浮点数 | `float("3.14")` → `3.14` |
| `str(x)` | 转换为字符串 | `str(123)` → `"123"` |
| `bool(x)` | 转换为布尔值 | `bool(0)` → `False` |
| `list(x)` | 转换为列表 | `list("abc")` → `['a','b','c']` |
| `tuple(x)` | 转换为元组 | `tuple([1,2,3])` → `(1,2,3)` |
| `set(x)` | 转换为集合 | `set([1,2,2,3])` → `{1,2,3}` |
| `dict(x)` | 转换为字典 | `dict([('a',1),('b',2)])` → `{'a':1,'b':2}` |
| `bytes(x)` | 转换为字节串 | `bytes("hi",'utf-8')` → `b'hi'` |
| `bytearray(x)` | 转换为可变字节数组 | `bytearray(5)` → `bytearray(b'\x00\x00\x00\x00\x00')` |
| `chr(i)` | 整数转字符 | `chr(65)` → `'A'` |
| `ord(c)` | 字符转整数 | `ord('A')` → `65` |
| `hex(x)` | 整数转十六进制字符串 | `hex(255)` → `'0xff'` |
| `oct(x)` | 整数转八进制字符串 | `oct(8)` → `'0o10'` |
| `bin(x)` | 整数转二进制字符串 | `bin(3)` → `'0b11'` |

---

## 二、数学运算

| 函数 | 说明 | 示例 |
|------|------|------|
| `abs(x)` | 绝对值 | `abs(-5)` → `5` |
| `round(x, n)` | 四舍五入，n 为小数位数 | `round(3.14159, 2)` → `3.14` |
| `pow(x, y)` | 幂运算（同 `x ** y`） | `pow(2, 3)` → `8` |
| `divmod(a, b)` | 返回 `(商, 余数)` | `divmod(10, 3)` → `(3, 1)` |
| `sum(iterable)` | 求和 | `sum([1,2,3])` → `6` |
| `max(iterable)` | 最大值 | `max([1,5,3])` → `5` |
| `min(iterable)` | 最小值 | `min([1,5,3])` → `1` |

---

## 三、序列/迭代相关

| 函数 | 说明 | 示例 |
|------|------|------|
| `len(obj)` | 长度/元素个数 | `len("hello")` → `5` |
| `sorted(iterable)` | 返回排序后的列表 | `sorted([3,1,2])` → `[1,2,3]` |
| `reversed(seq)` | 返回反向迭代器 | `list(reversed([1,2,3]))` → `[3,2,1]` |
| `enumerate(iterable)` | 返回索引-元素对 | `list(enumerate(['a','b']))` → `[(0,'a'),(1,'b')]` |
| `zip(*iterables)` | 并行打包为元组 | `list(zip([1,2],['a','b']))` → `[(1,'a'),(2,'b')]` |
| `map(func, iterable)` | 应用函数到每个元素 | `list(map(str, [1,2,3]))` → `['1','2','3']` |
| `filter(func, iterable)` | 过滤满足条件的元素 | `list(filter(lambda x:x>2, [1,2,3,4]))` → `[3,4]` |
| `all(iterable)` | 全部为 True 返回 True | `all([True, True])` → `True` |
| `any(iterable)` | 任一为 True 返回 True | `any([False, True])` → `True` |
| `range(start, stop, step)` | 生成整数序列 | `list(range(3))` → `[0,1,2]` |
| `slice(start, stop, step)` | 切片对象 | `"hello"[slice(1,4)]` → `"ell"` |

---

## 四、输入/输出

| 函数 | 说明 | 示例 |
|------|------|------|
| `print(*objects)` | 打印输出 | `print("Hello", "World")` |
| `input(prompt)` | 读取用户输入 | `name = input("请输入姓名: ")` |
| `open(file, mode)` | 打开文件 | `f = open("test.txt", "r")` |

---

## 五、对象/属性操作

| 函数 | 说明 | 示例 |
|------|------|------|
| `type(obj)` | 返回对象类型 | `type(123)` → `<class 'int'>` |
| `isinstance(obj, classinfo)` | 判断对象是否为某类型 | `isinstance(123, int)` → `True` |
| `issubclass(cls, classinfo)` | 判断是否为子类 | `issubclass(bool, int)` → `True` |
| `hasattr(obj, name)` | 是否有属性 | `hasattr("hello", "upper")` → `True` |
| `getattr(obj, name)` | 获取属性 | `getattr("hello", "upper")` → `<method 'upper'>` |
| `setattr(obj, name, value)` | 设置属性 | `setattr(obj, 'x', 10)` |
| `delattr(obj, name)` | 删除属性 | `delattr(obj, 'x')` |
| `dir(obj)` | 返回属性列表 | `dir([])` → `['append', 'clear', ...]` |
| `id(obj)` | 返回对象唯一标识 | `id("hello")` → `140234567890` |
| `hash(obj)` | 返回哈希值 | `hash("hello")` → `-4556044465483345647` |
| `callable(obj)` | 是否可调用 | `callable(print)` → `True` |

---

## 六、其他常用

| 函数 | 说明 | 示例 |
|------|------|------|
| `help(obj)` | 获取帮助文档 | `help(print)` |
| `repr(obj)` | 返回可打印的表示字符串 | `repr("hello")` → `"'hello'"` |
| `ascii(obj)` | 类似 `repr`，非 ASCII 转义 | `ascii("你好")` → `"'\\u4f60\\u597d'"` |
| `format(value, spec)` | 格式化 | `format(3.14, ".1f")` → `"3.1"` |
| `globals()` | 返回全局变量字典 | `globals()` → `{'__name__': '__main__', ...}` |
| `locals()` | 返回局部变量字典 | `locals()` → `{'x': 1, ...}` |
| `vars(obj)` | 返回对象的 `__dict__` | `vars(object)` |
| `eval(expr)` | 执行表达式字符串 | `eval("2 + 3")` → `5` |
| `exec(code)` | 执行代码字符串 | `exec("a = 5")` |
| `compile(source, filename, mode)` | 编译代码为代码对象 | `compile("print('hi')", "", "exec")` |
| `__import__(name)` | 动态导入模块（通常用 `importlib`） | `__import__("math")` |

---

## 七、3.x 新增/少见的函数

| 函数 | 说明 | 版本 |
|------|------|------|
| `breakpoint()` | 进入调试器 | Python 3.7+ |
| `memoryview(obj)` | 内存视图 | Python 3.x |

---

## 八、注意事项

> **注意**：`reduce()` 在 Python 3 中已移出内建函数，需从 `functools` 导入：
> ```python
> from functools import reduce
> reduce(lambda x, y: x + y, [1, 2, 3])  # 输出 6
> ```

---

## 快速参考卡片

```python
# 常用内建函数速查
abs()       # 绝对值
all()       # 全部为真
any()       # 任一为真
bin()       # 转二进制
bool()      # 转布尔值
chr()       # 整数转字符
dict()      # 创建字典
dir()       # 列出属性
enumerate() # 索引-元素对
eval()      # 执行表达式
filter()    # 过滤
float()     # 转浮点数
format()    # 格式化
help()      # 帮助文档
hex()       # 转十六进制
input()     # 用户输入
int()       # 转整数
isinstance()# 类型判断
len()       # 长度
list()      # 转列表
map()       # 映射
max()       # 最大值
min()       # 最小值
open()      # 打开文件
ord()       # 字符转整数
pow()       # 幂运算
print()     # 打印输出
range()     # 整数序列
repr()      # 字符串表示
reversed()  # 反向迭代
round()     # 四舍五入
set()       # 创建集合
sorted()    # 排序
str()       # 转字符串
sum()       # 求和
tuple()     # 转元组
type()      # 获取类型
zip()       # 并行打包