# MySQL 基础知识总结

> 面向初学者与开发人员的 MySQL 基础速查，涵盖概念、常用
> SQL、设计与实践。

## 1. 数据库基础概念

-   **数据库（Database）**：按一定结构组织、存储和管理数据的集合。
-   **数据库管理系统（DBMS）**：用于创建、维护、查询数据库的软件，如
    MySQL、PostgreSQL。
-   **关系型数据库（RDBMS）**：通过表（Table）组织数据，表之间可通过关系关联。
-   **SQL（Structured Query
    Language）**：用于定义、查询、操作和管理关系型数据库的语言。

### 常见术语

| 术语 | 说明 |
| --- | --- |
| Database | 数据库，一个数据集合 |
| Table | 表，二维结构存储数据 |
| Row / Record | 行 / 记录，一条数据 |
| Column / Field | 列 / 字段，数据属性 |
| Primary Key | 主键，唯一标识一行 |
| Foreign Key | 外键，关联其他表的键 |
| Index | 索引，加速查询 |
| Schema | 数据库结构；在 MySQL 中通常与 Database 同义 |

## 2. MySQL 特点

-   开源、跨平台、使用广泛。
-   支持 SQL，适用于 Web、服务端及数据管理应用。
-   支持事务（InnoDB）、索引、外键、视图、触发器等。
-   支持多种存储引擎；常见默认引擎为 InnoDB。
-   客户端/服务端架构：客户端发送 SQL，服务器解析、优化并执行。

## 3. 数据类型

### 3.1 数值类型

| 类型 | 用途 / 特点 | 大小 | 取值范围（`UNSIGNED` 无符号） | 取值范围（有符号） |
| --- | --- | --- | --- | --- |
| `TINYINT` | 小整数 | 1 字节 | 0 ~ 255 | -128 ~ 127 |
| `SMALLINT` | 较小整数 | 2 字节 | 0 ~ 65535 | -32768 ~ 32767 |
| `MEDIUMINT` | 中等整数 | 3 字节 | 0 ~ 16777215 | -8388608 ~ 8388607 |
| `INT` / `INTEGER` | 常用整数 | 4 字节 | 0 ~ 4294967295（约 42.9 亿） | 约 ±21 亿 |
| `BIGINT` | 大整数，如较大 ID | 8 字节 | 0 ~ 约 1.84 × 10¹⁹ | 约 ±9.22 × 10¹⁸ |
| `FLOAT` | 单精度近似浮点数 | 4 字节 | 与有符号相同 | 约 ±3.4 × 10³⁸ |
| `DOUBLE` | 双精度近似浮点数 | 8 字节 | 与有符号相同 | 约 ±1.8 × 10³⁰⁸ |
| `DECIMAL(p,s)` | 精确小数，适合金额 | 按精度计算，每 9 位约 4 字节，最大 30 字节 | 非负，范围仍取决于 `p`、`s` | 取决于 `p`、`s` |

`UNSIGNED` 不改变存储字节数，只是把负数区间让给正数，上限约为原来两倍。MySQL 8.0.17 起 `FLOAT`、`DOUBLE` 的 `UNSIGNED` 已废弃，不建议使用。

金额通常使用 `DECIMAL`，避免浮点数精度问题。`DECIMAL(10,2)` 实际占 5 字节。

### 3.2 字符串类型

| 类型 | 用途 | 大小 |
| --- | --- | --- |
| `CHAR(n)` | 固定长度字符串 | 固定 `n` 字节，`n` ≤ 255 |
| `VARCHAR(n)` | 可变长度字符串，常用于名称、邮箱等 | 实际长度 + 1~2 字节，`n` ≤ 65535（受行总长限制） |
| `TEXT` | 较长文本 | 最多 65535 字节（64 KB）+ 2 字节长度前缀 |
| `BLOB` | 二进制数据 | 最多 65535 字节（64 KB） |

`CHAR` 按 `n` 补空格，定长、读快；`VARCHAR` 按实际长度存储，省空间但有长度开销。更长的文本用 `MEDIUMTEXT` / `LONGTEXT`（16 MB / 4 GB）。

### 3.3 日期与时间

