# Python 可变参数默认值注意点

## 现象

```python
from typing import Any


class ModelTest:

    def __init__(self,
                 data: dict[str, Any] = {},
                 items: list[str] = []
                 ) -> None:
        self.data = data
        self.items = items
        for e in [self.data, self.items]:
            print(f"{hex(id(self))} __init__ {type(e)} {hex(id(e))}")


a = ModelTest()
b = ModelTest()

# 0x103aed6a0 __init__ <class 'dict'> 0x103a614c0
# 0x103aed6a0 __init__ <class 'list'> 0x1039a08c0
# 0x103a411d0 __init__ <class 'dict'> 0x103a614c0
# 0x103a411d0 __init__ <class 'list'> 0x1039a08c0
```

`self` 的地址每行不同（a、b 是两个对象），但 dict / list 的地址跨实例完全相同。

## 原因

**默认值不是在每次调用时创建，而是在 `def` 执行时创建一次**，随后保存在函数对象上
（`ModelTest.__init__.__defaults__`）。之后每次 `ModelTest()` 不传参，拿到的都是**同一个**
dict 和 list。

```python
a, b = ModelTest(), ModelTest()
print(a.data is b.data)      # True
print(a.items is b.items)    # True
print(ModelTest.__init__.__defaults__)  # 就是这两个被共享的对象
```

顺带澄清一个容易混的点：

- `self.data = data` 只是把**引用**赋过去，并不复制内容；
- `id()` 在 CPython 下就是内存地址，但真正该判断的是身份：`a.data is b.data` 为 `True`。

## 危害

不只是「地址一样」，而是**共享可变状态**：

```python
a.data['k'] = 1
print(b.data)   # {'k': 1}  ← a 的修改污染了 b
```

所有没传参的实例共享同一份 dict / list，任何一处的修改都会影响到其他实例。

## 修复：用 `None` 哨兵在函数体内创建

```python
class ModelTest:

    def __init__(self,
                 data: dict[str, Any] | None = None,
                 items: list[str] | None = None
                 ) -> None:
        self.data = data if data is not None else {}
        self.items = items if items is not None else []
```

`None` 是不可变的，共享它没有任何副作用；每次调用时在函数体内新建 `{}` / `[]`，各实例互不影响。

## 判断规则

- 默认值只要是 list / dict / set / 自定义对象这类**可变**的，就不要直接写 `= []`、`= {}`，一律用 `None` 哨兵。
- 整数、字符串、元组、`None`、`frozenset` 这类**不可变**值可以放心写在默认参数里。
- 用 `is not None` 而不是 `or {}`，原因见下一节。

## `data or {}` 与 `is not None` 的区别

两者不等价，差别只在**调用方显式传了一个「假值」**时暴露。实测：

```python
d = {}
a, b = A(data=d), B(data=d)   # A 用 is not None，B 用 or {}
d['k'] = 1                    # 调用方拿到空 dict 后自己往里写

print(a.data, a.data is d)    # {'k': 1} True   ← 保留了调用方的对象
print(b.data, b.data is d)    # {}       False  ← 丢掉 d，换成新建的 {}
```

本质区别：

| 写法 | 判断的是 | 对应语义 |
| --- | --- | --- |
| `data or {}` | **真假值**（`bool(data)`） | 「值是空的就换掉」 |
| `data if data is not None else {}` | **调用方是否传了** | 「没传才给默认值」 |

`or` 会把所有这些都当「没传」：`None`、`{}`、`[]`、`""`、`0`、`False`，以及自定义了
`__bool__` / `__len__` 且返回 0 的对象。参数类型是 `dict | None` 时，实际会踩的是显式传 `{}`
那一种（以及自定义的假值映射类）。数值场景更常见：

```python
def f(num: int | None = None):
    return num or 10

f(0)   # 10 ← 调用方明确要 0，却被换成了默认值
```

什么时候 `or` 无妨：参数**只可能**是 `None` 或非空容器（从不传空容器/`0`/`""`）时，两者结果一致。
但只要调用方可能传空容器并**在乎对象身份或后续修改**，`is not None` 才是准确表达「没传才新建」的那一个。

## 适用范围：所有函数，不只 `__init__`

默认值在 `def` / `lambda` 执行时求值一次并挂在函数对象上，这是函数定义的通用行为，与是否叫 `__init__` 无关：

- 位置参数默认值 → `f.__defaults__`（元组）
- 关键字专用参数默认值 → `f.__kwdefaults__`（字典）

同样成立的位置：模块级函数、实例方法、`@staticmethod`、`@classmethod`、嵌套函数、`lambda`：

```python
class C:
    def m(self, x=[]): ...
    @staticmethod
    def s(x=[]): ...
    @classmethod
    def k(cls, x=[]): ...

c = C()
c.m(); C().m()      # 共享同一个 []
C.s(); C.s()        # 共享同一个 []
C.k(); C.k()        # 共享同一个 []

g = lambda x=[]: x  # 共享同一个 []
```

关键推论：绑定的是**函数对象**，`def` 每执行一次就新建一份默认值：

```python
def make():
    def inner(x=[]):
        x.append(1)
        return x
    return inner

i1, i2 = make(), make()
print(i1(), i2())   # [1] [1] ← 两次 def，各自独立
```

类体里的方法 `def` 在类定义时只执行一次，所以该类的所有实例共用同一份默认值——`__init__` 踩坑的原因与普通函数完全相同。

### 容易混淆的相关行为

| 场景 | 行为 |
| --- | --- |
| 类属性 `class A: items = []` | 定义时创建一次，所有实例共享（除非被实例属性覆盖）；独立陷阱，不是默认参数 |
| `@dataclass` 字段 `items: list = []` | 抛 `ValueError: mutable default ... use default_factory`，必须写 `field(default_factory=list)` |
| pydantic `Field(default=[])` | 实例化时对默认值做拷贝，不跨实例共享，语义比原生函数宽松 |


#### 总结
- 机制：默认值在 def/lambda 执行时求值一次，位置参数存 __defaults__、关键字专用参数存 __kwdefaults__
- 同样成立的位置：模块级函数、实例方法、@staticmethod、@classmethod、嵌套函数、lambda（含示例代码）
- 关键推论：绑定的是函数对象，def 每执行一次就新建一份默认值（make() 工厂返回的两个 inner 互不影响）
- 类体方法 def 只执行一次 → 全类实例共享，点明 __init__ 与普通函数机制完全相同
- 容易混淆的相关行为表：类属性共享、@dataclass 强制 default_factory、pydantic 会拷贝默认值