# Swift、Dart、Python 元组（Tuple）对比

Swift、Dart、Python 都支持类似元组的数据结构，但三种语言在定义方式、访问方式、命名字段、可变性和类型系统方面存在区别。

## 一、基本定义

### 1. Swift：Tuple（元组）

Swift 原生支持元组，可以组合多个不同类型的数据。

```swift
// 位置元组
var person = ("张三", 25, 1.75)

print(person.0)  // 张三
print(person.1)  // 25

// 命名元组
var user = (name: "张三", age: 25, height: 1.75)

print(user.name)  // 张三
print(user.age)   // 25

// 修改元素
user.age = 26
```

特点：

- 支持不同类型的数据。
- 支持位置访问和名称访问。
- 支持命名元组。
- 使用 `var` 声明时可以修改元素。
- 使用 `let` 声明时不能修改元素。

### 2. Dart：Record（记录）

Dart 从 3.0 开始支持 Record，可以理解为 Dart 版本的元组。

```dart
// 位置 Record
var person = ("张三", 25, 1.75);

print(person.$1); // 张三
print(person.$2); // 25

// 命名 Record
var user = (name: "张三", age: 25, height: 1.75);

print(user.name); // 张三
print(user.age);  // 25
```

特点：

- 支持不同类型的数据。
- 支持位置字段和命名字段。
- 通过 `$1`、`$2` 访问位置字段。
- 通过名称访问命名字段。
- Record 字段不可变。
- 支持结构化相等比较。

### 3. Python：Tuple（元组）

Python 原生支持元组，可以存储不同类型的数据。

```python
# 创建元组
person = ("张三", 25, 1.75)

print(person[0])  # 张三
print(person[1])  # 25

# 不允许修改元素
# person[1] = 26  # TypeError
```

特点：

- 支持不同类型的数据。
- 通过索引访问元素。
- 普通 tuple 不支持命名字段。
- 元素不可重新赋值。
- 允许重复元素。
- 支持解包操作。

---

## 二、核心区别对比

| 对比维度 | Swift Tuple | Dart Record | Python tuple |
|---|---|---|---|
| 引入方式 | 原生支持 | Dart 3.0 引入 | 原生支持 |
| 是否有序 | 是 | 是 | 是 |
| 是否允许重复 | 是 | 是 | 是 |
| 是否支持不同类型 | 是 | 是 | 是 |
| 是否支持命名字段 | 是 | 是 | 否（普通 tuple） |
| 位置访问 | `.0`、`.1` | `.$1`、`.$2` | `[0]`、`[1]` |
| 命名访问 | `.name` | `.name` | 不支持（普通 tuple） |
| 是否可变 | 取决于 `let` / `var` | 字段不可变 | 元素不可重新赋值 |
| 支持解包 | 是 | 是 | 是 |
| 支持类型注解 | 是 | 是 | 是 |
| 支持结构化相等 | 是 | 是 | 是 |

## 三、可变性区别

这是三种语言非常值得注意的区别。

### Swift：可以修改（取决于变量声明）

```swift
var data = ("张三", 25)
data.1 = 26

let info = ("李四", 30)
// info.1 = 31 // 编译错误
```

### Dart：Record 字段不可修改

```dart
var data = ("张三", 25);

// data.$2 = 26; // 编译错误
```

即使使用 `var` 声明 Record，也不能修改 Record 的字段。`var` 只是允许变量重新绑定到另一个 Record。

```dart
var data = ("张三", 25);

data = ("李四", 30); // 允许重新赋值
```

### Python：元素不可重新赋值

```python
data = ("张三", 25)

# data[1] = 26  # TypeError

# 可以重新赋值整个变量
data = ("李四", 30)
```

注意：Python 元组不可变的是元素引用，不代表内部对象一定不可变。

```python
data = ("张三", [1, 2, 3])

data[1].append(4)  # 允许修改内部列表

print(data)
# ('张三', [1, 2, 3, 4])
```

---

## 四、命名字段对比

三种语言在命名字段上的差异尤其明显。

### Swift：支持命名元组

```swift
let user = (name: "张三", age: 25)
print(user.name)
```

### Dart：支持命名 Record 字段

```dart
final user = (name: "张三", age: 25)
print(user.name)
```

### Python：普通 tuple 不支持命名字段

```python
user = ("张三", 25)
print(user[0])
```

Python 如果希望通过名称访问，可以使用 `NamedTuple`：

```python
from collections import namedtuple

# 定义命名元组类型
Person = namedtuple("Person", ["name", "age", "height"])

# 创建对象
person = Person("张三", 25, 1.75)

# 通过索引访问
print(person[0])      # 张三

# 通过属性名称访问
print(person.name)    # 张三
print(person.age)     # 25

# 解包
name, age, height = person
```

---

## 五、解包操作对比

三种语言都支持解包（Unpacking / Destructuring）。

### Swift

```swift
let person = ("张三", 25)

let (name, age) = person

print(name)
print(age)
```

### Dart

```dart
final person = ("张三", 25);

final (name, age) = person;

print(name);
print(age);
```

### Python

```python
person = ("张三", 25)

name, age = person

print(name)
print(age)
```

---

## 六、实际开发中如何选择？

| 使用场景 | Swift | Dart | Python |
|---|---|---|---|
| 临时组合多个返回值 | Tuple | Record | tuple |
| 有明确字段名称的数据 | 命名 Tuple | 命名 Record | NamedTuple / dataclass |
| 需要修改数据 | 自定义 struct | 自定义 class | dataclass / class |
| 固定不可变数据 | `let` Tuple | Record | tuple |

## 七、最终总结

### Swift

原生 Tuple，支持位置字段、命名字段，可以通过 `var` / `let` 控制是否允许修改元素。

### Dart

Record，支持位置字段、命名字段，字段不可修改，但变量可以重新赋值。

### Python

tuple，支持位置索引和解包，元素不可重新赋值；需要命名字段时可以使用 `NamedTuple`。

### 一句话记忆

- **Swift Tuple**：可以命名，可以修改（取决于 `var` / `let`）。
- **Dart Record**：可以命名，字段不可修改。
- **Python tuple**：普通元组通过索引访问，元素不可重新赋值。

> 注意：三种语言的元组都可以组合多个值，但它们的类型系统与底层实现并不相同。
