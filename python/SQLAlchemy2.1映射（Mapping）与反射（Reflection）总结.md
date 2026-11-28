# SQLAlchemy2.1映射（Mapping）与反射（Reflection）总结

SQLAlchemy 的核心能力之一，是建立 **Python
对象与关系型数据库之间的映射关系**。

Mapping 解决如何建立 ORM 映射；Reflection 解决如何读取数据库已有结构。

## 一、Mapping（映射）

### 1. 什么是 Mapping？

Mapping（映射）是将 Python 类与数据库表建立关联，并将 Python
属性与数据库字段建立对应关系的机制。

SQLAlchemy ORM 通过 Mapper 管理这种映射关系，使 Python
类具备数据库操作能力。

  Python              SQL
  ------------------- -------------------------
  Python Class        Database Table
  Class Attribute     Table Column
  Object Instance     Database Row 的对象表示
  `Mapped`            ORM 映射属性声明
  `mapped_column()`   ORM 列映射声明
  `relationship()`    ORM 关联关系

例如：

``` python
class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(50))
    age: Mapped[int]
```

SQLAlchemy 会将 `User` 类映射到 `users` 表，并将 `id`、`name`、`age`
属性映射到对应的数据库字段。

## 二、Mapping 的主要方式

SQLAlchemy ORM 支持两种主要的 ORM 映射方式：Declarative Mapping 和
Imperative Mapping。两者最终都建立 Mapper，内部映射机制基本统一。

### 1. Declarative Mapping（声明式映射）

**推荐 / 主流**

通过类定义直接声明数据库表结构和 ORM 属性。

#### 基础结构

``` python
from sqlalchemy import String
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column


class Base(DeclarativeBase):
    pass


class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column(String(50))
    age: Mapped[int]
```

#### 核心组成

  语法                作用
  ------------------- ---------------------------------
  `DeclarativeBase`   创建 ORM 声明式基类
  `__tablename__`     指定数据库表名称
  `Mapped[T]`         声明 ORM 映射属性及 Python 类型
  `mapped_column()`   配置列、约束、默认值等
  `relationship()`    建立 ORM 对象间的关联关系

#### 创建数据库表

``` python
Base.metadata.create_all(engine)
```

通过 ORM 模型中声明的元信息创建数据库表。

#### 特点

-   Python 类与表结构定义集中。
-   支持类型注解。
-   支持自动推导数据类型。
-   支持主键、外键、索引、约束。
-   支持 ORM 关系。
-   适合 Code First 开发模式。

