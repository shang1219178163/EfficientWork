# Python 作用域（Scope）总结

Python 作用域是指：**变量、函数等名称在程序中的可访问范围。**

Python 采用 **LEGB 规则** 查找变量，这是理解 Python 作用域最重要的知识点。

## 一、LEGB 作用域规则

LEGB 是四种作用域的首字母缩写，Python 按照以下顺序查找变量：

| 顺序 | 名称 | 含义 | 说明 |
|---|---|---|---|
| L | Local | 局部作用域 | 当前函数内部定义的变量 |
| E | Enclosing | 嵌套作用域 | 外层函数中的变量 |
| G | Global | 全局作用域 | 当前模块顶层定义的变量 |
| B | Built-in | 内置作用域 | Python 内置名称，如 `print`、`len`、`str` |

查找顺序：**L → E → G → B**，从当前局部作用域逐层向外查找。

### 1. Local：局部作用域

在函数内部定义的变量，通常只能在当前函数中访问。

```python
def test():
    name = "张三"
    print(name)

test()

# print(name)  # NameError
```

### 2. Enclosing：嵌套作用域

在外层函数中定义的变量，可以被内层函数访问。

```python
def outer():
    name = "张三"

    def inner():
        print(name)

    inner()

outer()
```

`inner()` 可以访问 `outer()` 中的 `name`。

### 3. Global：全局作用域

在模块顶层定义的变量，可以在模块内的函数中读取。

```python
name = "张三"

def test():
    print(name)

test()
```

### 4. Built-in：内置作用域

Python 自带的内置名称，不需要额外定义。

```python
numbers = [1, 2, 3]

print(len(numbers))
print(str(123))
print(max(numbers))
```

`len`、`str`、`max` 都属于 Built-in。

---

## 二、局部变量与全局变量

### 1. 局部变量（Local Variable）

在函数内部定义的变量。

```python
count = 100

def test():
    count = 10
    print(count)

test()       # 10
print(count) # 100
```

函数内部的 `count` 和外部的 `count` 是两个不同的变量。

### 2. 全局变量（Global Variable）

在模块顶层定义的变量。

函数可以直接读取全局变量：

```python
count = 100

def test():
    print(count)

test()  # 100
```

但是，函数内部直接赋值会创建局部变量：

```python
count = 100

def test():
    count = 10
    print(count)

test()       # 10
print(count) # 100
```

### 3. 使用 global 修改全局变量

如果需要在函数内部重新绑定全局变量，使用 `global`。

```python
count = 100

def test():
    global count
    count = 10

test()

print(count)  # 10
```

`global` 声明某个名称引用当前模块的全局变量，而不是局部变量。

---

## 三、nonlocal：修改外层函数变量

`nonlocal` 用于嵌套函数，修改最近一层外层函数中的变量。

```python
def outer():
    count = 100

    def inner():
        nonlocal count
        count = 10

    inner()
    print(count)

outer()  # 10
```

### global 与 nonlocal 对比

```python
count = 100

def outer():
    count = 200

    def inner():
        global count
        count = 300

    inner()
    print(count)  # 200

outer()

print(count)  # 300
```

`global` 修改模块变量，不会修改 `outer()` 的局部变量。

| 关键字 | 修改对象 | 使用场景 |
|---|---|---|
| 无关键字 | 当前函数的局部变量 | 函数内部赋值 |
| `global` | 模块全局变量 | 函数修改全局变量 |
| `nonlocal` | 最近一层外层函数变量 | 嵌套函数修改外层变量 |

---

## 四、Python 类作用域

类作用域不属于 LEGB 中的独立一层。类体执行时会创建自己的命名空间，但方法中的普通名称查找不会把类命名空间作为 Enclosing 作用域。

### 1. 类变量

定义在类内部、方法外部的变量。

```python
class User:
    name = "张三"

    def show(self):
        print(self.name)

user = User()
user.show()  # 张三
```

### 2. 实例变量

通常通过 `self` 定义，属于具体实例。