| 类型 | 用途 | 格式 | 范围 | 大小 |
| --- | --- | --- | --- | --- |
| `DATE` | 日期 | `YYYY-MM-DD` | `1000-01-01` ~ `9999-12-31` | 3 字节 |
| `TIME` | 时间 | `HH:MM:SS[.fraction]` | `-838:59:59` ~ `838:59:59` | 3 字节 |
| `DATETIME` | 日期与时间 | `YYYY-MM-DD HH:MM:SS[.fraction]` | `1000-01-01 00:00:00` ~ `9999-12-31 23:59:59` | 5 字节 |
| `TIMESTAMP` | 时间戳类型，受时区转换等规则影响 | `YYYY-MM-DD HH:MM:SS[.fraction]` | `1970-01-01 00:00:01` UTC ~ `2038-01-19 03:14:07` UTC | 4 字节 |

`TIME` 的范围上限约 838 小时，因为它也能表示时间间隔。`TIMESTAMP` 上限到 2038 年（32 位秒数溢出，即「2038 问题」），长期存储时间建议用 `DATETIME`。

`TIME`、`DATETIME`、`TIMESTAMP` 若带小数秒（如 `DATETIME(3)`），每列额外增加 0~3 字节。`DATETIME` 在 MySQL 5.6.4 之前占 8 字节。

### 3.4 其他

-   `BOOLEAN`：MySQL 中通常是 `TINYINT(1)` 的别名，占 1 字节。
-   `JSON`：存储 JSON 文档，支持 JSON 函数查询与操作；以二进制格式存储，长度不固定（约实际内容长度 + 少量头部开销）。

## 4. SQL 语句分类

| 类别 | 全称 | 主要作用 | 常见语句 |
| --- | --- | --- | --- |
| DDL | Data Definition Language | 定义数据库对象 | `CREATE`、`ALTER`、`DROP`、`TRUNCATE` |
| DML | Data Manipulation Language | 操作数据 | `INSERT`、`UPDATE`、`DELETE` |
| DQL | Data Query Language | 查询数据 | `SELECT` |
| DCL | Data Control Language | 权限控制 | `GRANT`、`REVOKE` |
| TCL | Transaction Control Language | 事务控制 | `BEGIN`、`COMMIT`、`ROLLBACK` |

## 5. 数据库与表操作（DDL）

### 命名约定

后文示例按下面两条公开规范取名。

