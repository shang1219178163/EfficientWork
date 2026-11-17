# 编程语言中的生成器（Generator）总结

在编程语言中，**生成器（Generator）** 是一种按需产生值的机制。

函数执行到产出语句时会暂停，把当前值交给调用方，并保留局部变量和执行位置。调用方再次取值时，从暂停处继续。这样不需要事先把全部结果放进列表或数组。数据量很大、结果可能无限，或者调用方只取一部分时，生成器只计算真正用到的那一部分。

## 一、什么是生成器？

生成器把“计算下一个值”推迟到真正取值的时候。

```python
def countdown(n):
    while n > 0:
        yield n
        n -= 1

numbers = countdown(3)
```

`countdown(3)` 此时还没有产出 `3`、`2`、`1`。它返回一个生成器对象，函数体要等遍历或 `next()` 时才往下执行。

生成器通常具有以下特点：

1. **惰性**：用到某个值时才计算它。
2. **可暂停**：产出一个值后停下，现场保留。
3. **按需产生**：一次交出一个值。
4. **一次遍历**：同一条生成器通常只能从头到尾走一遍。
5. **可无限**：可以表示没有终点的序列，只要调用方会停下来。
6. **延迟执行**：调用生成器函数只得到生成器，不会立刻跑完函数体。

> 注意：生成器负责逐个产出值，通常不能按下标访问，也不能直接询问长度。

## 二、生成器函数

含有产出语句的函数，就是生成器函数。Python 里的产出语句是 `yield`。

```python
def countdown(n):
    while n > 0:
        yield n
        n -= 1

for n in countdown(3):
    print(n)

# 3
# 2
# 1
```

调用函数和执行函数体是两件事：

```python
g = countdown(3)   # 得到生成器，循环还没开始
print(g)           # <generator object countdown at ...>
```

函数体里的局部变量会保留到下一次取值。上面的 `n` 在每次暂停后仍然记得当前值，所以下一次能继续减。

## 三、暂停与恢复

生成器的核心是：执行到 `yield` 就暂停，再次取值就从这句之后继续。

```python
def gen():
    print("开始")
    yield 1
    print("继续")
    yield 2
    print("结束")

g = gen()
```

| 操作 | 发生的事 | 得到的值 |
|---|---|---|
| `g = gen()` | 创建生成器，函数体不执行 | 生成器对象 |
| 第一次 `next(g)` | 打印“开始”，停在第一个 `yield` | `1` |
| 第二次 `next(g)` | 打印“继续”，停在第二个 `yield` | `2` |
| 第三次 `next(g)` | 打印“结束”，函数执行完 | 抛出 `StopIteration` |

`for` 循环会自动完成这些步骤：不断取下一个值，遇到结束就停止，不把 `StopIteration` 抛给业务代码。

```python
for n in gen():
    print(n)

# 开始
# 1
# 继续
# 2
# 结束
```

手动取值时，结束需要自己处理：

```python
g = gen()

next(g)  # 1
next(g)  # 2
next(g)  # StopIteration
```

## 四、常见写法

以下以 Python 为例。

### 1. 生成器函数

适合有循环、分支或需要保留中间状态的逻辑。

```python
def squares(n):
    for i in range(n):
        yield i * i

list(squares(5))
# [0, 1, 4, 9, 16]
```

### 2. 生成器表达式

逻辑只是“遍历、转换、筛选”时，可以用圆括号写成生成器表达式。

```python
squares = (i * i for i in range(5))

list(squares)
# [0, 1, 4, 9, 16]
```

它和列表推导式的差别在求值时机：

```python
ready = [i * i for i in range(5)]   # 立刻得到列表
lazy = (i * i for i in range(5))    # 先记住算法，取值时再算
```

生成器表达式是函数的唯一参数时，外层括号可以省略：

```python
sum(i * i for i in range(5))  # 30
```

### 3. 委托：yield from

`yield from` 把另一个可迭代对象里的值依次产出，省掉手写内层循环。

```python
def chain(a, b):
    yield from a
    yield from b

list(chain([1, 2], [3, 4]))
# [1, 2, 3, 4]
```

等价写法：

```python
def chain(a, b):
    for item in a:
        yield item
    for item in b:
        yield item
```

### 4. 无限序列

生成器可以没有终点。调用方取够之后停下来即可。

```python
def naturals():
    n = 1
    while True:
        yield n
        n += 1

for n in naturals():
    if n > 3:
        break
    print(n)

# 1
# 2
# 3
```

不要对这种生成器直接调用 `list()`，它会一直取值，停不下来。

