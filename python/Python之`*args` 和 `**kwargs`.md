# Python `*args` 和 `**kwargs` 总结

`*args` 和 `**kwargs` 是 Python 函数定义中的可变参数机制，用于接收数量不确定的参数。

- `*args`：接收任意数量的**位置参数**，封装为 `tuple`。
- `**kwargs`：接收任意数量的**关键字参数**，封装为 `dict`。

## 1. `*args`：可变位置参数

### 基本用法

```python
def add(*args):
    print(args)
    print(type(args))

add(1, 2, 3, 4)
```

输出：

```text
(1, 2, 3, 4)
<class 'tuple'>
```

`args` 本质上是一个元组，可以使用元组的各种操作。

### 遍历参数

```python
def add(*args):
    total = 0

    for item in args:
        total += item

    return total

print(add(1, 2, 3))       # 6
print(add(1, 2, 3, 4, 5)) # 15
```

### 与普通参数结合

```python
def introduce(name, *args):
    print(f"姓名：{name}")
    print(f"其他信息：{args}")

introduce("张三", 18, "男", "北京")
```

输出：

```text
姓名：张三
其他信息：(18, '男', '北京')
```

普通位置参数优先接收参数，剩余位置参数进入 `args`。

---

## 2. `**kwargs`：可变关键字参数

### 基本用法

```python
def introduce(**kwargs):
    print(kwargs)
    print(type(kwargs))

introduce(name="张三", age=18, city="北京")
```

输出：

```text
{'name': '张三', 'age': 18, 'city': '北京'}
<class 'dict'>
```

`kwargs` 本质上是字典。

### 遍历参数

```python
def introduce(**kwargs):
    for key, value in kwargs.items():
        print(f"{key}: {value}")

introduce(name="张三", age=18, city="北京")
```

输出：

```text
name: 张三
age: 18
city: 北京
```

### 获取指定参数

```python
def introduce(**kwargs):
    name = kwargs.get("name", "未知")
    age = kwargs.get("age", 0)

    print(name, age)

introduce(name="张三", age=18)
introduce(name="李四")
```

输出：

```text
张三 18
李四 0
```

---

## 3. `*args` 和 `**kwargs` 结合使用

```python
def test(name, *args, **kwargs):
    print("name:", name)
    print("args:", args)
    print("kwargs:", kwargs)

test("张三", 18, "男", city="北京", job="程序员")
```

输出：

```text
name: 张三
args: (18, '男')
kwargs: {'city': '北京', 'job': '程序员'}
```

| 参数 | 接收内容 | 类型 |
|---|---|---|
| `name` | 第一个位置参数 | 根据传入值决定 |
| `*args` | 剩余位置参数 | `tuple` |
| `**kwargs` | 剩余关键字参数 | `dict` |

---

## 4. 函数调用时的 `*` 和 `**`

`*args` 和 `**kwargs` 不仅能用于函数定义，也能用于函数调用。

### 4.1 `*`：解包列表或元组

```python
def add(a, b, c):
    return a + b + c

numbers = [1, 2, 3]

print(add(*numbers))
```

等价于：

```python
print(add(1, 2, 3))
```

### 4.2 `**`：解包字典

```python
def introduce(name, age, city):
    print(name, age, city)

person = {
    "name": "张三",
    "age": 18,
    "city": "北京"
}

introduce(**person)
```

等价于：

```python
introduce(
    name="张三",
    age=18,
    city="北京"
)
```

### 4.3 同时解包

```python
def test(name, age, city):
    print(name, age, city)

args = ("张三", 18)
kwargs = {"city": "北京"}

test(*args, **kwargs)
```

输出：

```text
张三 18 北京
```

---

## 5. 参数定义顺序

Python 函数参数有明确的顺序要求。

```python
def test(a, b=10, *args, c=20, **kwargs):
    print(a, b, args, c, kwargs)

test(1, 2, 3, 4, c=30, d=40)
```

输出：

```text
1 2 (3, 4) 30 {'d': 40}
```

常见参数类型及顺序：

| 顺序 | 参数类型 | 示例 |
|---|---|---|
| 1 | 仅限位置参数（可选） | `a, /` |
| 2 | 普通位置或关键字参数 | `a` |
| 3 | 默认参数 | `b=10` |
| 4 | 可变位置参数 | `*args` |
| 5 | 仅限关键字参数 | `*, c` 或 `c`（位于 `*args` 后） |
| 6 | 可变关键字参数 | `**kwargs` |

注意：`*args` 后面的参数（例如 `c`）只能通过关键字传递。`/` 左侧的参数只能通过位置传递。

---

## 6. `*` 和 `**` 的其他用法

### 6.1 单独使用 `*`：限制关键字参数

```python
def create_user(name, *, age, city):
    print(name, age, city)

create_user("张三", age=18, city="北京")
```

下面的调用会报错：

```python
create_user("张三", 18, "北京")
```

因为 `age` 和 `city` 必须使用关键字传递。