-   **标识符**：小写蛇形（snake_case）。只含字母、数字、下划线；以字母开头，不以下划线结尾；不用保留字。见 [SQL Style Guide](https://www.sqlstyle.guide/)。
-   **表**：单数，表示实体而不是数量，如 `user`、`product`。`order` 是保留字，订单表用 `trade_order`。
-   **字段**：单数，不加本表表名前缀。`user` 表用 `name`，不用 `user_name`；时间用 `created_at`，状态用 `status`。外键才带被引用实体名，如 `user_id`。
-   **查询别名**：多表列名相同时，只在 `SELECT` 里区分，如 `p.name AS product_name`。别名不写回表结构。
-   **索引**：普通索引 `idx_列名`，唯一索引 `uk_列名`，如 `idx_name`、`uk_email`。MySQL 的主键索引名固定为 `PRIMARY`。

表名单数、`idx_` / `uk_` 来自[阿里巴巴 Java 开发手册 MySQL 建表规约](https://alibaba.github.io/Alibaba-Java-Coding-Guidelines/)。该规约里的 `is_`、`gmt_create` 是另一种写法；本文示例用 `status`、`created_at`。

### 语法格式

多行语句按 [SQL Style Guide](https://www.sqlstyle.guide/) 排版：根关键字右对齐，末尾落在同一列，中间形成一条竖缝。只有一个子句的语句保持一行。

-   保留字大写，标识符小写。
-   `=` 两侧、逗号后各留一个空格。
-   `AND`、`OR` 单独成行，关键字末尾与 `WHERE` 对齐。
-   单独的 `JOIN` 在竖缝左侧，`ON` 与之对齐。`INNER JOIN`、`LEFT JOIN` 写在竖缝右侧。
-   `CREATE TABLE` 的列定义缩进 4 个空格，类型与 `NOT NULL` 纵向对齐。

``` sql
SELECT u.id, u.name
  FROM user AS u
  JOIN trade_order AS to
    ON to.user_id = u.id
 WHERE u.status = 1
   AND u.age >= 18;
```

``` sql
-- 查看数据库
SHOW DATABASES;

-- 创建数据库。库名与应用名一致，不加 _db 后缀
CREATE DATABASE app
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

-- 使用数据库
USE app;

-- 删除数据库（谨慎）
DROP DATABASE app;

-- 查看当前数据库
SELECT DATABASE();
```

### 表操作

``` sql
-- 查看表
SHOW TABLES;

-- 查看表结构
DESC user;
SHOW CREATE TABLE user;

-- 创建表
CREATE TABLE user (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(255),
    age        INT,
    created_at DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_email UNIQUE (email)
) ENGINE = InnoDB;

-- 增加字段
ALTER TABLE user ADD COLUMN status TINYINT NOT NULL DEFAULT 1;

-- 修改字段类型（修改前确认数据兼容性）
ALTER TABLE user MODIFY COLUMN name VARCHAR(150) NOT NULL;

-- 重命名字段（MySQL 8）。此处只演示语法，后文查询仍用 name
ALTER TABLE user RENAME COLUMN name TO display_name;

-- 删除字段
ALTER TABLE user DROP COLUMN age;

-- 删除表（谨慎）
DROP TABLE user;
```

## 6. CRUD：数据操作

### 6.1 INSERT

``` sql
-- 指定字段插入
INSERT INTO user (name, email, age)
VALUES ('Alice', 'alice@example.com', 20);

-- 一次插入多行。后续行与第一行的值对齐
INSERT INTO user (name, email, age)
VALUES ('Bob', 'bob@example.com', 25),
       ('Carol', 'carol@example.com', 30);
```

### 6.2 SELECT

``` sql
-- 查询所有字段（生产代码建议明确列名）
SELECT *
  FROM user;

-- 指定字段
SELECT id, name, email
  FROM user;

-- 别名。列名本身不加表前缀，需要换个名字时写在 AS 后面
SELECT name AS user_name
  FROM user;

-- 去重
SELECT DISTINCT age
  FROM user;

-- 条件查询
SELECT *
  FROM user
 WHERE age >= 18;

-- 排序
SELECT *
  FROM user
 ORDER BY created_at DESC, id DESC;

-- 分页
SELECT *
  FROM user
 LIMIT 20 OFFSET 40;
-- 等价写法：LIMIT 40, 20（偏移量, 返回行数）
```

### 6.3 UPDATE

``` sql
UPDATE user
   SET age = 21
 WHERE id = 1;

-- 更新多个字段
UPDATE user
   SET name = 'Alice Chen',
       age = 21
 WHERE id = 1;
```

**注意：** `UPDATE` 不写 `WHERE`
会更新所有记录。修改前建议先用同样条件执行 `SELECT` 检查目标行。

### 6.4 DELETE

``` sql
DELETE
  FROM user
 WHERE id = 1;

-- 删除满足条件的记录
DELETE
  FROM user
 WHERE age < 18;
```

**注意：** 不写 `WHERE` 将删除表中全部记录，但表结构仍然存在。

## 7. WHERE 条件

``` sql
-- 比较运算符
=  <>  !=  >  <  >=  <=

-- 逻辑运算符
AND  OR  NOT

-- 范围
age BETWEEN 18 AND 30

-- 集合
id IN (1, 2, 3)

-- 模糊匹配
name LIKE 'A%'    -- A 开头
name LIKE '%a'    -- a 结尾
name LIKE '%li%'  -- 包含 li

-- 空值
email IS NULL
email IS NOT NULL
```

### NULL 注意点

-   `NULL` 表示未知或缺失，不等同于 `0`、空字符串 `''`。
-   使用 `IS NULL` / `IS NOT NULL` 判断，不能使用 `= NULL`。
-   NULL 参与普通比较通常得到 `UNKNOWN`，`WHERE` 不会选中它。

## 8. 聚合函数与分组

常用聚合函数：

| 函数 | 作用 |
| --- | --- |
| `COUNT()` | 计数 |
| `SUM()` | 求和 |
| `AVG()` | 平均值 |
| `MAX()` | 最大值 |
| `MIN()` | 最小值 |

``` sql
SELECT COUNT(*) AS user_count
  FROM user;

SELECT AVG(age) AS avg_age
  FROM user;

-- 分组统计。聚合结果的别名按字段来起名，不用函数名 count
SELECT age, COUNT(*) AS user_count
  FROM user
 GROUP BY age;

-- 分组后筛选（HAVING）。HAVING 与 SELECT 一样长，顶格写
SELECT age, COUNT(*) AS user_count
  FROM user
 GROUP BY age
HAVING COUNT(*) >= 2;
```

-   `WHERE`：分组前过滤行。
-   `HAVING`：分组后过滤聚合结果。

## 9. JOIN 多表查询

假设有 `user` 与 `trade_order` 两张表：

``` sql
-- INNER JOIN：只返回两边匹配的行
-- 别名取对象名每个单词的首字母：user → u，trade_order → to
SELECT u.id, u.name, to.id AS trade_order_id, to.amount
  FROM user AS u
       INNER JOIN trade_order AS to
       ON to.user_id = u.id;

-- LEFT JOIN：返回左表全部行，右表匹配不到时为 NULL
SELECT u.id, u.name, to.id AS trade_order_id
  FROM user AS u
       LEFT JOIN trade_order AS to
       ON to.user_id = u.id;

-- 多表关联。单独的 JOIN、ON 留在竖缝左侧
SELECT u.name, to.id, p.name AS product_name
  FROM user AS u
  JOIN trade_order AS to
    ON to.user_id = u.id
  JOIN product AS p
    ON p.id = to.product_id;
```

| JOIN | 结果 |
| --- | --- |
| `INNER JOIN` | 两表匹配的行 |
| `LEFT JOIN` | 左表全部行及右表匹配行 |
| `RIGHT JOIN` | 右表全部行及左表匹配行 |
| `CROSS JOIN` | 两表笛卡尔积 |

实践中常优先使用 `LEFT JOIN` / `INNER JOIN`，并明确写出 `ON` 条件。

## 10. 子查询与集合操作

``` sql
-- 子查询：查询下单用户。子查询本身再按同一套竖缝排版
SELECT *
  FROM user
 WHERE id IN
       (SELECT user_id
          FROM trade_order);

-- EXISTS：判断是否存在关联订单
SELECT u.*
  FROM user AS u
 WHERE EXISTS
       (SELECT 1
          FROM trade_order AS to
         WHERE to.user_id = u.id);
```

-   子查询可出现在 `SELECT`、`FROM`、`WHERE` 等位置。
-   `EXISTS` 常用于判断关联数据是否存在。
-   MySQL 支持 `UNION` 合并查询结果；`UNION` 默认去重，`UNION ALL`
    保留重复行。

## 11. 索引（Index）

索引是一种帮助数据库快速定位数据的结构，通常会增加存储与写入维护成本。

### 常见索引类型

-   **主键索引**：`PRIMARY KEY`，唯一且不允许 NULL。
-   **唯一索引**：`UNIQUE`，保证索引键值唯一（NULL
    的行为需结合列定义理解）。
-   **普通索引**：`INDEX` / `KEY`，提升检索效率。
-   **联合索引**：多个字段组成一个索引。

``` sql
CREATE INDEX idx_name ON user(name);
CREATE UNIQUE INDEX uk_email ON user(email);
CREATE INDEX idx_status_created_at ON user(status, created_at);

DROP INDEX idx_name ON user;
```

### 联合索引与最左前缀原则

索引 `(status, created_at)` 通常能支持：

-   `WHERE status = ?`
-   `WHERE status = ? AND created_at >= ?`

不能仅依赖它高效支持
`WHERE created_at = ?`，因为查询没有使用联合索引最左侧字段。

### 索引实践

-   给高频过滤、关联、排序字段合理建索引。
-   避免索引过多；索引会占空间并增加 `INSERT`、`UPDATE`、`DELETE` 成本。
-   尽量避免在索引列上直接使用函数或进行不利于索引查找的表达式。
-   使用 `EXPLAIN` 分析执行计划，不要只凭猜测优化。

## 12. 约束（Constraint）

| 约束 | 作用 |
| --- | --- |
| `PRIMARY KEY` | 唯一标识记录 |
| `UNIQUE` | 值唯一 |
| `NOT NULL` | 不允许 NULL |
| `DEFAULT` | 默认值 |
| `CHECK` | 检查条件（MySQL 8.0.16 起实际执行） |
| `FOREIGN KEY` | 外键约束 |

``` sql
CREATE TABLE trade_order (
    id         BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id    BIGINT UNSIGNED NOT NULL,
    amount     DECIMAL(10, 2)  NOT NULL CHECK (amount >= 0),
    created_at DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_trade_order_user_id
        FOREIGN KEY (user_id) REFERENCES user (id)
) ENGINE = InnoDB;
```

## 13. 事务（Transaction）

事务用于将多条操作作为一个整体执行，保证符合 ACID 特性。

### ACID

-   **Atomicity（原子性）**：事务中的操作要么全部成功，要么全部回滚。
-   **Consistency（一致性）**：事务执行前后数据满足约束和业务规则。
-   **Isolation（隔离性）**：并发事务之间按隔离规则互不产生不符合预期的影响。
-   **Durability（持久性）**：提交后数据持久保存。

``` sql
START TRANSACTION;

UPDATE account
   SET balance = balance - 100
 WHERE id = 1;

UPDATE account
   SET balance = balance + 100
 WHERE id = 2;

COMMIT;
-- 出错或需要撤销时：
-- ROLLBACK;
```

常用语句： - `START TRANSACTION` / `BEGIN`：开启事务。 -
`COMMIT`：提交事务。 - `ROLLBACK`：回滚事务。 -
`SAVEPOINT`：设置事务保存点。

### 隔离级别

| 隔离级别 | 说明（概念层面） |
| --- | --- |
| READ UNCOMMITTED | 可能读到未提交数据 |
| READ COMMITTED | 只能读取已提交数据 |
| REPEATABLE READ | 同一事务内一致性读通常保持可重复（InnoDB 默认级别） |
| SERIALIZABLE | 更强隔离，可能降低并发 |

## 14. 存储引擎

MySQL 存储引擎负责表数据的存储、索引、事务等实现。

| 引擎 | 特点 |
| --- | --- |
| InnoDB | 支持事务、行级锁、外键；常见默认引擎 |
| MyISAM | 不支持事务与外键；历史场景使用，现代业务通常优先 InnoDB |

``` sql
SHOW ENGINES;

CREATE TABLE demo (
    id INT PRIMARY KEY
) ENGINE = InnoDB;
```

## 15. 视图（View）

视图是基于查询定义的虚拟表，通常不直接存储查询结果数据。

``` sql
CREATE VIEW active_user AS
SELECT id, name
  FROM user
 WHERE status = 1;

SELECT *
  FROM active_user;

DROP VIEW active_user;
```

视图可用于简化查询、封装逻辑与控制可见字段，但不应替代合理的数据权限设计。

## 16. 常用函数

> 下列输出为示例参数的计算结果；`#` 后是返回值，`#` 在 MySQL 中也可作行注释。
>
> ``` sql
> SELECT CONCAT('Hello', ' ', 'MySQL');   # 'Hello MySQL'
> ```

### 字符串函数

``` sql
CONCAT('Hello', ' ', 'MySQL')     # 'Hello MySQL'
LENGTH('abc')                     # 3（字节数）
CHAR_LENGTH('中文')               # 2（字符数）
LOWER('ABC')                      # 'abc'
UPPER('abc')                      # 'ABC'
SUBSTRING('abcdef', 2, 3)         # 'bcd'
TRIM('  abc  ')                   # 'abc'
```

### 数值函数

``` sql
ABS(-10)                          # 10（绝对值）
ROUND(3.14159, 2)                 # 3.14（四舍五入，保留 2 位小数）
CEIL(1.2)                         # 2（向上取整）
FLOOR(1.8)                        # 1（向下取整）
MOD(10, 3)                        # 1（取余）
```

### 日期函数

``` sql
NOW()                             # 当前日期时间，如 '2026-11-28 15:20:00'
CURDATE()                         # 当前日期，如 '2026-11-28'
CURTIME()                         # 当前时间，如 '15:20:00'
DATE_ADD(NOW(), INTERVAL 7 DAY)   # 当前时间往后加 7 天
DATEDIFF('2026-12-01', '2026-11-01')  # 30（天数差）
```

### 条件与空值函数

``` sql
IF(age >= 18, 'adult', 'minor')   # age = 20 时返回 'adult'
CASE WHEN score >= 90 THEN 'A'
     WHEN score >= 60 THEN 'B'
     ELSE 'C'
END                               # score = 85 时返回 'B'
COALESCE(email, '未填写')         # email 为 NULL 时返回 '未填写'
IFNULL(email, '未填写')           # 同上
```

## 17. 用户、权限与安全

``` sql
-- 创建用户（示例）
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'StrongPasswordHere';

-- 授权
GRANT SELECT, INSERT, UPDATE, DELETE
    ON app.* TO 'app_user'@'localhost';

-- 查看权限
SHOW GRANTS FOR 'app_user'@'localhost';

-- 撤销权限
REVOKE DELETE ON app.* FROM 'app_user'@'localhost';
```

最佳实践： - 应用使用独立数据库用户，遵循最小权限原则。 -
不在代码仓库提交密码、连接串或密钥。 - 使用参数化查询 / 预编译语句防止
SQL 注入。 - 避免拼接用户输入到 SQL 语句中。

## 18. SQL 执行逻辑与书写顺序

### 常见书写顺序

``` sql
SELECT ...
  FROM ...
  JOIN ...
    ON ...
 WHERE ...
 GROUP BY ...
HAVING ...
 ORDER BY ...
 LIMIT ...;
```

### 概念上的逻辑执行顺序

``` text
FROM / JOIN
→ ON
→ WHERE
→ GROUP BY
→ HAVING
→ SELECT
→ DISTINCT
→ ORDER BY
→ LIMIT
```

理解逻辑执行顺序，有助于理解为什么 `WHERE` 中不能直接使用部分 `SELECT`
别名，以及 `HAVING` 的使用场景。

## 19. 常见优化与开发规范

-   查询只取需要的列，避免不必要的 `SELECT *`。
-   为常用查询设计合适索引；索引应结合实际 SQL 与数据分布。
-   使用 `EXPLAIN` 查看执行计划。
-   避免对索引字段进行不必要的函数、隐式类型转换。
-   分页数据量很大时，考虑基于索引的游标式分页，避免深度 `OFFSET`。
-   使用事务保证多步业务操作的一致性。
-   所有 `UPDATE` / `DELETE` 在执行前检查条件。
-   使用 `utf8mb4` 字符集，支持完整 Unicode（如 emoji）。
-   时间、金额、状态字段选择合适类型，明确业务约束。
-   备份与恢复必须定期演练，而不只是配置备份任务。

## 20. 常用命令速查

``` sql
-- 连接
mysql -u root -p
mysql -h 127.0.0.1 -P 3306 -u root -p

-- 数据库
SHOW DATABASES;
CREATE DATABASE app;
USE app;
DROP DATABASE app;

-- 表
SHOW TABLES;
DESC table_name;
SHOW CREATE TABLE table_name;
CREATE TABLE table_name (...);

-- 修改表结构
ALTER TABLE table_name ADD COLUMN column_name VARCHAR(100) NOT NULL DEFAULT '';
ALTER TABLE table_name MODIFY COLUMN column_name VARCHAR(150) NOT NULL;
ALTER TABLE table_name CHANGE COLUMN old_column new_column VARCHAR(150) NOT NULL;
ALTER TABLE table_name RENAME COLUMN old_column TO new_column;   -- 只改名，MySQL 8
ALTER TABLE table_name DROP COLUMN column_name;
ALTER TABLE table_name ADD INDEX idx_column_name (column_name);
ALTER TABLE table_name ADD CONSTRAINT uk_column_name UNIQUE (column_name);
ALTER TABLE table_name ADD CONSTRAINT fk_column_name
    FOREIGN KEY (column_name) REFERENCES other_table (id);
ALTER TABLE table_name RENAME TO new_table_name;
ALTER TABLE table_name ENGINE = InnoDB;
ALTER TABLE table_name CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

DROP TABLE table_name;

-- 数据
SELECT column_name FROM table_name WHERE condition;
INSERT INTO table_name (column_name) VALUES (value);
UPDATE table_name SET column_name = value WHERE condition;
DELETE FROM table_name WHERE condition;

-- 索引
SHOW INDEX FROM table_name;
CREATE INDEX idx_column_name ON table_name(column_name);
EXPLAIN SELECT column_name FROM table_name WHERE condition;

-- 用户与权限
-- 'host' 写 'localhost' 只允许本机登录；'%' 表示任意主机，生产环境慎用
CREATE USER 'user_name'@'host' IDENTIFIED BY 'password';
ALTER USER 'user_name'@'host' IDENTIFIED BY 'new_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON db_name.* TO 'user_name'@'host';
GRANT ALL PRIVILEGES ON db_name.* TO 'user_name'@'host';
REVOKE DELETE ON db_name.* FROM 'user_name'@'host';
SHOW GRANTS FOR 'user_name'@'host';
DROP USER 'user_name'@'host';

-- 仅直接改过 mysql 库授权表时才需要；GRANT / REVOKE 本身立即生效
FLUSH PRIVILEGES;
```

## 21. 初学者学习顺序

1.  数据库、表、行、列、主键等概念。
2.  数据类型与建表语句。
3.  `SELECT`、`WHERE`、`ORDER BY`、`LIMIT`。
4.  `INSERT`、`UPDATE`、`DELETE`。
5.  聚合函数、`GROUP BY`、`HAVING`。
6.  `JOIN` 多表查询。
7.  子查询、`UNION`。
8.  索引与 `EXPLAIN`。
9.  事务、隔离级别、锁的基本概念。
10. 用户权限、备份恢复与性能优化。

## 22. 高频面试 / 自测问题

**1. MySQL 与 SQL 分别是什么？**

SQL（Structured Query Language）是操作关系型数据库的标准语言；MySQL 是实现了 SQL 的数据库管理系统（产品）。一句话记忆：SQL 是语言，MySQL 是产品。

**2. 主键、唯一索引、普通索引有什么区别？**

主键唯一且不能为 NULL，一张表只能有一个，InnoDB 中就是聚簇索引；唯一索引保证值唯一但允许多个 NULL，一张表可以有多个；普通索引只加速查询，不做任何唯一性约束。

**3. `CHAR` 和 `VARCHAR` 有什么区别？**

`CHAR` 定长，不足补空格，`n` ≤ 255，读取稍快；`VARCHAR` 变长，按实际长度存储并额外占 1~2 字节记录长度，`n` ≤ 65535（还受行总长限制），更省空间。定长且长度固定的场景（如性别、状态码）用 `CHAR`，其余一般用 `VARCHAR`。

**4. `WHERE` 与 `HAVING` 有什么区别？**

`WHERE` 在分组前过滤行，不能使用聚合函数；`HAVING` 在分组后过滤分组结果，可以使用聚合函数。能用 `WHERE` 过滤的条件不要放到 `HAVING`，否则多了分组计算开销。

**5. `INNER JOIN` 和 `LEFT JOIN` 有什么区别？**

`INNER JOIN` 只返回两表都能匹配上的行；`LEFT JOIN` 返回左表全部行，右表匹配不到的列补 NULL。需要保留主表全部记录（如查「没下过单的用户」）时用 `LEFT JOIN`。

**6. `DELETE`、`TRUNCATE`、`DROP` 有什么区别？**

`DELETE` 是 DML，逐行删除，可带 `WHERE`，可回滚，触发触发器，自增值不重置；`TRUNCATE` 是 DDL，清空整表但保留结构，不能带 `WHERE`，隐式提交不可回滚，自增重置，速度快；`DROP` 删除整张表（结构 + 数据），表就不存在了。

**7. `COUNT(*)`、`COUNT(列)`、`COUNT(1)` 的区别是什么？**

`COUNT(*)` 和 `COUNT(1)` 统计行数，效果相同，`InnoDB` 优化器处理方式一致；`COUNT(列)` 只统计该列非 NULL 的行，结果可能更小。日常统计行数用 `COUNT(*)` 即可。

**8. 什么是事务？ACID 是什么？**

事务是把多条操作当成一个整体执行：要么全部成功，要么全部回滚。ACID 指原子性（Atomicity，全做或全不做）、一致性（Consistency，前后满足约束与业务规则）、隔离性（Isolation，并发事务互不干扰）、持久性（Durability，提交后落盘不丢）。

**9. InnoDB 与 MyISAM 有什么区别？**

InnoDB 支持事务、行级锁、外键、MVCC 和崩溃恢复，是 MySQL 5.5 之后的默认引擎；MyISAM 只有表级锁，不支持事务和外键，崩溃后可能损坏。现代业务一律选 InnoDB。

**10. 联合索引的最左前缀原则是什么？**

联合索引 `(a, b, c)` 能用于 `WHERE a = ?`、`WHERE a = ? AND b = ?`、`WHERE a = ? AND b = ? AND c = ?`，也能用于 `a` 开头的范围查询；跳过最左列（如只用 `b`、`c`）则用不上这个索引。本质是索引按 `a`、`b`、`c` 顺序排序存放。

**11. 为什么索引不是越多越好？**

索引占存储空间；每次 `INSERT`、`UPDATE`、`DELETE` 都要同步维护所有相关索引，写入变慢；索引过多还会让优化器选错索引、增加分析成本。只给高频过滤、关联、排序的字段建索引。

**12. 如何使用 `EXPLAIN` 分析 SQL？**

重点看四列：`type` 访问类型（`ALL` 是全表扫描，需要优化；`ref`、`range` 较好）、`key` 实际使用的索引、`rows` 预估扫描行数、`Extra`（出现 `Using filesort`、`Using temporary` 要留意）。MySQL 8.0.18+ 可用 `EXPLAIN ANALYZE` 看实际执行耗时。

**13. 什么是 SQL 注入？如何防止？**

把用户输入直接拼进 SQL 字符串，攻击者输入 `' OR '1'='1` 之类的内容改变原语句含义，从而绕过条件、读到或删掉数据。防护核心是参数化查询 / 预编译语句（如 `PreparedStatement`、ORM 参数绑定），再配合输入校验、最小权限账号，不要手工拼接 SQL。

------------------------------------------------------------------------
## utf8mb4
utf8mb4 是 MySQL 中真正完整的 UTF-8 字符集，每个字符最多用 4 个字节存储，能覆盖 Emoji、生僻汉字等所有 Unicode 字符。

为什么需要 utf8mb4
MySQL 里有一个历史遗留的命名陷阱：MySQL 的 utf8 并不是标准的 UTF-8，而是 utf8mb3 的别名，每个字符最多只支持 3 字节。而 Unicode 中有一部分字符（如 Emoji、部分生僻汉字、音乐符号等）需要 4 字节才能表示。utf8mb4 的 mb4 就是 "most bytes 4" 的意思，它才是完整的 UTF-8 实现。

从 MySQL 8.0 开始，如果在服务器指令中写 utf8，服务器会发出警告并自动替换为 utf8mb3，这进一步说明 utf8 这个名字已经不再推荐使用。

字节层面的区别
utf8mb3：1–3 字节，覆盖 BMP（基本多文种平面）内的字符。
utf8mb4：1–4 字节，覆盖全部 Unicode 码位（U+0000 到 U+10FFFF）。

所以当你插入一个 Emoji（如 😀，码位 U+1F600）时，utf8mb3 列会报 1366 Incorrect string value，而 utf8mb4 列可以正常存储。

## 总结

MySQL 学习的核心路线是：

**理解数据模型 → 熟悉 SQL CRUD → 掌握多表查询 → 理解索引 → 掌握事务 →
关注安全与性能。**

SQL 不仅是语法，更重要的是理解数据结构、查询逻辑、约束与执行效率。

