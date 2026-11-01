# 在 Mac 上把 Claude Code 接入 DeepSeek

DeepSeek 提供 Anthropic 兼容端点，Claude Code 只要改 base_url、API Key 和模型名就能直接用，不需要装任何中间层工具。

## 一、前置检查

确认 `claude` 命令可用：

```bash
which claude && claude --version
```

有版本号输出说明已经装好。没有的话先装 Node 18+ 再安装：

```bash
node -v
npm install -g @anthropic-ai/claude-code
```

API Key 在 [DeepSeek 开放平台](https://platform.deepseek.com/api_keys) 创建。

## 二、跳过新用户引导流程/登录

### 跳过新用户引导流程/登录

/Users/用户名/.claude.json
尾部添加一个新设置选项："hasCompletedOnboarding": true , 复制以下内容, 但是需要删除 //及之后的内容

```json
{
  "hasCompletedOnboarding":true  // 末尾新增选项，表示跳过新用户引导流程
}
```

## 三、配置 `~/.claude/settings.json`

配置写在用户级配置文件里，对所有项目生效。

### 先看文件是否已有内容

这一步不能省。直接覆盖写入会把原有的 hooks、permissions、状态栏等配置全部冲掉。

```bash
cat ~/.claude/settings.json 2>/dev/null
```

### 情况一：文件不存在或为空

直接生成完整配置：

```bash
mkdir -p ~/.claude
cat > ~/.claude/settings.json <<'EOF'
{
  "env": {
    "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
    "ANTHROPIC_AUTH_TOKEN": "sk-你的DeepSeekKey",
    "ANTHROPIC_MODEL": "deepseek-flash",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek-flash",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek-flash",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek-flash",
    "CLAUDE_CODE_SUBAGENT_MODEL": "deepseek-flash",
    "CLAUDE_CODE_EFFORT_LEVEL": "max",
    "CLAUDE_CODE_AUTO_COMPACT_WINDOW": "786432"
  }
}
EOF
```

heredoc 的 `<<'EOF'` 单引号必须保留，否则 shell 会把 `[1m]` 里的方括号当通配符解析。

### 情况二：文件已有内容

先备份：

```bash
cp ~/.claude/settings.json ~/.claude/settings.json.bak
```

然后用编辑器打开，把上面 JSON 里的 `env` 对象合并进去：

- 已有 `"env"` 字段：只往里追加这些键，不要替换整块。
- 没有 `"env"` 字段：在顶层对象里新增一个 `"env"` 字段。

改完检查 JSON 语法：

```bash
jq . ~/.claude/settings.json
```

没装 jq 的话用：

```bash
python3 -m json.tool ~/.claude/settings.json
```

### 模型说明

`deepseek-flash[1m]` 是 1M 上下文版本，分配给主模型和 opus/sonnet 槽位；`deepseek-flash` 不带长上下文，给 haiku 槽位和子代理使用，可以省 token。

如果不显式指定模型名，DeepSeek 服务端会做映射：`claude-opus` 开头的映射到 `deepseek-v4-pro`（按 V4 Pro 计费），`claude-sonnet` / `claude-haiku` 开头的映射到 `deepseek-flash`。

## 三、验证

进入任意项目目录启动：

```bash
cd ~/你的项目
claude
```

进入交互界面后输入 `/status`，确认 base_url 指向 `api.deepseek.com`、模型为 `deepseek-flash` 即配置成功。

不想进交互界面的话，用一次性调用快速测试：

```bash
claude -p "你好"
```

## 四、常见问题

**启动报 `Invalid API key`**：Key 复制时带了空格或引号。检查一下：

```bash
echo $ANTHROPIC_AUTH_TOKEN
```

或者重新从平台复制，注意不要带首尾空白。

**报模型不存在**：`deepseek-v4-flash-vision-exp` 这类旧型号名已不是有效值，改成 `deepseek-flash` 或 `deepseek-flash[1m]`。

**连接超时或 Connection refused**：这是网络问题不是配置问题，不用继续折腾 Claude Code 的配置。先查 ClashX 的实际监听端口：

```bash
lsof -nP -iTCP -sTCP:LISTEN | grep -i clash
```

再确认系统代理和终端里的 `HTTP_PROXY` / `HTTPS_PROXY` 指向的是同一个端口。

**已安装 CC-Switch 且接管了 claude**：CC-Switch 会自行改写 base_url 指向本地转发端口，与 settings.json 里的 env 配置互相打架。两种方式二选一，用文件配置前先在 CC-Switch 里关掉或切走 claude 那一项。

**配置改了但没生效**：确认没有在 `~/.zshrc` 里也 export 了同名变量，shell 环境变量和 settings.json 可能互相覆盖。

## 五、附：环境变量一览

| 变量 | 值 | 说明 |
| --- | --- | --- |
| `ANTHROPIC_BASE_URL` | `https://api.deepseek.com/anthropic` | DeepSeek 的 Anthropic 兼容端点 |
| `ANTHROPIC_AUTH_TOKEN` | `sk-...` | DeepSeek API Key |
| `ANTHROPIC_MODEL` | `deepseek-flash[1m]` | 主模型 |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | `deepseek-flash` | opus 槽位映射 |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | `deepseek-flash` | sonnet 槽位映射 |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | `deepseek-flash` | haiku 槽位映射 |
| `CLAUDE_CODE_SUBAGENT_MODEL` | `deepseek-flash` | 子代理模型 |
| `CLAUDE_CODE_EFFORT_LEVEL` | `max` | 推理强度 |
| `CLAUDE_CODE_AUTO_COMPACT_WINDOW` | `786432` | 自动压缩窗口 |

## 六、安全提醒

`ANTHROPIC_AUTH_TOKEN` 是明文保存在 `settings.json` 里的。不要把这个文件提交进 git，也不要同步到公开仓库。想长期使用也可以在 `~/.zshrc` 里 export，效果一样但同样要注意别泄露。

另外 DeepSeek 原生支持 Claude Code 的 Web Search 功能，模型判断需要联网时会自动调用，搜索请求本身按 Search API 单独计费。

## 七、claudecode的权限控制

1.1.1 配置文件方式
为了减少点击yes的频率，我们可以给claudecode放开一定的权限，比如：读写文件等。
配置方式如下：
- 打开Claude Code 的全局配置文件，位于 ~/.claude/settings.json
- 添加如下内容，然后重启claudecode 即可：

```json  
"permissions": {
    "allow": [
      "Read",
      "Write",
      "Bash(npm *)",
      "Bash(git *)",
      "Bash(node *)"
    ],
    "deny": [
      "Bash(rm -rf *)"
    ]
  },
  "autoCompactThreshold": 80
```

内容解释：
```
{
  "env": {
    "ANTHROPIC_BASE_URL": "大模型的的BASE_URL",
    "ANTHROPIC_AUTH_TOKEN": "自己的APIKEey",
    "API_TIMEOUT_MS": "3000000",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1",
    "ANTHROPIC_MODEL": "大模型的名字",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "大模型的名字",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "大模型的名字",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "大模型的名字"
  }, // 注意这里要加个逗号，跟昨天的模型配置加以区分
  "permissions": {  // 给claudecode添加的权限
   "allow": [ // 允许的权限
     "Read",  // 读取文件中的内容      
     "Write", // 写入文件      
     "Bash(npm *)", // npm命令  
     "Bash(git *)", // git命令   
     "Bash(node *)" // node命令  
   ],
   "deny": [ // 禁止的权限
     "Bash(rm -rf *)"  // 全局删除
   ]
  },
  "autoCompactThreshold": 80 // 上下文达到80%的时候自动压缩
}
```

#### 7.1.2 快捷键方式

在claudecode中，还可以通过快捷键控制权限，可以让他一次性生成结束，不需要我们反复点击YES，但是该方案风险较高。
快捷键：Shift + Tab

plan mode on 计划模式
manual mode on（手控方式）：所有操作需确认 
accept edits on（接受编辑）：自动接受文件编辑（读写）
auto mode on（自动方式）：自动执行所有命令（其他命令 + 文件编辑）
> 注：如果自动模式下，报错XX模型暂时并不可用，要切回手动模式。自动模式安全级别高，某些操作是禁止的。


## 八、claudecode的常见命令

/clear 完全清空当前对话
开始全新的任务时。

/btw 该命令下的对话不会记入上下文，适合临时提问
主任务进行中想问个无关问题。

/context 详细查看上下文中每个模块占比
优化 token、诊断哪里挨上下文。

/compact 压缩当前对话的上下文 [会话信息少,不需要]
对话太长，AI开始“遗忘”早期内容时。

/init 自动生成项目的 CLAUDE.md
进入新项目后的第一件事。

/rewind 回退到某个节点
说错几句话，不污染上下文。

双击esc 停止/回退(重点!!!!!)
如果claudecode正在执行，停止当前操作，如果claudecode没有执行，等同于/rewind。

## 九、claudecode宪法
概述：claudecode执行的时候要遵守的规则
定义：在执行的时候遵守的规则，就是claude.md文件

```
核心行为准则
1. 所有回答都需要使用简体中文。
2. 遇到配置文件中deny绝对禁止的操作，立即停止并提醒我，不要尝试其他方式执行。
3. 在任何情况下，都禁止修改settings.json文件。

工作流程
1. 创建 CHANGELOG.md 文档，用户每次需求修改都要记录日期时间，方便追溯。
2. 生成代码时，文件名、变量名、函数名等命名要简洁明了，见名知意。
3. 遇到报错时，先用通俗的中文解释错误含义，再给修复方案。
```

####  文件位置
他可以放在任意的目录下，但是一般我们只会在三个层级进行配置：
全局配置、项目根目录和模块子目录
- 全局配置：
  位于：~\.claude\CLAUDE.md：他是全局的配置，所有项目都需要遵守的规则。
- 项目根目录：
位于：项目文件夹\CLAUDE.md：他是本项目的配置，本项目中需要遵守的规则。
- 模块子目录：
  位于：项目文件夹\模块文件夹\CLAUDE.md：他是单独模块的配置，当前模块需要遵守的规则。
  
####  优先级
概述：如果在全局中/项目中/模块中 有定义了相同规则的宪法，那么会遵循就近原则
就近原则：
    离当前代码目录越近的 CLAUDE.md，优先级越高；越靠近你当前工作目录，规则越优先生效