官方文档：[Declarative
Mapping](https://docs.sqlalchemy.org/en/21/orm/declarative_mapping.html)。

### 2. Imperative Mapping（命令式映射）

通过独立的 `Table` 对象和 `registry.map_imperatively()` 将 Python
类映射到数据库表。

相比 Declarative Mapping，类本身不直接声明数据库列。

#### 示例

``` python
from sqlalchemy import Table, Column, Integer, String, MetaData
from sqlalchemy.orm import registry

mapper_registry = registry()
metadata = MetaData()

users_table = Table(
    "users",
    metadata,
    Column("id", Integer, primary_key=True),
    Column("name", String(50)),
    Column("age", Integer),
)


class User:
    pass


mapper_registry.map_imperatively(
    User,
    users_table
)
```

此时 `User` 已经具备 ORM 映射能力。

``` python
user = User()
user.name = "张三"
user.age = 25
```

通过 ORM Session 就可以对其进行持久化操作。

#### 特点

-   Python 类与数据库表定义相互分离。
-   映射关系通过 `registry` 显式配置。
-   不需要继承 `DeclarativeBase`。
-   适合需要高度控制映射过程的场景。
-   适合特殊类结构或已有 Python 类的映射。

官方文档：[ORM Mapped Class
Overview](https://docs.sqlalchemy.org/en/21/orm/mapping_styles.html)。

## 三、Reflection（反射）

### 1. 什么是 Reflection？

Reflection（数据库反射）是 SQLAlchemy
根据数据库中已经存在的对象，读取并解析数据库结构元信息的过程。

可以读取的内容包括：

-   表名（Table）
-   字段名（Column）
-   字段类型（Type）
-   主键（Primary Key）
-   外键（Foreign Key）
-   索引（Index）
-   唯一约束（Unique Constraint）
-   默认值（Default）

Reflection 并不等于自动生成 ORM Python 源代码，而是将数据库结构读取到
SQLAlchemy 的 `MetaData`、`Table` 等对象中。

### 2. Reflection 的工作流程

``` text
Existing Database
      ↓
Inspector / Reflection
读取、分析数据库元信息
      ↓
MetaData / Table
在 Python 中构建数据库结构对象
      ↓
ORM Mapping（可选）
进一步映射成 Python ORM 类
```

Reflection 的核心作用是将数据库已有的结构信息加载到 Python
中，后续可以继续进行 Core SQL 操作，或将这些结构关联到 ORM 类。

## 四、Reflection 的主要使用方式

### 方式一：反射单张表（Table Reflection）

使用 `Table` 和 `autoload_with`，读取指定数据库表的结构。

#### 示例

假设 MySQL 已经存在 `users` 表：

``` sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    age INT,
    email VARCHAR(100)
);
```

Python 反射：

``` python
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

SQLAlchemy 会自动读取 `users` 表结构，生成对应的 `Table` 和 `Column`
对象。

#### 获取表字段

``` python
print(users_table.columns.keys())
```

输出：

``` text
['id', 'name', 'age', 'email']
```

#### 访问字段信息

``` python
for column in users_table.columns:
    print(
        column.name,
        column.type,
        column.primary_key,
        column.nullable
    )
```

例如：

``` text
id INTEGER True False
name VARCHAR(50) False False
age INTEGER False True
email VARCHAR(100) False True
```

这里不需要手动定义 `Column`，Reflection 会读取数据库中的实际结构。

官方文档：[Reflecting Database
Objects](https://docs.sqlalchemy.org/en/21/core/reflection.html)。

### 方式二：反射整个数据库（MetaData Reflection）

如果数据库中存在很多表，可以通过 `MetaData.reflect()`
一次性读取数据库结构。

``` python
from sqlalchemy import create_engine, MetaData

engine = create_engine(
    "mysql+pymysql://root:123456@localhost:3306/test_db"
)

metadata = MetaData()
metadata.reflect(bind=engine)
```

反射完成后：

``` python
print(metadata.tables.keys())
```

可能输出：

``` text
dict_keys([
    'users',
    'orders',
    'products',
    'addresses'
])
```

获取指定表：

``` python
users_table = metadata.tables["users"]
orders_table = metadata.tables["orders"]
```

获取表字段：

``` python
for column in users_table.columns:
    print(column.name, column.type)
```

#### 指定反射表

只读取部分表：

``` python
metadata.reflect(
    bind=engine,
    only=["users", "orders"]
)
```

适合数据库表较多，但只需要使用部分表的情况。

### 方式三：通过 Reflection + Declarative Mapping

这种方式将数据库反射与 Declarative ORM 映射结合起来。

-   数据库结构由数据库负责。
-   Python ORM 类由开发者定义。
-   表字段通过 Reflection 自动加载。
-   ORM 类仍然可以使用 `relationship()`、业务方法等能力。

这是一种实用的 Database First 方案。

#### 示例

``` python
from sqlalchemy import Table
from sqlalchemy.orm import DeclarativeBase


class Base(DeclarativeBase):
    pass


class User(Base):
    __table__ = Table(
        "users",
        Base.metadata,
        autoload_with=engine
    )
```

此时 `User` 已经是一个 ORM 映射类。

创建实例：

``` python
user = User(
    name="张三",
    age=25,
    email="zhangsan@example.com"
)
```

查询：

``` python
from sqlalchemy import select
from sqlalchemy.orm import Session

with Session(engine) as session:
    stmt = select(User)
    users = session.scalars(stmt).all()

    for user in users:
        print(user.id, user.name, user.age)
```

这里的 `User` 类没有手动声明 `id`、`name`、`age` 等字段，而是通过
`__table__` 自动加载数据库表结构并映射到 ORM 类。

### 方式四：Automap 自动生成 ORM 类

如果连 Python ORM 类都不想手动声明，可以使用 SQLAlchemy 的 `Automap`。

Automap 会根据数据库反射结果自动生成映射类，并根据外键尝试建立 ORM
关联关系。

#### 示例

``` python
from sqlalchemy import create_engine
from sqlalchemy.ext.automap import automap_base

engine = create_engine(
    "mysql+pymysql://root:123456@localhost:3306/test_db"
)

Base = automap_base()
Base.prepare(autoload_with=engine)
```

自动获取模型：

``` python
User = Base.classes.users
Order = Base.classes.orders
Product = Base.classes.products
```

查询：

``` python
from sqlalchemy.orm import Session

with Session(engine) as session:
    users = session.query(User).all()

    for user in users:
        print(user.id, user.name)
```

Automap 可以根据数据库外键自动生成关联属性。例如
`orders.user_id → users.id`，可能建立 `user.orders`
以及对应的反向关系。具体属性名可能因表名、外键及命名规则而不同，可以通过
Automap 命名钩子自定义。

#### Automap 的特点

-   自动生成 ORM 映射类。
-   不需要手动声明每个模型。
-   自动识别数据库表。
-   根据外键推导关系。
-   适合快速接入已有数据库。
-   适合数据库管理工具、通用 CRUD、数据分析等场景。

官方文档：[Automap
Extension](https://docs.sqlalchemy.org/en/21/orm/extensions/automap.html)。

### 方式五：DeferredReflection（延迟反射）

`DeferredReflection` 适用于希望提前定义 ORM
类，但将实际数据库结构读取和映射初始化延迟到运行时的场景。

例如：

-   项目启动时数据库连接才可用。
-   ORM 类需要提前定义。
-   不希望在 Python 模块导入时就连接数据库。
-   需要保留显式 ORM 类与业务关系。

#### 示例

``` python
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.ext.declarative import DeferredReflection


class Base(DeclarativeBase):
    pass


class Reflected(DeferredReflection):
    __abstract__ = True


class User(Reflected, Base):
    __tablename__ = "users"


class Order(Reflected, Base):
    __tablename__ = "orders"


Reflected.prepare(engine)
```

调用 `Reflected.prepare(engine)` 才会完成相应的反射与映射初始化。

官方文档：[Mapping Declaratively with Reflected
Tables](https://docs.sqlalchemy.org/en/21/orm/declarative_tables.html)。

## 五、Mapping 与 Reflection 的区别

  ------------------------------------------------------------------------------------------------
  对比维度                Mapping                               Reflection
  ----------------------- ------------------------------------- ----------------------------------
  中文                    映射                                  反射

  主要目的                建立 Python 类与数据库的映射关系      获取数据库已有结构

  数据来源                Python 类、Table 元信息               数据库

  核心对象                `Mapper`、ORM Class                   `Inspector`、`MetaData`、`Table`

  是否依赖已有数据库表    不一定                                通常需要

  是否可以创建数据库表    可以配合 DDL 创建                     本身不会创建表

  是否生成 Python 类      定义或配置映射类                      本身不一定生成 ORM 类

  典型方法                `mapped_column()`、`relationship()`   `autoload_with`、`reflect()`

  开发模式                Code First                            Database First
  ------------------------------------------------------------------------------------------------

**Reflection 读取数据库结构，Mapping 建立 ORM 关系。Reflection 可以为
Mapping 提供数据，但 Mapping 不一定需要 Reflection。**

## 六、Reflection 与 Mapping 的组合关系

Reflection 不一定直接生成 ORM 类，它更像数据库结构读取层。

``` text
Database
MySQL / PostgreSQL / SQLite
      ↓
Reflection
Inspector / MetaData / Table / Column
      ↓
Mapping
Mapper / Declarative / Imperative / Automap
      ↓
ORM Model Instance
Python 对象 / 查询 / 插入 / 更新 / 删除
```

## 七、不同开发场景的选择

### 场景 1：新项目，数据库由 Python 管理

**Declarative Mapping**

``` python
class User(Base):
    __tablename__ = "users"

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str]
```

适合 Code First，模型定义是数据库结构的主要来源。

### 场景 2：已有数据库，需要生成 ORM 类文件

**sqlacodegen**

``` bash
sqlacodegen "mysql+pymysql://..." --outfile models.py
```

适合 Database First，生成代码后再维护。

### 场景 3：已有数据库，运行时自动操作表

**Reflection + Automap**

``` python
Base.prepare(autoload_with=engine)
User = Base.classes.users
```

适合动态数据库工具、快速开发、通用 CRUD。

### 场景 4：已有数据库，但希望自己控制 ORM 类

**Reflection + Declarative Mapping**

``` python
class User(Base):
    __table__ = Table(
        "users",
        Base.metadata,
        autoload_with=engine
    )
```

适合正式项目中既复用数据库结构，又保留业务模型控制权。

## 八、核心 API 速查

### Mapping

  API                            作用
  ------------------------------ ------------------------
  `DeclarativeBase`              创建声明式基类
  `Mapped[T]`                    ORM 类型映射声明
  `mapped_column()`              ORM 字段映射
  `relationship()`               ORM 关系映射
  `registry()`                   Mapper 注册中心
  `map_imperatively()`           命令式映射
  `Base.metadata.create_all()`   根据元信息创建数据库表

### Reflection

  API                      作用
  ------------------------ ----------------------------------
  `MetaData()`             数据库结构元信息容器
  `Table()`                表结构对象
  `autoload_with=engine`   自动读取数据库表结构
  `MetaData.reflect()`     批量反射数据库表
  `inspect(engine)`        获取数据库检查器
  `Inspector`              获取表、字段、索引、约束等元信息
  `automap_base()`         创建自动映射基类
  `Base.prepare()`         初始化自动映射或延迟映射

## 九、Inspector：数据库结构检查器

除了 Reflection 生成 `Table` 对象，也可以使用 `Inspector`
直接获取数据库元信息。

``` python
from sqlalchemy import inspect

inspector = inspect(engine)
```

### 获取表名

``` python
tables = inspector.get_table_names()
print(tables)
```

### 获取字段

``` python
columns = inspector.get_columns("users")

for column in columns:
    print(
        column["name"],
        column["type"],
        column["nullable"],
        column["default"]
    )
```

### 获取主键

``` python
primary_key = inspector.get_pk_constraint("users")
print(primary_key)
```

### 获取外键

``` python
foreign_keys = inspector.get_foreign_keys("orders")
print(foreign_keys)
```

### 获取索引

``` python
indexes = inspector.get_indexes("users")
print(indexes)
```

`Inspector`
更适合数据库元信息查询、数据库结构分析、自动代码生成以及开发数据库管理工具。

## 十、实际项目中的最佳实践

结合 SQLAlchemy 2.1 + FastAPI + Pydantic，建议采用以下策略：

  层级        推荐技术         负责内容
  ----------- ---------------- ------------------------
  Database    MySQL            数据持久化、约束
  ORM         SQLAlchemy 2.1   数据库映射、查询、事务
  Schema      Pydantic         数据校验、序列化
  API         FastAPI          HTTP 请求与响应
  Migration   Alembic          数据库结构版本迁移

### 推荐原则

1.  **Mapping 是 ORM 的核心**：无论采用哪种方式，最终都要建立 Mapper。
2.  **Reflection 不等于 ORM**：它只是读取数据库结构。
3.  **Reflection
    不等于代码生成**：反射得到的是运行时结构对象，代码生成则会产生实际
    Python 源文件。
4.  **正式业务项目优先显式映射**：对于业务模型复杂、关系多、类型安全要求高的项目，Declarative
    Mapping 更容易维护。
5.  **Database First 可以结合
    Reflection**：尤其是已有数据库、第三方数据库或历史项目。
6.  **数据库结构变更使用迁移工具**：不要仅依靠 Reflection
    来管理生产环境的数据库版本变化。

## 十一、总结

### 记住这 4 个概念

**Mapping**

Python 类 ↔ 数据库表，建立映射关系。

**Reflection**

数据库表 → Python 数据结构，读取已有结构。

**Automap**

Reflection + 自动 ORM 映射，快速生成 ORM 类。

**Code Generation**

数据库结构 → Python 源码文件，生成可长期维护的模型代码。

最简单的理解：

``` text
Mapping    = 建立关联
Reflection = 读取结构
Automap    = 自动映射
Codegen    = 生成代码
```

## SQLAlchemy 2.1 官方参考

-   [ORM Mapped Class
    Overview](https://docs.sqlalchemy.org/en/21/orm/mapping_styles.html)
-   [Declarative
    Mapping](https://docs.sqlalchemy.org/en/21/orm/declarative_mapping.html)
-   [Reflecting Database
    Objects](https://docs.sqlalchemy.org/en/21/core/reflection.html)
-   [Automap](https://docs.sqlalchemy.org/en/21/orm/extensions/automap.html)
-   [Mapping Declaratively with Reflected
    Tables](https://docs.sqlalchemy.org/en/21/orm/declarative_tables.html)

以上内容可作为 SQLAlchemy 2.1 中 Mapping 与 Reflection
的系统性知识笔记。
