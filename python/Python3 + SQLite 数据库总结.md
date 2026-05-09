# Python3 + SQLite 数据库总结

## 1. SQLite 简介
- **轻量级**：嵌入式关系数据库，无需独立服务器。
- **零配置**：直接以文件形式存储数据库（如 `data.db`）。
- **标准库支持**：Python 标准库自带 `sqlite3` 模块，无需额外安装。

---

## 2. 基本使用流程

```python
import sqlite3

# 1. 连接数据库（文件不存在会自动创建）
conn = sqlite3.connect('example.db')

# 2. 创建游标对象
cursor = conn.cursor()

# 3. 执行 SQL 语句
cursor.execute('CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)')

# 4. 提交事务（对于增、删、改操作必须提交）
conn.commit()

# 5. 关闭连接
conn.close()
```

---

## 3. 数据库连接方式

| 连接方式 | 说明 |
|---------|------|
| `sqlite3.connect('file.db')` | 普通磁盘文件 |
| `sqlite3.connect(':memory:')` | 内存数据库（临时，程序结束即消失） |
| `sqlite3.connect('file.db?mode=ro')` | 只读模式（Python 3.7+，需 URI 模式） |

---

## 4. 执行 SQL 语句的三种方法

| 方法 | 用途 | 示例 |
|------|------|------|
| `execute()` | 执行单条 SQL | `cursor.execute("SELECT * FROM users")` |
| `executemany()` | 批量执行（参数为列表/元组） | `cursor.executemany("INSERT INTO users VALUES (?,?,?)", data_list)` |
| `executescript()` | 执行多条 SQL（以分号分隔） | `cursor.executescript("CREATE TABLE...; INSERT INTO...;")` |

---

## 5. 参数化查询（防止 SQL 注入）

```python
# 正确方式：使用占位符 ?
name = "Alice"
age = 25
cursor.execute("INSERT INTO users (name, age) VALUES (?, ?)", (name, age))

# 命名占位符（字典形式）
cursor.execute("INSERT INTO users (name, age) VALUES (:name, :age)", {"name": "Bob", "age": 30})
```

> ❌ 绝对不要使用字符串拼接 SQL（如 `f"INSERT ... VALUES ('{name}')"`），极易引发 SQL 注入。

---

## 6. 查询数据与获取结果

| 方法 | 说明 |
|------|------|
| `fetchone()` | 获取下一行，返回元组或 `None` |
| `fetchmany(n)` | 获取最多 n 行，返回列表 |
| `fetchall()` | 获取所有剩余行，返回列表 |

```python
cursor.execute("SELECT * FROM users")
row = cursor.fetchone()
while row:
    print(row)
    row = cursor.fetchone()
```

---

## 7. 使用 Row 对象（通过列名访问）

```python
conn.row_factory = sqlite3.Row   # 设置行工厂
cursor = conn.cursor()
cursor.execute("SELECT id, name FROM users")
for row in cursor.fetchall():
    print(row['name'], row['id'])   # 支持列名访问
```

---

## 8. 事务控制

- SQLite 默认**自动开启事务**，但需要**显式提交**（`commit()`）或回滚（`rollback()`）。
- 执行 `execute("BEGIN")` 可手动开始事务。

```python
try:
    cursor.execute("UPDATE users SET age = 26 WHERE name = 'Alice'")
    conn.commit()
except Exception as e:
    conn.rollback()
    print("事务回滚:", e)
```

---

## 9. 上下文管理器（自动提交/回滚）

```python
with sqlite3.connect('example.db') as conn:
    cursor = conn.cursor()
    cursor.execute("INSERT INTO users (name, age) VALUES (?, ?)", ("Tom", 22))
    # 退出 with 块时会自动 commit，异常时自动 rollback
```

---

## 10. 常用技巧与最佳实践

| 技巧 | 代码 |
|------|------|
| 判断表是否存在 | `cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='users'")` |
| 获取最后插入的 rowid | `cursor.lastrowid` |
| 执行 `VACUUM` 压缩数据库 | `conn.execute("VACUUM")` |
| 设置超时（避免锁等待） | `conn = sqlite3.connect('file.db', timeout=10)` |
| 启用外键约束 | `conn.execute("PRAGMA foreign_keys = ON")` |

---

## 11. 完整示例：简单用户管理

```python
import sqlite3

def main():
    with sqlite3.connect('users.db') as conn:
        cursor = conn.cursor()
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                age INTEGER
            )
        ''')
        
        # 插入数据
        cursor.execute("INSERT INTO users (name, age) VALUES (?, ?)", ("Alice", 28))
        cursor.execute("INSERT INTO users (name, age) VALUES (?, ?)", ("Bob", 24))
        
        # 查询数据
        cursor.execute("SELECT * FROM users")
        for row in cursor.fetchall():
            print(row)

if __name__ == "__main__":
    main()
```

---

## 12. 常见错误与解决

| 错误 | 原因 | 解决方法 |
|------|------|----------|
| `sqlite3.OperationalError: no such table` | 表未创建 | 先执行 `CREATE TABLE` |
| `sqlite3.IntegrityError: UNIQUE constraint failed` | 违反唯一约束 | 检查重复数据 |
| `sqlite3.ProgrammingError: Incorrect number of bindings` | 参数数量不匹配 | 检查占位符 `?` 与参数个数 |
| 数据库被锁定 | 多线程/进程写冲突 | 增加 `timeout` 或使用连接池 |

---

## 13. 适用场景

✅ **适合使用 SQLite 的场景**  
- 小型网站、桌面应用、移动端（如 iOS/Android 本地存储）  
- 测试或原型开发  
- 数据量 < 1TB，并发写请求很少  

❌ **不适合的场景**  
- 高并发写入（如银行交易）  
- 需要精细的用户权限管理  
- 多进程频繁写操作  

---
