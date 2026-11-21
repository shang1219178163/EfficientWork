# Python `collections` 模块详解

`collections` 是 Python 标准库中非常强大的模块，提供了多种高性能的容器数据类型。

## 1. `Counter` - 计数器

用于统计可哈希对象的出现次数。

```python
from collections import Counter

# 基本用法
c = Counter(['a', 'b', 'a', 'c', 'a', 'b'])
print(c)  # Counter({'a': 3, 'b': 2, 'c': 1})

# 统计字符串字符
c = Counter("hello world")
print(c.most_common(2))  # [('l', 3), ('o', 2)]

# 统计单词
words = "the quick brown fox jumps over the lazy dog".split()
print(Counter(words).most_common(1))  # [('the', 2)]

# 数学运算
c1 = Counter(a=3, b=1)
c2 = Counter(a=1, b=2)
print(c1 + c2)  # Counter({'a': 4, 'b': 3})
print(c1 - c2)  # Counter({'a': 2})
print(c1 & c2)  # Counter({'a': 1, 'b': 1})  交集（取小）
print(c1 | c2)  # Counter({'a': 3, 'b': 2})  并集（取大）

# 访问不存在的键返回 0（不会报错）
print(c1['z'])  # 0
```

## 2. `defaultdict` - 默认字典

访问不存在的键时自动创建默认值。

```python
from collections import defaultdict

# 按首字母分组单词
words = ['apple', 'banana', 'avocado', 'blueberry']
groups = defaultdict(list)
for w in words:
    groups[w[0]].append(w)
print(dict(groups))  # {'a': ['apple', 'avocado'], 'b': ['banana', 'blueberry']}

# 计数
counts = defaultdict(int)
for ch in "hello":
    counts[ch] += 1
print(dict(counts))  # {'h': 1, 'e': 1, 'l': 2, 'o': 1}

# 嵌套
nested = defaultdict(lambda: defaultdict(int))
nested['a']['b'] += 1
print(dict(nested))  # {'a': {'b': 1}}
```

## 3. `OrderedDict` - 有序字典

记住键的插入顺序（Python 3.7+ 普通 dict 已保证顺序，但 `OrderedDict` 有额外功能）。

```python
from collections import OrderedDict

od = OrderedDict()
od['b'] = 2
od['a'] = 1
od['c'] = 3
print(od)  # OrderedDict({'b': 2, 'a': 1, 'c': 3})

# 移动到末尾
od.move_to_end('b')
print(od)  # OrderedDict({'a': 1, 'c': 3, 'b': 2})

# 弹出最后/最前一个
od.popitem(last=True)   # 弹出末尾
od.popitem(last=False)  # 弹出开头

# 顺序敏感相等
print(OrderedDict(a=1, b=2) == OrderedDict(b=2, a=1))  # False
print({'a':1,'b':2} == {'b':2,'a':1})                 # True
```

## 4. `namedtuple` - 命名元组

创建带字段名的元组，兼具可读性和轻量性。

```python
from collections import namedtuple

Point = namedtuple('Point', ['x', 'y'])
p = Point(10, 20)
print(p.x, p.y)      # 10 20
print(p[0], p[1])    # 10 20
print(p)             # Point(x=10, y=20)
x, y = p             # 支持解包

# 常用方法
print(p._asdict())          # {'x': 10, 'y': 20}
print(p._replace(x=5))      # Point(x=5, y=20)
print(p._fields)            # ('x', 'y')

# 从字典创建
d = {'x': 1, 'y': 2}
p2 = Point(**d)

# 带默认值
Person = namedtuple('Person', ['name', 'age'], defaults=[0])
print(Person('Alice'))  # Person(name='Alice', age=0)
```

## 5. `deque` - 双端队列

支持从两端高效添加/删除元素，复杂度 O(1)。

```python
from collections import deque

d = deque([1, 2, 3])
d.append(4)         # 右端添加
d.appendleft(0)     # 左端添加
print(d)            # deque([0, 1, 2, 3, 4])

d.pop()             # 右端弹出 4
d.popleft()         # 左端弹出 0
print(d)            # deque([1, 2, 3])

# 固定长度（自动淘汰旧元素）
recent = deque(maxlen=3)
for i in range(5):
    recent.append(i)
print(recent)       # deque([2, 3, 4], maxlen=3)

# 旋转
d = deque([1, 2, 3, 4, 5])
d.rotate(2)   # 向右旋转 2 位 → deque([4, 5, 1, 2, 3])
d.rotate(-1)  # 向左旋转 1 位

# 扩展
d.extend([6, 7])       # 右端批量添加
d.extendleft([8, 9])   # 左端批量添加（注意会反向！）

# 应用：用 deque 实现简单队列/BFS
queue = deque([1])
queue.popleft()
```

## 6. `ChainMap` - 链式映射

将多个字典组合成一个逻辑视图，查找时按顺序搜索。

```python
from collections import ChainMap

defaults = {'theme': 'light', 'lang': 'en', 'font': 'Arial'}
user = {'theme': 'dark'}

config = ChainMap(user, defaults)
print(config['theme'])  # dark（优先 user）
print(config['lang'])   # en（回退 defaults）

# 修改只影响第一个映射
config['lang'] = 'zh'
print(user)  # {'theme': 'dark', 'lang': 'zh'}

# 新增映射
new_config = config.new_child({'font': 'Helvetica'})
```

**应用场景**：配置管理、作用域链（如变量查找）。

## 7. `UserDict` / `UserList` / `UserString`

包装类，方便继承并自定义容器行为。

```python
from collections import UserDict

class MyDict(UserDict):
    def __setitem__(self, key, value):
        print(f"设置 {key}={value}")
        super().__setitem__(key, value)

d = MyDict()
d['a'] = 1  # 打印: 设置 a=1
```

**为什么不用 `dict` 子类？** 因为 `dict` 的某些方法不调用子类的 `__setitem__`，而 `UserDict` 内部使用 `self.data`，行为更一致。

## 8. `abc` 抽象基类（Python 3.3+）

`collections.abc` 提供容器抽象基类，用于类型判断和自定义容器：

```python
from collections.abc import Sequence, Mapping, Iterable

isinstance([1,2], Sequence)   # True
isinstance({'a':1}, Mapping)  # True
isinstance("abc", Iterable)   # True

# 自定义序列只需实现 __getitem__ 和 __len__
class MySeq(Sequence):
    def __init__(self, data): self.data = data
    def __getitem__(self, i): return self.data[i]
    def __len__(self): return len(self.data)

s = MySeq([1,2,3])
print(1 in s, s[1], list(reversed(s)))  # 自动获得 count/index 等方法
```

---

## 快速对比总结

| 类型 | 用途 | 关键特性 |
|------|------|---------|
| `Counter` | 计数统计 | `most_common`、算术运算 |
| `defaultdict` | 带默认值的字典 | 避免 KeyError |
| `OrderedDict` | 有序字典 | `move_to_end`、顺序敏感比较 |
| `namedtuple` | 轻量数据对象 | 字段名访问、不可变 |
| `deque` | 双端队列 | O(1) 两端操作、`maxlen` |
| `ChainMap` | 多字典视图 | 查找链、配置管理 |
| `UserDict` 等 | 可继承容器 | 自定义容器行为 |

需要我针对某个类型给出更深入的例子吗？