## 五、取值之后的状态

生成器会记住自己走到哪里。走完一遍之后，它就结束了，再取值不会从头开始。

```python
g = (n for n in [10, 20, 30])

list(g)  # [10, 20, 30]
list(g)  # []
```

要再来一遍，就再调用一次生成器函数，或再写一次生成器表达式。

生成器也不提供序列那种按下标访问和取长度的能力：

```python
g = (n for n in [10, 20, 30])

g[0]    # TypeError
len(g)  # TypeError
```

需要下标、切片或多次遍历时，先把它收成列表：

```python
nums = list(n for n in [10, 20, 30])

nums[0]      # 10
len(nums)    # 3
```

部分语言还允许把值或异常送回暂停中的生成器。Python 用 `send()`，JavaScript 用 `next(value)`。日常逐个取值时，用循环即可。

## 六、生成器与序列、可迭代对象、迭代器的区别

这几个概念经常叠在一起。

| 概念 | 英文 | 元素何时准备好 | 能否按下标访问 | 能否多次遍历 |
|---|---|---|---|---|
| 序列 | Sequence | 通常已经排好 | 通常可以 | 通常可以 |
| 可迭代对象 | Iterable | 不一定 | 不一定 | 不一定 |
| 迭代器 | Iterator | 每次取下一个 | 通常不可以 | 通常只能一次 |
| 生成器 | Generator | 每次取时才计算 | 不可以 | 只能一次 |

Python 示例：

```python
nums = [10, 20, 30]

# list 是序列，也是可迭代对象
iterator = iter(nums)
next(iterator)  # 10

# 生成器本身就是迭代器
g = (n * 2 for n in nums)
next(g)  # 20
```

核心关系：

- **Sequence（序列）**：元素按位置排好，通常能索引、取长度、重复遍历。
- **Iterable（可迭代对象）**：能够提供一个迭代器。`list` 可以，`set` 也可以，生成器也可以。
- **Iterator（迭代器）**：记住当前位置，每次交出下一个元素。
- **Generator（生成器）**：用暂停执行来实现的迭代器。产出逻辑写在函数或表达式里，状态由语言保存。

> 生成器一定是迭代器，也是可迭代对象。它一般不是序列：没有随机访问，也不能反复遍历。

## 七、不同编程语言中的生成器

这里只比较 Python、JavaScript、Dart、Swift、Java。

Python、JavaScript、Dart 用 `yield` 暂停并交出一个值。Swift 和 Java 没有这种生成器语句，序列里的下一个值由迭代器返回。

| 语言 | 常见写法 | 说明 |
|---|---|---|
| Python | `yield` | 生成器函数或生成器表达式 |
| JavaScript | `function*`、`yield` | `next()` 取出下一个值 |
| Dart | `sync*`、`yield` | 同步生成器返回 `Iterable` |
| Swift | `next()` | Swift 3 前协议名为 `GeneratorType`；`yield` 用于访问器协程 |
| Java | `Iterator`、`Stream` | 没有生成器语句；`yield` 只用于 `switch` 表达式 |

下面都表示依次产出 `1`、`2`、`3`。

**Python**

```python
def numbers():
    yield 1
    yield 2
    yield 3
```

**JavaScript**

```javascript
function* numbers() {
  yield 1;
  yield 2;
  yield 3;
}
```

**Dart**

```dart
Iterable<int> numbers() sync* {
  yield 1;
  yield 2;
  yield 3;
}
```

Dart 的异步版本使用 `async*`，产出的是 `Stream`，同样用 `yield` 送出值。

**Swift**

Swift 里说的生成器，指标准库里的生成器协议。Swift 3 之前协议名是 `GeneratorType`，Swift 3（SE-0006）起改名为 `IteratorProtocol`。`generate()` 改为 `makeIterator()`，`AnyGenerator` 改为 `AnyIterator`。

序列要往外给元素，写的是 `next()`。`yield` 用在另一类协程上，两者不要当成同一种语法。

### 1. yield 关键字

Swift 的 `yield` 写在访问器协程里，用来暂停访问器，把一个值借给正在读或改这个属性的代码。这次访问结束，再从 `yield` 后面继续，用来做清理。它一次只交出这一个值，用来避免拷贝。

正式语法是 `yielding borrow` 和 `yielding mutate`（SE-0474）。更早的内部写法是 `_read` 和 `_modify`。

```swift
struct Token {
    var text: String
}

struct Box {
    var token: Token

    var property: Token {
        _read {
            yield token
        }
    }
}

let box = Box(token: Token(text: "hello"))
print(box.property.text)  // hello
```