### 6.2 `*`：解包并收集剩余元素

```python
numbers = [1, 2, 3, 4, 5]

first, *middle, last = numbers

print(first)   # 1
print(middle)  # [2, 3, 4]
print(last)    # 5
```

这里的 `*middle` 会将剩余元素收集为列表。

### 6.3 字典合并

```python
user = {"name": "张三"}
extra = {"age": 18, "city": "北京"}

result = {**user, **extra}

print(result)
```

输出：

```python
{'name': '张三', 'age': 18, 'city': '北京'}
```

如果存在相同的键，后面的字典会覆盖前面的值。

---

## 7. `*args` 和 `**kwargs` 对比

| 对比项 | `*args` | `**kwargs` |
|---|---|---|
| 参数类型 | 位置参数 | 关键字参数 |
| 接收数量 | 任意数量 | 任意数量 |
| 封装类型 | `tuple` | `dict` |
| 访问方式 | 下标、遍历 | key、遍历 |
| 调用解包 | `*` | `**` |
| 参数示例 | `1, 2, 3` | `name="张三"` |

**核心记忆：**

- 定义函数：`*` 收集位置参数，`**` 收集关键字参数。
- 调用函数：`*` 解包可迭代对象，`**` 解包字典。
- `args` 和 `kwargs` 只是约定俗成的名称，并非 Python 关键字；也可以使用其他名称。

---

## 8. 实际开发中的典型应用

### 场景一：装饰器传递任意参数

```python
from functools import wraps

def log(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        print(f"调用函数：{func.__name__}")

        result = func(*args, **kwargs)

        return result

    return wrapper


@log
def add(a, b):
    return a + b


@log
def introduce(name, age):
    return f"{name}: {age}"


print(add(1, 2))
print(introduce("张三", 18))
```

装饰器通过 `*args` 和 `**kwargs`，可以兼容不同参数形式的函数。

### 场景二：继承时传递参数

```python
class Animal:
    def __init__(self, name, age):
        self.name = name
        self.age = age


class Dog(Animal):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)


dog = Dog("旺财", age=3)
```

通过参数转发，子类不需要重复定义父类的参数列表。

### 场景三：动态创建对象

```python
class User:
    def __init__(self, name, age):
        self.name = name
        self.age = age


data = {
    "name": "张三",
    "age": 18
}

user = User(**data)
```

常用于将字典数据映射到模型对象。

---

## 9. 与 Swift、Dart 对比

| 功能 | Python | Swift | Dart |
|---|---|---|---|
| 可变位置参数 | `*args` | Variadic Parameters `...` | 无直接对应 |
| 可变关键字参数 | `**kwargs` | 无直接对应 | 无直接对应 |
| 集合展开 | `*` | 无完全等价语法 | `...` |
| 字典参数映射 | `**kwargs` | 需要显式传参 | 需要显式传参 |

### Swift 可变参数

```swift
func sum(_ numbers: Int...) -> Int {
    numbers.reduce(0, +)
}

sum(1, 2, 3, 4)
```

### Dart 集合展开

```dart
final numbers = [1, 2, 3];

final result = [0, ...numbers, 4];

print(result); // [0, 1, 2, 3, 4]
```

注意：Swift 的 `...` 和 Dart 的 `...` 与 Python 的参数收集机制并不完全等价。

---
## 10. 通的（非装饰器）函数
```
from typing import Any

def wrapper(*args: Any, **kwargs: Any) -> Any:
    print("函数执行前的一些操作")
    result = func(*args, **kwargs)
    print("函数执行后的一些操作")
    return result
```
说明：
*args: Any：表示位置参数是任意类型组成的元组。
**kwargs: Any：表示关键字参数是任意类型组成的字典。
-> Any：表示返回值是任意类型。

如果对参数类型有更具体的要求，可以写得更精确。例如位置参数都是 int、关键字参数值都是 str：
```
def wrapper(*args: int, **kwargs: str) -> None:
    ...
    
    
*args: int 等价于 args: tuple[int, ...]
**kwargs: str 等价于 kwargs: dict[str, str]    
```
这里注解的是单个元素的类型，不是整个 args/kwargs 的类型：





## 11. 总结

| 语法 | 作用 | 结果类型 |
|---|---|---|
| `def func(*args)` | 收集位置参数 | `tuple` |
| `def func(**kwargs)` | 收集关键字参数 | `dict` |
| `func(*items)` | 解包可迭代对象为位置参数 | — |
| `func(**data)` | 解包字典为关键字参数 | — |
| `first, *rest = items` | 收集剩余元素 | `list` |
| `{**a, **b}` | 合并字典 | `dict` |

**重点掌握：**

1. `*args` 收集位置参数，返回元组。
2. `**kwargs` 收集关键字参数，返回字典。
3. 定义时是收集，调用时是解包。
4. `*` 可以限制参数必须以关键字形式传递。
5. 装饰器、继承和动态调用是最常见的应用场景。
