# Pydantic V2：`model_dump` 与 `model_validate` 参数详解

在 Pydantic V2 中，`model_dump` 负责将模型实例序列化为字典（或 JSON），而 `model_validate` 负责将外部数据校验并解析为模型实例。这两个方法取代了 V1 中的 `.dict()` 和 `.parse_obj()` 等旧 API，底层由 Rust 核心驱动，性能显著提升。以下基于官方文档及权威资料，逐一梳理二者的关键参数。

---

## 一、`model_dump` 参数详解

`model_dump` 用于将模型转换为 Python 字典。其常用参数集中在**字段筛选**、**序列化行为控制**以及**上下文传递**上。

### 1. `include` 与 `exclude`

用于精确控制哪些字段被输出。二者均可接受 `set` 或嵌套 `dict`。

- **集合形式**：直接指定字段名集合。例如 `exclude={'password', 'token'}` 会排除这两个字段。
- **字典形式**：支持嵌套选择。键为字段名，值为 `True` 表示包含/排除该字段，或继续用嵌套字典深入子模型。**注意：不支持 `False` 值**，若要“不包含”，应从集合中移除该键。
- **列表/元组中的特殊处理**：当对子模型列表进行逐元素筛选时，需使用整数索引作为键；若要对列表中**所有**子模型排除某字段，使用键 `'__all__'`。

### 2. `exclude_unset`、`exclude_defaults`、`exclude_none`

这三个布尔参数用于按“字段状态”批量过滤，优先级关系值得注意：

- `exclude_unset=True`：排除在模型实例化时**未显式传入**的字段（即使有默认值）。
- `exclude_defaults=True`：排除值等于**字段默认值**的字段。
- `exclude_none=True`：排除值为 `None` 的字段。

**优先级说明**：若在 `Field()` 构造器中设置了 `exclude=True`，该字段**始终**被排除，不受 `include` 参数影响；但 `exclude_unset` / `exclude_defaults` / `exclude_none` 的运行时参数**可以覆盖** `Field(exclude=False)` 的行为（即字段本不排除，但因值为 `None` 或默认值而被排除）。

### 3. `serialize_as_any`

控制是否启用“鸭子类型”序列化。默认为 `False`，即严格按模型声明的 **schema** 输出。若设为 `True`，序列化时会忽略基类 schema，转而询问对象本身的实际类型，从而将**子类特有字段**也包含在输出中。

**典型场景**：当字段的标注类型为基类，但实际存入的是子类实例，且你希望输出子类的全部字段时，需开启此参数。

### 4. `context`

向序列化过程传递额外的上下文数据。该参数的值会出现在被 `@field_serializer` 装饰的函数中的 `info.context` 里，允许你根据运行时条件动态改变序列化逻辑（例如根据上下文中的权限集合决定是否输出敏感字段）。

---

## 二、`model_validate` 参数详解

`model_validate` 是 Pydantic V2 中校验任意 Python 对象（通常是字典）并构造模型实例的入口。以下参数均为**仅关键字参数**（keyword-only）。

### 1. `strict`

控制是否启用**严格模式**。默认为 `None`（遵循模型配置或全局设置）。设为 `True` 时：

- 禁止宽松的类型强制转换。例如，`int` 字段收到字符串 `"123"` 时，在非严格模式下会转为 `123`，严格模式下则抛出 `ValidationError`。
- 对 JSON 输入（如 `model_validate_json`）的严格程度与 Python 输入略有差异，需注意区分。

### 2. `extra`

控制如何处理输入数据中**模型未定义**的额外字段。接受 `'allow'`、`'ignore'`、`'forbid'` 之一：

- `'allow'`：允许额外字段，并将其保存为模型属性（需模型配置支持）。
- `'ignore'`：静默忽略额外字段。
- `'forbid'`：遇到额外字段时抛出校验错误。

该参数会覆盖模型类中 `ConfigDict(extra=...)` 的配置。

### 3. `from_attributes`

设为 `True` 时，Pydantic 会尝试从对象的**属性**（而非仅从字典键）读取数据。这取代了 V1 中的 `from_orm` 或 `orm_mode`，用于将 ORM 对象或任意带有属性的对象转换为 Pydantic 模型。

### 4. `context`

向校验过程传递上下文对象。该值可在 `@field_validator` 或 `@model_validator` 中通过 `info.context` 访问，用于实现依赖外部状态的校验逻辑（例如根据上下文中的用户角色决定字段是否必填）。

### 5. `by_alias` 与 `by_name`

这两个参数控制校验时**使用字段的别名还是字段名**来匹配输入数据的键：

- `by_alias=True`：优先用字段的别名（`alias`）去匹配输入键。
- `by_name=True`：优先用字段本身的名称去匹配输入键。
- 二者可同时使用，此时输入数据中只要匹配到别名或名称之一即视为有效。

若模型未定义别名，这两个参数通常不影响校验结果。

---

## 三、速查对照表

| 方法 | 参数 | 类型 | 核心作用 |
| :--- | :--- | :--- | :--- |
| `model_dump` | `include` / `exclude` | set / dict | 字段级或嵌套级的输出筛选 |
| | `exclude_unset` | bool | 排除未显式设置的字段 |
| | `exclude_defaults` | bool | 排除等于默认值的字段 |
| | `exclude_none` | bool | 排除值为 `None` 的字段 |
| | `serialize_as_any` | bool | 启用鸭子类型序列化（输出子类字段） |
| | `context` | Any | 传递序列化上下文 |
| `model_validate` | `strict` | bool \| None | 严格类型校验 |
| | `extra` | str \| None | 控制额外字段的处理策略 |
| | `from_attributes` | bool \| None | 从对象属性读取数据 |
| | `context` | Any | 传递校验上下文 |
| | `by_alias` / `by_name` | bool \| None | 控制键匹配策略（别名 vs 字段名） |

---

## 四、迁移提示

若从 Pydantic V1 迁移而来，需注意方法名变更：`parse_obj` → `model_validate`，`dict` → `model_dump`，`from_orm` → `model_validate(..., from_attributes=True)`。V1 的旧方法在 V2 中已被移除。