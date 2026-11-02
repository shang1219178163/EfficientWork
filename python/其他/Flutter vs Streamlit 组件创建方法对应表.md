# Flutter vs Streamlit 组件创建方法对应表

Flutter 和 Streamlit 的设计哲学差异很大：Flutter 是声明式的 UI 框架，一切皆 Widget，由开发者精细控制布局与状态；Streamlit 是数据应用框架，以 `st.` 开头的命令式函数快速生成界面，布局能力相对简化。因此下表中的对应关系并非完全对等，更多是**功能意图上的近似映射**。

| Flutter | Streamlit | 说明 |
| :--- | :--- | :--- |
| `Text("Hello")` | `st.write("Hello")` / `st.text("Hello")` | Flutter 用 `Text` Widget 显示文本；Streamlit 的 `st.write` 更通用，可自动渲染多种类型，`st.text` 则纯文本 |
| `Row(children: [...])` | `st.container(horizontal=True)` | Flutter `Row` 实现水平线性布局；Streamlit 用水平容器实现类似效果，子元素按内容宽度排列 |
| `Column(children: [...])` | `st.container()`（默认垂直） | Flutter `Column` 实现垂直线性布局；Streamlit 默认容器即为垂直堆叠 |
| `Container(...)` | `st.container()` / `st.empty()` | Flutter `Container` 是带装饰、尺寸约束的盒子；Streamlit 的 `st.container` 是布局容器，`st.empty` 是单元素占位容器 |
| `Scaffold` + `AppBar` | `st.set_page_config()` + `st.sidebar` | Flutter 用 `Scaffold` 提供页面骨架、`AppBar` 做顶栏；Streamlit 通过页面配置和侧边栏实现类似结构 |
| `ListView` / `SingleChildScrollView` | `st.container(height=...)` 自动滚动 | Flutter 需要专门的滚动 Widget；Streamlit 在固定高度容器或长内容中会自动处理滚动 |
| `TextField` / `TextFormField` | `st.text_input()` / `st.text_area()` | 文本输入。Flutter 需管理 `TextEditingController`；Streamlit 直接返回当前输入值 |
| `ElevatedButton` / `TextButton` | `st.button()` | 按钮。Flutter 通过 `onPressed` 回调处理点击；Streamlit 按钮返回布尔值，脚本重新运行时根据该值判断 |
| `Checkbox` / `Switch` | `st.checkbox()` / `st.toggle()` | 布尔选择。Streamlit 直接返回布尔值 |
| `DropdownButton` / `PopupMenuButton` | `st.selectbox()` | 下拉单选。Streamlit 一行代码完成，无需管理菜单控制器 |
| `Radio` / `RadioListTile` | `st.radio()` | 单选按钮组。Streamlit 直接传入选项列表即可 |
| `Slider` | `st.slider()` | 滑块。Streamlit 支持单值或范围选择，直接返回数值 |
| `GridView` | `st.columns()` | 网格/多列布局。Flutter `GridView` 用于灵活网格；Streamlit `st.columns` 按比例划分列宽，适合并排排列 |
| `TabBar` + `TabBarView` | `st.tabs()` | 标签页切换。Streamlit 的 `st.tabs` 返回多个容器，用 `with` 语句填充内容 |
| `ExpansionTile` | `st.expander()` | 可折叠区域。Streamlit 用 `with` 语句块将内容放入展开器 |
| `Dialog` / `showDialog` | `@st.dialog` 装饰器 | 模态对话框。Streamlit 通过装饰器定义对话框函数，调用时弹出 |
| `Image.asset` / `Image.network` | `st.image()` | 图片显示。Streamlit 自动处理网络图片或本地文件 |
| `AudioPlayer`（第三方） | `st.audio()` | 音频播放。Streamlit 原生支持，传入文件路径或字节数据即可 |
| `VideoPlayer`（第三方） | `st.video()` | 视频播放。同样原生支持 |
| `FilePicker`（第三方） | `st.file_uploader()` | 文件上传。Streamlit 返回上传的文件对象，可直接读取 |
| `setState(() {...})` + 状态变量 | **无直接对应**（靠脚本重跑 + `st.session_state`） | Flutter 显式调用 `setState` 触发重建；Streamlit 每次交互都会重新执行脚本，用 `st.session_state` 在重跑间保持状态 |

**核心差异**：Flutter 中几乎一切都需要手动构建 Widget 树并管理状态；Streamlit 则将常见 UI 模式封装为单个函数调用，代价是布局精细控制能力较弱。如果你需要在 Streamlit 中实现复杂布局，通常需要结合 `st.container` 的参数（如 `horizontal`、`gap`、`wrap`）来逼近 Flutter 的布局效果。