```python
class User:
    def __init__(self, name):
        self.name = name

user1 = User("张三")
user2 = User("李四")

print(user1.name)  # 张三
print(user2.name)  # 李四
```

### 3. 类变量与实例变量对比

| 对比 | 类变量 | 实例变量 |
|---|---|---|
| 定义位置 | 类内部、方法外部 | 通常在 `__init__` 中 |
| 访问方式 | `User.name` | `user.name` |
| 共享性 | 实例通常共享同一个类属性 | 每个实例可以有独立属性 |
| 生命周期 | 随类存在 | 随实例存在 |

注意：类中的方法不会因为定义在类内部，就自动将类变量作为普通变量进行 LEGB 查找。

```python
class User:
    name = "张三"

    def show(self):
        print(name)  # NameError（除非外部全局作用域另有 name）

    def show2(self):
        print(self.name)  # 张三

    def show3(self):
        print(User.name)  # 张三
```

---

## 五、变量赋值与作用域的常见陷阱

### 1. 局部变量会影响同名全局变量的读取

```python
count = 100

def test():
    print(count)
    count = 10

test()
```

结果：

```text
UnboundLocalError
```

原因：Python 在编译函数时，会根据赋值语句将 `count` 判定为局部变量。因此，前面的 `print(count)` 尝试读取尚未赋值的局部变量，而不是读取全局变量。

解决方式：

```python
count = 100

def test():
    global count
    print(count)
    count = 10
```

### 2. 修改列表对象不一定需要 global

```python
numbers = [1, 2, 3]

def test():
    numbers.append(4)

test()

print(numbers)  # [1, 2, 3, 4]
```

这里不需要 `global`，因为 `append()` 修改的是列表对象本身，并没有重新给 `numbers` 赋值。

但如果重新绑定变量：

```python
numbers = [1, 2, 3]

def test():
    global numbers
    numbers = [4, 5, 6]
```

就需要 `global`。

**记住：修改对象与重新绑定变量是两回事。**

---

## 六、作用域相关函数与关键字

| 名称 | 作用 | 示例 |
|---|---|---|
| `global` | 声明使用模块全局变量 | `global count` |
| `nonlocal` | 声明使用外层函数变量 | `nonlocal count` |
| `locals()` | 获取当前局部命名空间的字典 | `locals()` |
| `globals()` | 获取当前模块全局命名空间的字典 | `globals()` |
| `vars()` | 获取对象的 `__dict__`；无参数时类似 `locals()` | `vars(obj)` |

示例：

```python
name = "全局变量"

def test():
    age = 18

    print(locals())
    print(globals()["name"])

test()
```

---

## 七、LEGB 规则完整示例

```python
name = "Global"

def outer():
    name = "Enclosing"

    def inner():
        name = "Local"
        print(name)

    inner()

outer()
```

输出：

```text
Local
```

逐层移除同名变量后，查找结果如下：

| `inner` 中 | `outer` 中 | 全局中 | 查找结果 |
|---|---|---|---|
| Local | Enclosing | Global | Local |
| 不存在 | Enclosing | Global | Enclosing |
| 不存在 | 不存在 | Global | Global |
| 不存在 | 不存在 | 不存在 | Built-in（仅当名称存在于内置命名空间时） |

---

## 八、知识点速查

### 1. LEGB 作用域

- L：Local（局部）
- E：Enclosing（嵌套）
- G：Global（全局）
- B：Built-in（内置）

### 2. 常见变量类型

- 局部变量
- 全局变量
- 类变量
- 实例变量

### 3. 作用域关键字

- `global`
- `nonlocal`

### 4. 命名空间相关函数

- `locals()`
- `globals()`
- `vars()`

## 九、学习建议

重点掌握以下三个知识点：

1. **LEGB**：理解 Python 如何查找变量。
2. **global / nonlocal**：理解如何修改不同作用域中的变量。
3. **变量赋值规则**：理解为什么有时会出现 `UnboundLocalError`。

掌握这些内容后，理解 Python 函数、闭包、装饰器和类会更加容易。
