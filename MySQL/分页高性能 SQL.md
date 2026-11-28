# 分页高性能 SQL

> 核心：用 `id < :lastId` 替代 `OFFSET`，避免深分页扫描丢弃，`WHERE` 直接命中索引范围。

---

## 一、最终高性能 SQL（推荐）

```sql
-- 参数：:kw 关键字, :excludeIds 排除列表, :lastId 上一页最后一条 id, :pageSize
SELECT 
    u.id, u.name, u.email, u.status, u.created_at
FROM user u
INNER JOIN (
    SELECT id
    FROM user
    WHERE id < :lastId                              -- 游标：从上次最后一条往前
      AND (name LIKE CONCAT(:kw, '%') OR email LIKE CONCAT(:kw, '%'))
      AND id NOT IN (:excludeIds)                   -- 排除列表（< 100 个）
    ORDER BY id DESC
    LIMIT :pageSize
) t ON t.id = u.id
ORDER BY u.id DESC;
```

**首屏**：`:lastId` 传 `Long.MAX_VALUE`（或超大值 `9999999999`），等价于从头开始。

**返回结构**（给前端）：

```json
{
  "list": [ ... ],
  "nextCursor": 10233,      // 本页最后一条 id，下一页传这个
  "hasMore": true
}
```

> 下一页 `lastId = 本页最后一条 id`；`hasMore = 本页返回条数 == pageSize`。

---

## 二、索引设计（关键）

```sql
-- 覆盖 id 范围 + 排序 + 过滤列
CREATE INDEX idx_name_id   ON user (name, id);
CREATE INDEX idx_email_id  ON user (email, id);

-- 若列表按 created_at 排序，则游标换成 (created_at, id) 复合游标
CREATE INDEX idx_created_id ON user (created_at, id);
```

> 联合索引 **过滤列在前、游标列在后**，让 `id < :lastId` 的 range scan 直接生效。

---

## 三、为什么比 OFFSET 快

| 方式 | 第 1 页 | 第 1000 页 |
|------|---------|-----------|
| `LIMIT 20 OFFSET 20000` | 快 | 扫描并丢弃 2 万行 ❌ |
| `WHERE id < :lastId LIMIT 20` | 快 | **只读 20 行** ✅ |

游标分页的 `WHERE id < :lastId` 是**索引范围定位**，不随页码增长而变慢，复杂度 O(pageSize)。

---

## 四、exclude 列表的优化分支

```sql
-- exclude <= 100：直接 NOT IN（简单可用）
AND id NOT IN (:excludeIds)

-- exclude > 100：走 NOT EXISTS + 临时表 / Redis Set
AND NOT EXISTS (
    SELECT 1 FROM user_exclude e
    WHERE e.user_id = user.id AND e.batch_id = :batchId
)
```

> 大规模 exclude 建议在**应用层/Redis 过滤**，SQL 只做游标范围扫描，避免 `NOT IN` 拖垮索引选择。

---

```sql
-- 参数：:kw 关键字, :excludeIds 排除列表, :pageSize, :offset
SELECT 
    u.id, u.name, u.email, u.status, u.created_at
FROM user u
INNER JOIN (
    SELECT id
    FROM user
    WHERE (name LIKE CONCAT(:kw, '%') OR email LIKE CONCAT(:kw, '%'))
      AND id NOT IN (:excludeIds)          -- < 100 个 id
    ORDER BY id DESC
    LIMIT :pageSize OFFSET :offset
) t ON t.id = u.id
ORDER BY u.id DESC;
```

## 五、多列排序的游标（created_at 场景）

若按 `created_at DESC, id DESC` 排序（时间可能重复，需 id 兜底）：

```sql
SELECT u.id, u.name, u.email, u.created_at
FROM user u
INNER JOIN (
    SELECT id
    FROM user
    WHERE (:lastId IS NULL OR id < :lastId) -- 首屏 lastId=NULL；
      AND (name LIKE CONCAT(:kw, '%') OR email LIKE CONCAT(:kw, '%'))
      AND id NOT IN (:excludeIds)
    ORDER BY created_at DESC, id DESC
    LIMIT :pageSize
) t ON t.id = u.id
ORDER BY u.created_at DESC, u.id DESC;
```

> 索引：`CREATE INDEX idx_created_id ON user (created_at, id);`

---

## 六、MyBatis 动态 SQL

```xml
<select id="cursorPageUsers" resultType="User">
  SELECT u.id, u.name, u.email, u.status, u.created_at
  FROM user u
  INNER JOIN (
    SELECT id FROM user
    <where>
      <if test="lastId != null">
        AND id &lt; #{lastId}
      </if>
      <if test="keyword != null and keyword != ''">
        AND (name LIKE CONCAT(#{keyword}, '%') OR email LIKE CONCAT(#{keyword}, '%'))
      </if>
      <if test="excludeIds != null and excludeIds.size() > 0">
        AND id NOT IN
        <foreach collection="excludeIds" item="eid" open="(" separator="," close=")">#{eid}</foreach>
      </if>
    </where>
    ORDER BY id DESC
    LIMIT #{pageSize}
  ) t ON t.id = u.id
  ORDER BY u.id DESC
</select>
```

---

## 七、注意事项

1. **首屏 lastId**：传 `null` 或用 `WHERE 1=1` 分支跳过，避免 `id < NULL` 查不到数据。
2. **不能跳页**：游标分页天然只支持"下一页/上一页"，不支持随机跳页——这是性能换来的取舍。
3. **数据变动**：新增/删除会导致游标偏移（正常现象，翻页以 id 为锚点，不会重复/漏数据）。
4. **count 总数**：游标分页通常**不返回 total**；若前端需要总数，单独走覆盖索引 `COUNT(*)`，或接受近似值。
5. **keyword 大表**：`LIKE 'kw%'` 才能走索引；`%kw%` 请交 ES，否则游标再快也是全表扫描。

---

## 八、一句话总结

> **`WHERE id < :lastId ORDER BY id DESC LIMIT N` + 联合索引（过滤列, id）** 是游标分页的性能内核：范围定位、不回退、复杂度恒定 O(pageSize)，深分页不再退化。