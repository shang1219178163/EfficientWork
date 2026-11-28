# 分页高性能 SQL

> 两种实现共用过滤条件，排序都要稳定。页码分页用 `LIMIT / OFFSET`，可以跳页、可以返回 total。游标分页用排序列定位下一页，深页不用先丢掉前面的行。

---

## 一、怎么选

| | 页码分页 | 游标分页 |
|---|---|---|
| 参数 | `page`、`pageSize` | 首页 `lastId` 为空；下一页传上一页最后一条。`created_at` 排序再带 `lastCreatedAt` |
| 跳页 | 可以 | 下一页 / 上一页 |
| total | 同一套 WHERE 再 `COUNT(*)` | 通常不查 |
| 深页 | 扫描并丢掉 `OFFSET` 行 | 从游标接着取 |
| 并发插入 | 后面的页会平移，可能重复或漏 | 已翻过的行不会再次出现 |

同一条 SQL 不要同时带 `OFFSET` 和游标条件。

---

## 二、共用条件

过滤写在 `ORDER BY` / `LIMIT` 之前。下面每条查询都是完整语句，关键字和排除列表已经写在语句里。

关键字只做前缀匹配。默认 SQL mode 下 `\` 是 LIKE 转义符。`:kwLike` 由应用层算好再传入：

```text
kwLike = 转义(kw) + "%"
转义 = REPLACE(REPLACE(REPLACE(kw, "\\", "\\\\"), "%", "\\%"), "_", "\\_")
```

`%kw%` 交给 ES。`name OR email` 做不到固定只读一页：关键字越稀，凑满一页读的行越多。

排除列表里每个 id 一个占位符，写成 `id NOT IN (?,?,?)`。列表为空时，完整 SQL 里不写 `NOT IN`。列表含 `NULL`，或写成 `NOT IN ()`，都会查不出数据。个数多时改成临时表：

```sql
SELECT id, name, email, status, created_at
FROM user
WHERE NOT EXISTS (
    SELECT 1 FROM user_exclude e
    WHERE e.batch_id = :batchId
      AND e.user_id = user.id
)
ORDER BY id DESC
LIMIT :pageSize;
```

外层表有别名 `u` 时，把 `user.id` 改成 `u.id`。`user_exclude` 的索引是 `(batch_id, user_id)`。

排序要稳定，并列值上两种实现都会重复或漏行：按 `id DESC`，或按 `created_at DESC, id DESC`。`created_at` 设为 NOT NULL。

---

## 三、页码分页

`page` 从 1 开始，`offset = (page - 1) * pageSize`。`page < 1` 或 `pageSize` 超过上限时，应用层直接拒绝。

按 `id DESC`。行很宽时内层先丢掉前面的 id，再回表取列：

```sql
SELECT u.id, u.name, u.email, u.status, u.created_at
FROM user u
INNER JOIN (
    SELECT id
    FROM user
    WHERE (name LIKE :kwLike OR email LIKE :kwLike)
      AND id NOT IN (?,?,?)
    ORDER BY id DESC
    LIMIT :pageSize OFFSET :offset
) t ON t.id = u.id
ORDER BY u.id DESC;
```

没有关键字、没有排除列表、列又少时，直接查：

```sql
SELECT id, name, email, status, created_at
FROM user
ORDER BY id DESC
LIMIT :pageSize OFFSET :offset;
```

按 `created_at DESC, id DESC`：

```sql
SELECT u.id, u.name, u.email, u.status, u.created_at
FROM user u
INNER JOIN (
    SELECT id
    FROM user
    WHERE (name LIKE :kwLike OR email LIKE :kwLike)
      AND id NOT IN (?,?,?)
    ORDER BY created_at DESC, id DESC
    LIMIT :pageSize OFFSET :offset
) t ON t.id = u.id
ORDER BY u.created_at DESC, u.id DESC;
```

深页仍然要扫描 `OFFSET + pageSize` 个 id。少读的是被丢掉那些行的完整字段。

总数和列表使用同一套 `WHERE`，不加 `ORDER BY`：

```sql
SELECT COUNT(*)
FROM user
WHERE (name LIKE :kwLike OR email LIKE :kwLike)
  AND id NOT IN (?,?,?);
