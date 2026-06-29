# Karpathy Skills

> 减少 LLM 编程常见错误的行为准则 — 一份源文件，多工具适配。

灵感来自 [Andrej Karpathy 的观察](https://x.com/karpathy/status/2015883857489522876)，并根据后续十条规则版 `CLAUDE.md` 来源刷新。基于 [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) 扩展。

[English](./README.md) | 简体中文

## 问题

Andrej Karpathy 指出：

> "模型会替你做出错误假设，然后一路跑下去不检查。它们不管理自己的困惑，不寻求澄清，不暴露不一致，不呈现权衡，不在该推回的时候推回。"

> "它们特别喜欢把代码和 API 搞复杂，臃肿的抽象，不清理死代码……100 行能解决的事情用 1000 行来构建。"

## 十条规则

| 规则 | 解决的问题 |
|------|-----------|
| **先读再写** | 不读代码就改、风格漂移、虚构 API |
| **先想再写码** | 静默假设、隐藏困惑、缺失权衡 |
| **保持简单** | 过早抽象、投机配置、无用灵活性 |
| **精准修改** | 无关编辑、意外重构、噪声 diff |
| **验证** | 未测试的修复、跳过回归检查、断言过弱 |
| **目标驱动执行** | 模糊成功标准、未度量结果 |
| **调试** | 未读错误、未复现问题就猜修复 |
| **依赖管理** | 不必要依赖、重复库、维护负担 |
| **沟通** | 未说明担忧、含糊不确定性、摘要无帮助 |
| **常见失败模式** | 大杂烩改动、错误抽象、失控重构 |

完整内容见 [`core.md`](./core.md)。

## 支持的工具

| 工具 | 指令文件 | 使用方式 |
|------|---------|---------|
| **Claude Code** | `CLAUDE.md` + Skills | 复制 `targets/claude/` 到项目根目录 |
| **Codex** | `AGENTS.md` | 复制 `targets/codex/AGENTS.md` 到项目根目录 |
| **Cursor** | `.cursor/rules/*.mdc` | 复制 `targets/cursor/.cursor/` 到项目根目录 |
| **OpenCode** | `AGENTS.md` | 复制 `targets/opencode/AGENTS.md` 到项目根目录 |
| **Antigravity** | `.agent/skills/*/SKILL.md` | 复制 `targets/antigravity/.agent/` 到项目根目录 |
| **Hermes Agent** | `HERMES.md` | 复制 `targets/hermes-agent/HERMES.md` 到项目根目录 |

## 快速开始

### 方式一：直接复制

从上表选择你的工具，复制对应文件到你的项目中：

```bash
# Claude Code
cp targets/claude/CLAUDE.md /path/to/your/project/

# Codex
cp targets/codex/AGENTS.md /path/to/your/project/

# Cursor
cp -r targets/cursor/.cursor /path/to/your/project/

# OpenCode
cp targets/opencode/AGENTS.md /path/to/your/project/

# Antigravity
cp -r targets/antigravity/.agent /path/to/your/project/

# Hermes Agent
cp targets/hermes-agent/HERMES.md /path/to/your/project/
```

### 方式二：从源文件重建

编辑 `core.md` 自定义原则，然后重新生成：

```bash
./scripts/build.sh
```

## 项目结构

```
├── core.md                          # 规则源文件（唯一事实来源）
├── docs/
│   ├── karpathy-principles.md       # 背景与解读
│   └── target-formats.md            # target 格式调研
├── targets/
│   ├── claude/
│   │   ├── CLAUDE.md                # Claude Code 指令
│   │   └── skills/karpathy-skills/
│   │       └── SKILL.md             # Claude Code skill 格式
│   ├── codex/
│   │   └── AGENTS.md                # Codex 指令
│   ├── cursor/
│   │   └── .cursor/rules/
│   │       └── karpathy-skills.mdc  # Cursor 规则
│   ├── opencode/
│   │   └── AGENTS.md                # OpenCode 指令
│   ├── antigravity/
│   │   └── .agent/skills/
│   │       └── karpathy-skills/
│   │           └── SKILL.md         # Antigravity skill
│   └── hermes-agent/
│       └── HERMES.md                # Hermes Agent 指令
├── .claude-plugin/                  # Claude Code marketplace 配置
├── scripts/
│   └── build.sh                     # 从 core.md 重新生成 targets
├── LICENSE
└── README.md
```

## 工作原理

1. **`core.md`** 是所有规则的唯一事实来源。
2. **`scripts/build.sh`** 读取 `core.md`，生成带有各工具所需 frontmatter 和格式的文件。
3. **`targets/`** 包含各工具的生成输出。

编辑 `core.md` → 运行 `build.sh` → 所有 target 同步更新。

## 贡献

1. Fork 本仓库。
2. 修改 `core.md`（改规则）或在 `scripts/build.sh` 中添加新 target。
3. 运行 `./scripts/build.sh` 重新生成。
4. 提交 PR。

## 声明

这是一个社区构建的项目，灵感来自 Andrej Karpathy 的工程哲学。与 Andrej Karpathy 本人无关联，未获其背书。

## 许可证

[MIT](./LICENSE)
