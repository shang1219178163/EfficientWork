# Pydantic V2 ConfigDict 常用配置项默认值补充

在 Pydantic V2 的 `ConfigDict` 中，部分配置项有明确的默认值，了解它们有助于判断是否需要显式设置。以下按之前分类补充各常用项的默认值说明。

## 数据校验与类型控制

- `extra`：默认 `'ignore'`，即忽略未定义的额外字段。
- `strict`：默认 `False`，即非严格模式，允许一定的类型强制转换。
- `validate_assignment`：默认 `False`，仅在模型创建时校验，属性赋值时不校验。
- `revalidate_instances`：默认 `'never'`，即嵌套模型实例在验证时不会重新校验。
- `coerce_numbers_to_str`：默认 `False`，Pydantic 默认不允许将数字自动转为字符串。

## 字符串处理

- `str_strip_whitespace`：默认 `False`，不去除首尾空白。
- `str_to_lower` / `str_to_upper`：默认 `False`，不转换大小写。
- `str_min_length`：默认 `None`，不限制最小长度。
- `str_max_length`：默认 `None`，不限制最大长度。

## 模型行为与序列化

- `frozen`：默认 `False`，模型可变。注意 V1 中对应的是 `allow_mutation=True`，V2 语义相反。
- `populate_by_name`：默认 `False`，即使用别名时，不能用字段名填充。V2.11+ 建议改用 `validate_by_name` 与 `validate_by_alias` 组合控制。
- `use_enum_values`：默认 `False`，填充时保留原始枚举成员，而非其 `value`。
- `from_attributes`：默认 `False`，不从对象属性创建模型（V1 的 `orm_mode` 需显式开启）。

## JSON Schema 定制

- `title`：默认使用模型类名作为 Schema 标题。
- `json_schema_extra`：默认 `None`，不添加额外 Schema 属性。
- `json_schema_serialization_defaults_required`：默认 `False`，序列化 Schema 中有默认值的字段不标记为必需。

## 其他实用项

- `arbitrary_types_allowed`：默认 `False`，不允许任意用户自定义类型作为字段类型。
- `protected_namespaces`：默认值随版本变化。V2.10 之前为 `('model_',)`，V2.10 起调整为 `('model_validate', 'model_dump')`，以允许 `model_id` 等字段名。
- `hide_input_in_errors`：默认 `False`，校验错误信息中会显示输入值。
- `loc_by_alias`：默认 `True`，错误定位信息中使用别名而非字段名。

> **提示**：未在官方文档中明确标注默认值的配置项（如 `validate_default`、`ser_json_bytes` 等），其默认行为以 Pydantic 实际版本源码为准，建议使用时查阅对应版本的源码或通过简单测试确认。