```

没有过滤条件时，`COUNT(*)` 可以走主键。带 `OR` / `LIKE` 时，这次计数要扫匹配行。

**返回结构：**

列表按 `pageSize` 查，`hasMore` 用总数判断，不多取一行：

```text
hasMore = page * pageSize < total
```

`page = 2`、`pageSize = 20`、`total = 345` 时，`40 < 345`，`hasMore` 为 `true`。最后一页 `page = 18` 时，`360 < 345` 不成立，`hasMore` 为 `false`。总数刚好 40、`page = 2` 时，`40 < 40` 不成立，这一页是满的，也是最后一页。

```json
{
  "list": [ ... ],
  "page": 2,
  "pageSize": 20,
  "total": 345,
  "hasMore": true
}
```

```xml
<select id="pageUsers" resultType="User">
  SELECT u.id, u.name, u.email, u.status, u.created_at
  FROM user u
  INNER JOIN (
    SELECT id
    FROM user
    <where>
      <if test="keyword != null and keyword != ''">
        AND (
          name LIKE CONCAT(REPLACE(REPLACE(REPLACE(#{keyword}, '\\', '\\\\'), '%', '\\%'), '_', '\\_'), '%')
          OR email LIKE CONCAT(REPLACE(REPLACE(REPLACE(#{keyword}, '\\', '\\\\'), '%', '\\%'), '_', '\\_'), '%')
        )
      </if>
      <if test="excludeIds != null and excludeIds.size() > 0">
        AND id NOT IN
        <foreach collection="excludeIds" item="eid" open="(" separator="," close=")">#{eid}</foreach>
      </if>
    </where>
    <choose>
      <when test="orderBy == 'createdAt'">
        ORDER BY created_at DESC, id DESC
      </when>
      <otherwise>
        ORDER BY id DESC
      </otherwise>
    </choose>
    LIMIT #{pageSize} OFFSET #{offset}
  ) t ON t.id = u.id
  <choose>
    <when test="orderBy == 'createdAt'">
      ORDER BY u.created_at DESC, u.id DESC
    </when>
    <otherwise>
      ORDER BY u.id DESC
    </otherwise>
  </choose>
</select>

<select id="countUsers" resultType="long">
  SELECT COUNT(*)
  FROM user
  <where>
    <if test="keyword != null and keyword != ''">
      AND (
        name LIKE CONCAT(REPLACE(REPLACE(REPLACE(#{keyword}, '\\', '\\\\'), '%', '\\%'), '_', '\\_'), '%')
        OR email LIKE CONCAT(REPLACE(REPLACE(REPLACE(#{keyword}, '\\', '\\\\'), '%', '\\%'), '_', '\\_'), '%')
      )
    </if>
    <if test="excludeIds != null and excludeIds.size() > 0">
      AND id NOT IN
      <foreach collection="excludeIds" item="eid" open="(" separator="," close=")">#{eid}</foreach>
    </if>
  </where>
</select>
```

`excludeIds` 用 `List`，元素不要是 `null`。`orderBy` 只走上面两个固定分支，前端字符串不要拼进 `${}`。

---

## 四、游标分页

首页 `lastId` 传 `NULL`。不要传空字符串，数值参数会把 `''` 收成 `0`，`id < 0` 查不到正数 id。也不要传 `Long.MAX_VALUE` 或 `9999999999`。`:limit = pageSize + 1`。

### 按 id 倒序

首页，`lastId` 为空，没有关键字、没有排除列表：

```sql
SELECT id, name, email, status, created_at
FROM user
ORDER BY id DESC
LIMIT :limit;
```

首页，`lastId` 为空，带关键字和排除列表：

```sql
SELECT id, name, email, status, created_at
FROM user
WHERE (name LIKE :kwLike OR email LIKE :kwLike)
  AND id NOT IN (?,?,?)
ORDER BY id DESC
LIMIT :limit;
```

下一页，`:lastId` 为上一页最后一条 id：

```sql
SELECT id, name, email, status, created_at
FROM user
WHERE id < :lastId
  AND (name LIKE :kwLike OR email LIKE :kwLike)
  AND id NOT IN (?,?,?)
ORDER BY id DESC
LIMIT :limit;
```

上一页，`:firstId` 为当前页第一条 id。内层升序取邻近行，外层倒回展示顺序：

```sql
SELECT id, name, email, status, created_at
FROM (
    SELECT id, name, email, status, created_at
    FROM user
    WHERE id > :firstId
      AND (name LIKE :kwLike OR email LIKE :kwLike)
      AND id NOT IN (?,?,?)
    ORDER BY id ASC
    LIMIT :limit
) t
ORDER BY id DESC;
```

### 按 created_at 倒序

时间会重复，用 `id` 兜底。首页 `lastCreatedAt` 和 `lastId` 都为空。下一页两个都传本页最后一条的原值，`DATETIME(6)` 不要截成秒。只写 `id < :lastId` 会漏掉时间更早、id 更大的行，也会把上一页已经返回的行再查出来。

首页：

```sql
SELECT id, name, email, status, created_at
FROM user
WHERE (name LIKE :kwLike OR email LIKE :kwLike)
  AND id NOT IN (?,?,?)
ORDER BY created_at DESC, id DESC
LIMIT :limit;
```

下一页：

```sql
SELECT id, name, email, status, created_at
FROM user
WHERE (
        created_at < :lastCreatedAt
        OR (created_at = :lastCreatedAt AND id < :lastId)
      )
  AND (name LIKE :kwLike OR email LIKE :kwLike)
  AND id NOT IN (?,?,?)
ORDER BY created_at DESC, id DESC
LIMIT :limit;
```

上一页，锚点是当前页第一条：

```sql
SELECT id, name, email, status, created_at
FROM (
    SELECT id, name, email, status, created_at
    FROM user
    WHERE (
            created_at > :firstCreatedAt
            OR (created_at = :firstCreatedAt AND id > :firstId)
          )
      AND (name LIKE :kwLike OR email LIKE :kwLike)
      AND id NOT IN (?,?,?)
    ORDER BY created_at ASC, id ASC
    LIMIT :limit
) t
ORDER BY created_at DESC, id DESC;
```

**返回结构：**

`:limit` 传 `pageSize + 1`。首页 `lastId` 为空，下一页才带游标，判断方法相同。上一页也多取 1 行，用来判断前面还有没有数据。

```text
hasMore = 实际查到的行数 > pageSize
list    = 前 pageSize 行
游标    = list 最后一条
```

`pageSize = 20` 时，查到 21 行则 `hasMore = true`，`list` 只留前 20 行。多出来的那行只用来判断，不返回，也不拿它做游标，否则下一页会跳过它。查到 20 行或更少则 `hasMore = false`，`list` 就是全部结果，游标置空。

按 `id` 排序，游标是最后一条的 `id`：

```json
{
  "list": [ ... ],
  "nextCursor": 10233,
  "hasMore": true
}
```

按 `created_at` 排序，游标带上 `list` 最后一条的 `created_at` 和 `id`：

```json
{
  "list": [ ... ],
  "nextCreatedAt": "2024-06-01 12:00:00",
  "nextId": 10233,
  "hasMore": true
}
```

```xml
<select id="cursorPageUsers" resultType="User">
  <!-- 首页 lastId 为空，不生成 id &lt; -->
  SELECT id, name, email, status, created_at
  FROM user
  <where>
    <if test="lastId != null">
      AND id &lt; #{lastId}
    </if>
    <if test="keyword != null and keyword != ''">
      AND (
        name LIKE CONCAT(REPLACE(REPLACE(REPLACE(#{keyword}, '\\', '\\\\'), '%', '\\%'), '_', '\\_'), '%')
        OR email LIKE CONCAT(REPLACE(REPLACE(REPLACE(#{keyword}, '\\', '\\\\'), '%', '\\%'), '_', '\\_'), '%')
      )
    </if>
    <if test="excludeIds != null and excludeIds.size() > 0">
      AND id NOT IN
      <foreach collection="excludeIds" item="eid" open="(" separator="," close=")">#{eid}</foreach>
    </if>
  </where>
  ORDER BY id DESC
  LIMIT #{limit}
</select>

<select id="cursorPageUsersByCreatedAt" resultType="User">
  <!-- 首页 lastCreatedAt、lastId 都为空 -->
  SELECT id, name, email, status, created_at
  FROM user
  <where>
    <if test="lastCreatedAt != null">
      AND (
        created_at &lt; #{lastCreatedAt}
        OR (created_at = #{lastCreatedAt} AND id &lt; #{lastId})
      )
    </if>
    <if test="keyword != null and keyword != ''">
      AND (
        name LIKE CONCAT(REPLACE(REPLACE(REPLACE(#{keyword}, '\\', '\\\\'), '%', '\\%'), '_', '\\_'), '%')
        OR email LIKE CONCAT(REPLACE(REPLACE(REPLACE(#{keyword}, '\\', '\\\\'), '%', '\\%'), '_', '\\_'), '%')
      )
    </if>
    <if test="excludeIds != null and excludeIds.size() > 0">
      AND id NOT IN
      <foreach collection="excludeIds" item="eid" open="(" separator="," close=")">#{eid}</foreach>
    </if>
  </where>
  ORDER BY created_at DESC, id DESC
  LIMIT #{limit}
</select>
```

`limit` 传 `pageSize + 1`。首页对应参数留空，语句里就没有游标条件。上一页用本节前面的完整 SQL。

---

## 五、索引

```sql
-- 页码和游标按 id DESC：用主键

-- 等值列在前，游标列在后。例如 status = ? AND id < ?
CREATE INDEX idx_status_id ON user (status, id);

-- 页码和游标按 created_at DESC, id DESC
CREATE INDEX idx_created_id ON user (created_at, id);
```

> `(name, id)` 能沿索引取下一页的条件是 `name = 常量 AND id < ? ORDER BY id DESC`。`LIKE 'kw%'` 已经是 `name` 上的范围，后面的 `id` 不能再定位，也不能代替 `ORDER BY id`。`name` 和 `email` 的 `OR` 不能共用一条联合索引。

---

## 六、深页代价

| 方式 | 第 1 页 | 第 1000 页 |
|------|---------|-----------|
| `LIMIT 20 OFFSET 20000` | 快 | 扫描并丢掉 2 万行 |
| `WHERE id < :lastId ORDER BY id DESC LIMIT 20` | 快 | 从 lastId 往前取 20 行 |

「只取 20 行」成立的前提是：排序和主键一致，而且没有要大量过滤的额外条件。两种实现加上 `name LIKE 'kw%' OR email LIKE 'kw%'` 之后，都可能为了凑满一页多读很多行。游标深页仍然不用先丢掉前面所有页。

---

## 七、注意事项

1. **页码**：`offset = (page - 1) * pageSize`。并发插入或删除会让后面的页平移，同一行可能在相邻两页各出现一次，也可能被跳过。
2. **游标首页**：`lastId` 为空，走没有 `id <` 的那条完整 SQL。`created_at` 排序时 `lastCreatedAt` 也为空。`id < NULL` 的结果是空集。空字符串和超大哨兵值都会漏行。
3. **游标翻过的数据**：游标列和 `ORDER BY` 一致、游标列本身不变时，已经翻过的行不会再次出现。翻页期间新插入的更大 id 落在已翻过的位置，继续往后翻看不到；还没翻到就被删除的行也不会出现。
4. **稳定排序**：`created_at` 单独排序不够，两种实现都加上 `id`。
5. **keyword**：前缀才能用索引；通配符按第二节转义。页码和游标共用这一套。
6. **hasMore**：页码用 `page * pageSize < total`。游标多查 1 行，行数大于 `pageSize` 才为 `true`，游标取 `list` 的最后一条。

---

## 八、一句话总结

> **要跳页、要 total，用 `LIMIT / OFFSET`，深页会先丢掉前面的行。** 游标首页 `lastId` 为空；下一页 `id` 倒序用 `id < :lastId`，`created_at` 倒序用 `(created_at, id)`。两种模式各用自己的完整 SQL。