> 注意：SE-0474 的公开语法 `yielding borrow` / `yielding mutate` 还没在正式版 Swift 里开放，Swift 6.5 仍在实验特性 `CoroutineAccessors` 后面。上面的 `_read` 是编译器目前接受的内部写法。
>
> 这个 `yield` 不给 `for-in` 逐个提供元素。用它写 Python 那种生成器函数，Swift 没有对应语法。

### 2. next()

`IteratorProtocol` 只有一个要求：给出下一个元素，没有更多元素时返回 `nil`。

```swift
mutating func next() -> Element?
```

`for-in` 会先调用序列的 `makeIterator()`，再反复调用 `next()`，直到得到 `nil`。

依次产出 `1`、`2`、`3`：

```swift
struct Numbers: Sequence, IteratorProtocol {
    var nextValue = 1

    mutating func next() -> Int? {
        guard nextValue <= 3 else { return nil }
        let current = nextValue
        nextValue += 1
        return current
    }
}

var iterator = Numbers().makeIterator()

iterator.next()  // Optional(1)
iterator.next()  // Optional(2)
iterator.next()  // Optional(3)
iterator.next()  // nil
```

也可以把“下一次返回什么”写成闭包，由 `AnyIterator` 当成 `next()`：

```swift
func numbers() -> AnyIterator<Int> {
    var n = 0
    return AnyIterator {
        n += 1
        return n <= 3 ? n : nil
    }
}
```

**Java**

Java 没有生成器语句。语言里的 `yield` 用在 `switch` 表达式中，表示这个分支的结果，不会暂停函数去产出序列。

惰性整数序列可以写成 `Stream`：

```java
Stream<Integer> numbers = Stream.iterate(1, n -> n + 1).limit(3);
```

也可以自己实现迭代器，`next()` 返回下一个元素，`hasNext()` 表示还有没有：

```java
Iterator<Integer> numbers = new Iterator<>() {
    private int n = 1;

    public boolean hasNext() {
        return n <= 3;
    }

    public Integer next() {
        return n++;
    }
};
```

把子序列的值继续产出时，这五种语言的写法如下：

| 语言 | 委托给另一个序列 |
|---|---|
| Python | `yield from other` |
| JavaScript | `yield* other` |
| Dart | `yield* other` |
| Swift | 在 `next()` 里调用另一个迭代器的 `next()` |
| Java | `Stream.flatMap` 展开子流，或在 `next()` 里转去读另一个迭代器 |

## 八、适合使用生成器的场景

1. **结果很多，只需要逐个处理。** 读大文件、扫描大量记录时，不必先装进一个完整列表。
2. **长度事先不知道，或者没有终点。** 外部信号、用户输入、自然数都可以一边产生一边消费。
3. **处理可以分成几步。** 上一步产出的值直接交给下一步，中间不必落地成列表。

```python
def numbers():
    for n in range(1, 6):
        yield n

def squares(items):
    for n in items:
        yield n * n

list(squares(numbers()))
# [1, 4, 9, 16, 25]
```

需要下标、切片、长度或多次遍历时，生成器不合适，应使用列表这类序列。

## 九、总结：需要掌握的核心概念

| 概念 | 英文 | 关键词 |
|---|---|---|
| 生成器 | Generator | 按需产出值 |
| 生成器函数 | Generator Function | 含有产出语句的函数 |
| 生成器表达式 | Generator Expression | 圆括号写出的惰性计算 |
| 产出 | Yield | 暂停并把一个值交出去 |
| 惰性求值 | Lazy Evaluation | 用到时才计算 |
| 暂停与恢复 | Suspend / Resume | 保留现场，下次继续 |
| 迭代器 | Iterator | 每次取下一个元素 |
| 可迭代对象 | Iterable | 能够被遍历 |
| 序列 | Sequence | 已按位置排好的元素 |
| 委托 | Delegation | 把另一个序列的值继续产出 |

### 学习建议

建议在理解序列之后，按下面的顺序掌握生成器：

1. `yield` 如何暂停、恢复，以及局部变量为什么还在。
2. 生成器函数和生成器表达式。
3. 生成器与 Sequence、Iterable、Iterator 的差别。
4. 一次遍历、不能索引、`list()` 会立刻取完。
5. `yield from`，以及 JavaScript、Dart 的 `yield*`。Swift 的序列看 `IteratorProtocol.next()`，Java 用 `Iterator` 或 `Stream`。

**最重要的区别：序列保存已经排好的元素，生成器在每次取值时才把下一个元素算出来。**
