# **Python通过数据库表生成 ORM 类**

通过数据库中已经存在的表，反向生成 Python ORM 类，通常称为：

- **Database Reflection（数据库反射）**：读取数据库已有的表结构、字段、主键、索引等元信息。
- **ORM Reverse Engineering（ORM 逆向工程）**：根据已有数据库结构生成 ORM 模型代码。
- **Automap（自动映射）**：SQLAlchemy 自动将数据库表映射为 ORM 类。

这与先编写 Python ORM 类，再通过 ORM 创建数据库表（Code First）正好相反。

## **1. 两种 ORM 建模方式**

Python → 数据库：先定义 ORM 类，再生成数据库表。

数据库 → Python： Database First 生成 ORM 类。

## **2. 方式一：SQLAlchemy Automap 自动映射**

SQLAlchemy 提供了 `automap`，可以根据数据库中已有的表，自动生成 ORM 映射类，不需要手动定义每个模型。

### **① 数据库已有表**

例如 MySQL 已经存在 `users` 表：

```python
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    age INT,
    email VARCHAR(100)
);
```

### **② 自动生成 ORM 映射**

```python
from sqlalchemy import create_engine
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session

# 数据库连接
engine = create_engine(
    "mysql+pymysql://root:123456@localhost:3306/test_db",
    echo=True
)

# 创建自动映射基类
Base = automap_base()

# 读取数据库表并自动生成映射
Base.prepare(autoload_with=engine)

# 获取自动生成的 ORM 类
User = Base.classes.users

# 创建实例
user = User(
    name="张三",
    age=25,
    email="zhangsan@example.com"
)

# 查询
with Session(engine) as session:
    result = session.query(User).first()

    if result:
        print(result.id)
        print(result.name)
        print(result.age)
```

这里最核心的代码是：

```python
Base.prepare(autoload_with=engine)
```

它会：

1. 连接数据库。
2. 获取数据库中已有的表结构。
3. 读取字段、主键等元信息。
4. 自动建立数据库表与 ORM 类的映射关系。
5. 通过 `Base.classes` 获取对应 ORM 类。

例如：

```python
User = Base.classes.users
```

此时 `User` 已经可以作为 ORM 类使用。

无需手动编写 User 类，就能直接操作数据库中已有的 users 表。

## **3. 方式二：使用 Reflection 手动反射表结构**

如果你希望读取数据库表结构，但不一定需要自动生成 ORM 类，可以使用 SQLAlchemy 的 `Table` 反射机制。

### **读取表结构**

```python
from sqlalchemy import create_engine, MetaData, Table

engine = create_engine(
    "mysql+pymysql://root:123456@localhost:3306/test_db"
)

metadata = MetaData()

users_table = Table(
    "users",
    metadata,
    autoload_with=engine
)
```

此时 `users_table` 就包含数据库中 `users` 表的结构信息。

例如：

```python
print(users_table.columns.keys())
```

输出：

```python
['id', 'name', 'age', 'email']
```

访问字段：

```python
print(users_table.c.id)print(users_table.c.name)print(users_table.c.age)
```

查询数据：

```python
from sqlalchemy import select

stmt = select(users_table)

with engine.connect() as conn:
    result = conn.execute(stmt)

    for row in result:
        print(row._mapping)
```

这种方式更偏向于 **表结构反射和 SQL 操作**，而不是生成完整的 ORM 类。

## **4. 方式三：通过工具生成真正的 ORM 源代码**

如果你希望数据库中的表直接生成 `.py` 文件，例如：

```python
models/
├── user.py
├── order.py
├── product.py
└── ...
```

而不是在运行时动态生成 ORM 类，那么推荐使用代码生成工具。

### **sqlacodegen**

适合 Database First 项目：生成可编辑、可维护的 SQLAlchemy ORM 源码。

安装：

```
uv add sqlacodegen
```

或者：

```
pip install sqlacodegen
```

生成模型：

```python
sqlacodegen "mysql+pymysql://root:123456@localhost:3306/test_db" --outfile models.py
```

生成的代码可能类似：

```python
from sqlalchemy.orm import DeclarativeBase, mapped_column
from sqlalchemy import Integer, String


class Base(DeclarativeBase):
    pass


class Users(Base):
    __tablename__ = "users"

    id = mapped_column(Integer, primary_key=True)
    name = mapped_column(String(50), nullable=False)
    age = mapped_column(Integer)
    email = mapped_column(String(100))
```

这样就把数据库表转换成了实际的 Python ORM 源代码。

生成后，你可以：

- 修改模型代码。
- 添加类型注解。
- 添加业务方法。
- 添加关联关系。
- 直接将模型纳入项目管理。

## **5. 三种方案对比**

| 方案          | 实现方式     | 是否生成 `.py` 源码 | 适用场景         |
| ----------- | -------- | ------------- | ------------ |
| Automap     | 运行时动态映射  | ❌             | 快速操作已有数据库    |
| Reflection  | 读取表结构元信息 | ❌             | 动态 SQL、数据库工具 |
| sqlacodegen | 逆向生成代码   | ✅             | 正式项目、长期维护    |

**我的建议**

如果你正在使用 FastAPI + Pydantic + SQLAlchemy，并且希望数据库表直接转换为可维护的 ORM 模型，优先使用 `sqlacodegen` 生成源码。

生成后再结合 Pydantic 定义 API 请求模型和响应模型，保持数据库层、业务层与 API 层职责清晰。

## **6. 推荐的后端项目结构**

```
app/
├── database/
│   ├── connection.py       # 数据库连接
│   └── session.py          # Session 管理
│
├── models/                 # SQLAlchemy ORM 模型
│   ├── base.py
│   ├── user.py
│   └── order.py
│
├── schemas/                 # Pydantic 模型
│   ├── user.py
│   └── order.py
│
├── services/                # 业务逻辑
│   ├── user_service.py
│   └── order_service.py
│
├── routers/                 # FastAPI 接口
│   ├── user.py
│   └── order.py
│
└── main.py
```

整体数据关系：

**Database**

数据库表、字段、约束

**SQLAlchemy ORM**

映射数据库结构，管理数据读写

**Pydantic Schema**

数据校验、序列化、API 输入输出

**FastAPI**

接口路由与 HTTP 请求响应

**一句话总结：**

> 通过 SQLAlchemy Reflection / Automap 可以在运行时自动映射数据库表；通过 `sqlacodegen` 可以将现有数据库表逆向生成真正的 Python ORM 类代码。前者是动态映射，后者是代码生成，适合不同场景。

如果你愿意，我可以继续给你整理一套 **MySQL 数据库 → 自动生成 SQLAlchemy 2.0 ORM → Pydantic Schema → FastAPI CRUD** 的完整可运行项目。