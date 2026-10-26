# Python 3.13 推导式总结

> 推导式（Comprehensions）用于通过简洁的语法，从可迭代对象创建列表、集合或字典。生成器表达式与推导式语法相近，但会惰性地产生数据。

## 1. 推导式类型速览

| 类型 | 语法 | 返回类型 | 特点 |
|---|---|---|---|
| 列表推导式 | `[expr for x in iterable]` | `list` | 保留顺序与重复元素，立即生成列表 |
| 集合推导式 | `{expr for x in iterable}` | `set` | 自动去重，不保证展示顺序 |
| 字典推导式 | `{key: value for x in iterable}` | `dict` | 根据键值表达式构建字典，重复键会覆盖 |
| 生成器表达式 | `(expr for x in iterable)` | `generator` | 惰性生成，按需迭代，通常更节省内存 |

## 2. 通用语法

基本形式：

```python
[表达式 for 变量 in 可迭代对象]
{表达式 for 变量 in 可迭代对象}
{键表达式: 值表达式 for 变量 in 可迭代对象}
(表达式 for 变量 in 可迭代对象)
```

加入筛选条件：

```python
[表达式 for 变量 in 可迭代对象 if 条件]
```

加入条件转换：

```python
[值1 if 条件 else 值2 for 变量 in 可迭代对象]
```

记忆方法：

- `for`：遍历元素。
- `if` 放在 `for` 后面：筛选元素。
- `if ... else` 放在表达式中：决定每个元素转换成什么值。
- 多个 `for`：形成嵌套循环。

## 3. 列表推导式（List Comprehension）

### 3.1 转换元素

```python
numbers = [1, 2, 3, 4]
squares = [n ** 2 for n in numbers]
# [1, 4, 9, 16]
```

### 3.2 筛选元素

```python
evens = [n for n in range(10) if n % 2 == 0]
# [0, 2, 4, 6, 8]
```

### 3.3 条件转换

```python
labels = ["偶数" if n % 2 == 0 else "奇数" for n in range(5)]
# ['偶数', '奇数', '偶数', '奇数', '偶数']
```

### 3.4 多层循环与展平

```python
pairs = [(x, y) for x in [1, 2] for y in ["a", "b"]]
# [(1, 'a'), (1, 'b'), (2, 'a'), (2, 'b')]

matrix = [[1, 2], [3, 4], [5, 6]]
flat = [n for row in matrix for n in row]
# [1, 2, 3, 4, 5, 6]
```

多个 `for` 的执行顺序与普通嵌套循环一致：先执行最左侧的 `for`，再执行后面的 `for`。

## 4. 集合推导式（Set Comprehension）

使用 `{}`，但没有 `key: value` 键值结构。

```python
numbers = [1, 2, 2, 3, 3, 3]
unique_squares = {n ** 2 for n in numbers}
# {1, 4, 9}
```

筛选和转换也可以组合：

```python
words = ["apple", "pear", "apricot", "plum"]
a_words = {word.upper() for word in words if word.startswith("a")}
# {'APPLE', 'APRICOT'}
```

注意：

- 集合自动去重。
- 集合不保证按插入顺序迭代。
- 集合元素必须可哈希，例如整数、字符串、元组（其中成员也可哈希）。
- 列表、字典等可变对象不能直接作为集合元素。

## 5. 字典推导式（Dictionary Comprehension）

### 5.1 从可迭代对象创建字典

```python
numbers = [1, 2, 3]
squares = {n: n ** 2 for n in numbers}
# {1: 1, 2: 4, 3: 9}
```

### 5.2 筛选键值对

```python
scores = {"Ada": 92, "Lin": 58, "Sam": 81}
passed = {name: score for name, score in scores.items() if score >= 60}
# {'Ada': 92, 'Sam': 81}
```

### 5.3 转换键值

```python
source = {"a": 1, "b": 2}
reversed_dict = {value: key for key, value in source.items()}
# {1: 'a', 2: 'b'}
```

注意：如果多个元素生成相同的键，后面的值会覆盖前面的值。

## 6. 生成器表达式（Generator Expression）

生成器表达式用圆括号，按需生成值，而不是一次性构造完整列表。

```python
squares = (n ** 2 for n in range(5))

print(next(squares))  # 0
print(next(squares))  # 1
print(list(squares))  # [4, 9, 16]
```

适合数据量大、只需顺序处理一次的情况：

```python
total = sum(n * n for n in range(1_000_000))
```

与列表推导式相比：

```python
values = [n * 2 for n in range(1000)]  # 立即创建完整列表
values = (n * 2 for n in range(1000))  # 创建生成器，按需产生
```

生成器只能沿迭代方向消费；消费完后通常不能直接重新从头读取。需要反复访问结果时，考虑保存为列表。

