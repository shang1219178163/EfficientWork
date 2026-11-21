# Pandas 常用属性与方法总结

## 一、数据结构创建

```python
import pandas as pd
import numpy as np

# Series
s = pd.Series([1, 2, 3], index=['a', 'b', 'c'], name='nums')

# DataFrame 常用创建方式
df = pd.DataFrame({'A': [1, 2], 'B': [3, 4]})
df = pd.DataFrame(np.random.randn(3, 4), columns=list('ABCD'))
df = pd.read_csv('file.csv')        # 读CSV
df = pd.read_excel('file.xlsx')     # 读Excel
df = pd.read_json('file.json')      # 读JSON
df = pd.read_sql(query, conn)       # 读数据库
```

## 二、数据查看（属性/方法）

| 属性/方法 | 说明 |
|---|---|
| `df.shape` | 行列数 (行, 列) |
| `df.size` | 元素总数 |
| `df.ndim` | 维度数 |
| `df.columns` | 列名 |
| `df.index` | 行索引 |
| `df.dtypes` | 各列数据类型 |
| `df.values` | 转为 numpy 数组 |
| `df.T` | 转置 |
| `df.head(n)` | 前 n 行（默认5） |
| `df.tail(n)` | 后 n 行 |
| `df.sample(n)` | 随机抽样 |
| `df.info()` | 数据概览（类型、非空数、内存） |
| `df.describe()` | 数值列统计描述 |
| `df.describe(include='object')` | 类别列统计 |
| `df.nunique()` | 每列唯一值数量 |
| `df['col'].value_counts()` | 值计数 |
| `df.memory_usage()` | 内存占用 |

## 三、数据选取

```python
# 列选择
df['A']            # 单列 -> Series
df[['A', 'B']]     # 多列 -> DataFrame

# 行选择
df.loc[0]              # 按标签
df.loc[0:2, 'A':'B']   # 标签切片
df.iloc[0]             # 按位置
df.iloc[0:3, 0:2]      # 位置切片
df.at[0, 'A']          # 单个值（标签，快速）
df.iat[0, 0]           # 单个值（位置，快速）

# 布尔索引
df[df['A'] > 1]
df[(df['A'] > 1) & (df['B'] < 5)]   # 用 & | ~，不能用 and/or/not
df.query("A > 1 and B < 5")         # 查询字符串

# isin / between
df[df['A'].isin([1, 3])]
df[df['A'].between(1, 3)]
```

## 四、数据清洗

```python
df.isnull() / df.notnull()      # 判断缺失
df.isna().sum()                 # 各列缺失数
df.dropna(axis=0, how='any')    # 删除缺失行
df.fillna(0)                    # 填充
df.fillna(method='ffill')       # 前向填充
df['col'].fillna(df['col'].mean())

df.duplicated()                 # 判断重复
df.drop_duplicates()            # 去重
df.drop_duplicates(subset=['A'], keep='first')

df.astype({'A': 'int32'})       # 类型转换
pd.to_numeric(df['A'], errors='coerce')
pd.to_datetime(df['date'])
df['col'].str.strip()           # 字符串方法（.str 访问器）
df['col'].str.contains('x')
df['col'].str.replace('a', 'b')
df['col'].str.split(',', expand=True)

df.rename(columns={'A': 'a'})
df.set_index('col')
df.reset_index(drop=True)
```

## 五、数据操作

```python
# 增删列
df['new'] = df['A'] + df['B']
df['new'] = df['A'].apply(lambda x: x * 2)
df['new'] = df['A'].map({1: 'x', 2: 'y'})
df.drop(columns=['A'])
df.insert(0, 'col', values)

# 排序
df.sort_values('A', ascending=False)
df.sort_values(['A', 'B'])
df.sort_index()

# 排名
df['rank'] = df['A'].rank(ascending=False)

# apply / map / applymap
df['A'].map(func)               # Series 元素映射
df['A'].apply(func)             # Series 应用函数
df.apply(func, axis=0)          # 按列应用
df.apply(func, axis=1)          # 按行应用
df.applymap(func)               # 整个 DataFrame 逐元素（已弃用，用 df.map）
```

## 六、合并与连接

```python
pd.concat([df1, df2], axis=0, ignore_index=True)   # 纵向拼接
pd.concat([df1, df2], axis=1)                      # 横向拼接
pd.merge(df1, df2, on='key', how='inner')          # 内连接
df1.join(df2, on='key', how='left')                # 按索引连接
```

## 七、分组与聚合

```python
df.groupby('A').mean()
df.groupby(['A', 'B']).agg({'C': 'sum', 'D': 'mean'})
df.groupby('A')['B'].agg(['sum', 'mean', 'count'])
df.groupby('A').apply(func)        # 自定义函数
df.pivot_table(values='C', index='A', columns='B', aggfunc='sum')
pd.crosstab(df['A'], df['B'])      # 交叉表
df.groupby('A').size()             # 每组大小
```

## 八、时间序列

```python
df['date'] = pd.to_datetime(df['date'])
df.set_index('date').resample('M').mean()    # 按月重采样
df['dt'].dt.year / .month / .day / .hour     # 提取时间属性
df['dt'].dt.dayofweek
pd.date_range('2023-01-01', periods=10, freq='D')
df.rolling(window=3).mean()                  # 滚动窗口
df.shift(1)                                  # 位移
df.pct_change()                              # 变化率
```

## 九、统计计算

```python
df.mean() / df.sum() / df.std() / df.var()
df.min() / df.max() / df.median()
df.quantile(0.75)
df.corr()                  # 相关系数矩阵
df.cov()                   # 协方差矩阵
df.cumsum()                # 累加
df.cumprod()               # 累乘
df.idxmax() / df.idxmin()  # 最值索引
df.nlargest(3, 'A')        # 最大3个
df.nsmallest(3, 'A')
```

## 十、输出

```python
df.to_csv('out.csv', index=False)
df.to_excel('out.xlsx', index=False)
df.to_json('out.json')
df.to_sql('table', conn, if_exists='replace')
df.to_dict()
df.to_numpy()
```

## 十一、高频技巧速查

```python
# 按条件赋值
df.loc[df['A'] > 0, 'B'] = 1

# 分箱
pd.cut(df['A'], bins=3, labels=['低','中','高'])
pd.qcut(df['A'], q=4)              # 等频分箱

# 交叉替换
df.replace({1: 'a', 2: 'b'})

# 每列最大值所在行
df.loc[df['A'].idxmax()]

# 条件计数
(df['A'] > 0).sum()

# 显示所有列/行（Jupyter）
pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)

# 去掉科学计数法
pd.set_option('display.float_format', lambda x: '%.2f' % x)
```

---

**要点记忆口诀**：查看用 `info/describe/head`，选取靠 `loc/iloc/[]`，清洗用 `dropna/fillna/duplicated`，聚合靠 `groupby/agg/pivot_table`，合并用 `merge/concat`。`apply` 灵活但慢，向量化运算优先。