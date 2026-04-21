# AI 编程工具指令格式调研

本文档记录了主流 AI 编程工具的指令文件格式、加载机制和适配策略。

---

## 总览

| 工具 | 指令文件 | 格式 | 加载方式 | 作用域 |
|------|---------|------|---------|--------|
| **Claude Code** | `CLAUDE.md` | Markdown | 启动时自动读取 | 项目级 |
| **Codex** | `AGENTS.md` | Markdown | 启动时自动读取 | 项目级/目录级 |
| **Cursor** | `.cursor/rules/*.mdc` | YAML frontmatter + Markdown | 按 `alwaysApply` 或语义匹配 | 项目级 |
| **OpenCode** | `AGENTS.md` | Markdown | 启动时自动读取 | 项目级/目录级 |
| **Antigravity** | `.agent/skills/*/SKILL.md` | YAML frontmatter + Markdown | 语义匹配按需激活 | 项目级/全局 |

---

## Claude Code

### 指令文件

- **主文件**：项目根目录的 `CLAUDE.md`
- **Skills**：`skills/<skill-name>/SKILL.md`，YAML frontmatter 包含 `name`、`description`、`license`
- **Marketplace**：`.claude-plugin/plugin.json` + `.claude-plugin/marketplace.json`

### 加载机制

1. 启动时读取项目根目录及父目录中的 `CLAUDE.md`
2. Skills 通过 marketplace 安装或手动放置
3. `CLAUDE.md` 内容作为系统指令注入对话上下文

### 格式要求

纯 Markdown，无 frontmatter 要求。Skills 的 `SKILL.md` 需要 YAML frontmatter：

```yaml
---
name: skill-name
description: One-line description for discovery
license: MIT
---
```

### 适配策略

直接输出 Markdown 即可。Skills 格式需要加 frontmatter。

---

## Codex (OpenAI)

### 指令文件

- **主文件**：项目根目录的 `AGENTS.md`
- 支持 monorepo 中每个子目录有自己的 `AGENTS.md`

### 加载机制

1. 启动时自动扫描当前目录及父目录的 `AGENTS.md`
2. 子目录的 `AGENTS.md` 会在进入该目录工作时额外加载
3. 内容作为系统指令注入

### 格式要求

纯 Markdown，无特殊格式要求。

### 适配策略

最简单的 target——直接输出 Markdown 文件，命名为 `AGENTS.md`。

参考：[Codex AGENTS.md 文档](https://developers.openai.com/codex/guides/agents-md)

---

## Cursor

### 指令文件

- **规则文件**：`.cursor/rules/*.mdc`
- 旧版也支持项目根目录的 `.cursorrules`（已弃用但仍兼容）

### 加载机制

Cursor 有两种规则激活模式：

1. **Always Apply**（`alwaysApply: true`）：每次对话都加载
2. **语义匹配**：根据 `description` 字段与当前任务的相关性决定是否加载

### 格式要求

`.mdc` 文件使用 YAML frontmatter + Markdown 正文：

```yaml
---
description: What this rule does and when to apply it
alwaysApply: true
---

# Rule content in Markdown
```

关键字段：
- `description`：规则描述，同时用于语义匹配触发
- `alwaysApply`：是否每次对话都自动加载
- `glob`（可选）：文件路径匹配，限定规则作用范围

### 适配策略

需要在 Markdown 内容前加 YAML frontmatter。对于通用行为准则，使用 `alwaysApply: true`。

参考：[Cursor Rules 文档](https://docs.cursor.com/context/rules)

---

## OpenCode

### 指令文件

- **行为指令**：`AGENTS.md`（首选），回退到 `CLAUDE.md`
- **工具配置**：`.opencode.json` 或 `~/.config/opencode/opencode.json`
- **全局指令**：`~/.config/opencode/AGENTS.md`

### 加载机制

指令加载优先级（从高到低）：

1. 项目目录及父目录中的 `AGENTS.md`
2. 若无 `AGENTS.md`，回退读取 `CLAUDE.md`
3. 全局 `~/.config/opencode/AGENTS.md`

同时自动读取兼容文件（如果存在）：
- `.github/copilot-instructions.md`
- `.cursorrules`
- `opencode.md`

### 格式要求

纯 Markdown。`opencode.json` 中可通过 `instructions` 字段指定额外规则文件：

```json
{
  "instructions": ["CONTRIBUTING.md", "docs/guidelines.md", "packages/*/AGENTS.md"]
}
```

### 适配策略

与 Codex 完全相同——输出 `AGENTS.md` 即可。OpenCode 原生兼容 `AGENTS.md` 格式。

参考：[OpenCode 官网](https://opencode.ai)，[GitHub](https://github.com/opencode-ai/opencode)

---

## Antigravity (Google)

### 指令文件

- **Agent Skills**：`.agent/skills/<skill-name>/SKILL.md`
- **全局 Skills**：`~/.gemini/antigravity/skills/<skill-name>/SKILL.md`
- **内置 Rules**：通过 IDE 内置配置设置

### 加载机制

Antigravity 使用**三阶段渐进式披露**机制：

1. **发现**：对话启动时扫描所有 Skills 的 `name` + `description`（约 100 tokens）
2. **激活**：根据 `description` 与当前任务的语义相关性决定是否加载完整内容
3. **执行**：按需加载 Skill 引用的脚本或文档

这意味着 `description` 字段**极其关键**——它决定了 Skill 是否会被触发。

### 格式要求

`SKILL.md` 使用 YAML frontmatter + Markdown：

```yaml
---
name: skill-name
description: >
  Multi-line description of what this skill does
  and when it should be activated.
---

# Skill content in Markdown
```

Skill 目录还可以包含辅助文件：

```
.agent/skills/your-skill/
├── SKILL.md          # 核心指令（必需）
├── scripts/          # 自动化脚本（可选）
└── examples/         # 参考案例（可选）
```

### 适配策略

需要 YAML frontmatter，且 `description` 要写得精确以确保语义匹配触发。建议 Skill 内容控制在 5000 tokens 以内。

**注意**：新建或修改 Skill 后需要开新 Chat Session 才能生效。

参考：[Antigravity 官网](https://antigravity.google)，[社区 Skills 库](https://github.com/rominirani/antigravity-skills)

---

## 各工具对比分析

### 格式复杂度

```
纯 Markdown          带 Frontmatter            结构化配置
    │                      │                       │
  Codex                 Cursor              (未来可能)
  OpenCode            Claude Skills
  Claude CLAUDE.md    Antigravity
```

### 兼容性关系

```
AGENTS.md ──── Codex（原生）
    │
    ├──── OpenCode（首选，原生支持）
    │
    └──── Antigravity（不支持，需要 .agent/skills/）

CLAUDE.md ──── Claude Code（原生）
    │
    └──── OpenCode（回退兼容）

.cursor/rules/*.mdc ──── Cursor（独有格式）

.agent/skills/*/SKILL.md ──── Antigravity（原生）
                                  │
                                  └──── GitHub Copilot（兼容）
```

### 适配策略总结

| 策略 | 适用 Target | 工作量 |
|------|------------|--------|
| 直接输出 Markdown | Codex, OpenCode, Claude `CLAUDE.md` | 最低 |
| 加 YAML frontmatter | Cursor, Claude Skills, Antigravity | 低 |
| 结构化配置 | 目前无 | — |

本项目的 `build.sh` 实现了从 `core.md` 到各 target 的自动转换，覆盖上述所有策略。