## 7. 多重 `for`、多个 `if` 和条件表达式

### 多重 `for`

```python
[(x, y) for x in range(2) for y in range(3)]
# [(0, 0), (0, 1), (0, 2), (1, 0), (1, 1), (1, 2)]
```

### 多个筛选条件

```python
[n for n in range(30) if n % 2 == 0 if n % 3 == 0]
# 同时满足两个条件，相当于 and
```

也可写成：

```python
[n for n in range(30) if n % 2 == 0 and n % 3 == 0]
```

### 条件表达式与筛选的区别

```python
[n for n in range(5) if n > 2]
# [3, 4] —— 不符合条件的元素被排除

[n if n > 2 else 0 for n in range(5)]
# [0, 0, 0, 3, 4] —— 每个元素都会产生一个结果
```

## 8. 推导式变量作用域

Python 3 中，推导式的循环变量不会泄漏到外部作用域：

```python
x = 100
result = [x for x in range(3)]

print(result)  # [0, 1, 2]
print(x)       # 100
```

## 9. 常见实际场景

### 字符串清洗

```python
raw = [" Alice ", "", "BOB ", " Chen"]
names = [item.strip().lower() for item in raw if item.strip()]
# ['alice', 'bob', 'chen']
```

### 从字典列表提取字段

```python
users = [
    {"name": "Ada", "age": 30},
    {"name": "Lin", "age": 17},
    {"name": "Sam", "age": 25},
]

adult_names = [user["name"] for user in users if user["age"] >= 18]
```

### 字符计数映射

```python
words = ["apple", "pear", "plum"]
lengths = {word: len(word) for word in words}
# {'apple': 5, 'pear': 4, 'plum': 4}
```

注意：上例中若有重复单词，字典只保留一个对应键。

### 构造二维列表

```python
rows, cols = 2, 3
matrix = [[0 for _ in range(cols)] for _ in range(rows)]
# [[0, 0, 0], [0, 0, 0]]
```

避免用 `[[0] * cols] * rows` 创建需要独立修改每行的二维列表，因为每行会引用同一个内部列表。

## 10. 选择哪种写法？

| 目标 | 推荐 |
|---|---|
| 需要有序列表，允许重复 | 列表推导式 |
| 需要去重 | 集合推导式 |
| 需要键值映射 | 字典推导式 |
| 数据量大，逐个消费即可 | 生成器表达式 |
| 逻辑复杂、包含副作用或异常处理 | 普通 `for` 循环 |

## 11. 可读性与性能最佳实践

1. 推导式优先用于简单转换、筛选和组合。
2. 嵌套层数过多时，改用普通循环，让逻辑更容易阅读。
3. 避免在推导式里执行写文件、修改全局状态等副作用操作。
4. 大数据量且不需要保存所有结果时，优先考虑生成器表达式。
5. 不要为了减少行数而牺牲可读性。
6. 生成字典时注意重复键覆盖；生成集合时注意去重和元素可哈希要求。
7. 列表推导式会创建新列表，不会自动去重。

## 12. 速查表

| 需求 | 写法 |
|---|---|
| 转换列表 | `[f(x) for x in items]` |
| 筛选元素 | `[x for x in items if condition]` |
| 筛选后转换 | `[f(x) for x in items if condition]` |
| 条件转换 | `[a if condition else b for x in items]` |
| 集合去重 | `{f(x) for x in items}` |
| 创建字典 | `{key(x): value(x) for x in items}` |
| 筛选字典 | `{k: v for k, v in data.items() if condition}` |
| 展平二维列表 | `[x for row in matrix for x in row]` |
| 惰性生成 | `(f(x) for x in items)` |

## 13. 练习题

1. 从 `range(1, 21)` 中找出能被 3 整除的数。
2. 将 `[" Apple ", "BANANA", " pear "]` 清洗为小写且无首尾空格的列表。
3. 对 `[1, 2, 2, 3, 3]` 生成去重后的平方集合。
4. 将 `["a", "bb", "ccc"]` 转换为 `{字符串: 长度}` 的字典。
5. 用生成器表达式计算 `1` 到 `100000` 的平方和。

参考答案：

```python
# 1
[n for n in range(1, 21) if n % 3 == 0]

# 2
[s.strip().lower() for s in [" Apple ", "BANANA", " pear "]]

# 3
{n ** 2 for n in [1, 2, 2, 3, 3]}

# 4
{word: len(word) for word in ["a", "bb", "ccc"]}

# 5
sum(n * n for n in range(1, 100001))
```

---

**核心记忆：**

- `[]` 列表：保留重复、立即创建。
- `{}` 集合：自动去重。
- `{key: value}` 字典：构建键值映射。
- `()` 生成器表达式：按需产生结果。
- `for` 负责遍历，`if` 负责筛选，`if ... else` 负责条件转换。
