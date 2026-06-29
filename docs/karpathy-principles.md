# Andrej Karpathy 的 LLM 编程准则：起源与十条规则版解读

## 背景

Andrej Karpathy 在 [X/Twitter](https://x.com/karpathy/status/2015883857489522876) 上总结过 LLM 编程助手的几个高频缺陷：替用户做错误假设、隐藏困惑、不主动澄清、不呈现权衡、过度复杂化、改动无关代码，以及删除自己没有充分理解的内容。

这些观察之所以被广泛引用，是因为它们描述的不是偶发错误，而是 LLM 编程时会反复出现的行为模式。本项目把这些行为约束整理成可复制到不同 AI 编程工具中的指令文件。

## 当前版本

本项目当前采用十条规则版 `CLAUDE.md` 内容作为规范正文，并以 `core.md` 作为唯一事实来源生成各工具 target。来源参考见文末链接；仓库正文以 `core.md` 为准。

## 原始问题

### 问题一：盲目假设

> "The models make wrong assumptions on your behalf and just run along with them without checking. They don't manage their confusion, don't seek clarifications, don't surface inconsistencies, don't present tradeoffs, don't push back when they should."

**翻译**：模型会替你做出错误假设，然后一路跑下去不检查。它们不管理自己的困惑，不寻求澄清，不暴露不一致，不呈现权衡，不在该推回的时候推回。

**现实影响**：

- 需求有歧义时，模型默默选择一种理解就开始写。
- 模型不确定时也常常伪装成确定。
- 隐形架构选择直到 review 或生产问题时才暴露。

### 问题二：过度工程化

> "They really like to overcomplicate code and APIs, bloat abstractions, don't clean up dead code... implement a bloated construction over 1000 lines when 100 would do."

**翻译**：它们特别喜欢把代码和 API 搞复杂，臃肿抽象，不清理死代码……100 行能解决的事情用 1000 行来构建。

**现实影响**：

- 一个简单函数被做成类层次、策略模式或插件系统。
- 一个局部改动顺手引入配置、重试、缓存、日志等无关能力。
- "以后可能用到" 的扩展点增加了阅读和维护成本。

### 问题三：附带修改

> "They still sometimes change/remove comments and code they don't sufficiently understand as side effects, even if orthogonal to the task."

**翻译**：它们仍然会作为副作用修改或删除自己不够理解的注释和代码，即使这些内容与当前任务无关。

**现实影响**：

- 修一个 bug 时顺手改了旁边几个函数。
- 删除了记录历史背景的注释。
- 重新格式化文件，让真正的行为改动淹没在噪声 diff 里。

## 十条规则

| 规则 | 约束的失败模式 |
|------|---------------|
| **Read Before You Write** | 不读现有代码就生成不合项目风格的实现 |
| **Think Before You Code** | 静默假设、隐藏困惑、不呈现方案权衡 |
| **Simplicity** | 过早抽象、投机配置、无用灵活性 |
| **Surgical Changes** | 无关改动、意外重构、格式化噪声 |
| **Verification** | 没有复现测试、跳过回归验证、测试无意义 |
| **Goal-Driven Execution** | 目标模糊、成功标准不可验证 |
| **Debugging** | 没读完整错误、没复现就猜修复 |
| **Dependencies** | 随手加依赖、重复已有库、引入维护负担 |
| **Communication** | 没说明做了什么、为什么做、哪里不确定 |
| **Common Failure Modes** | 大杂烩改动、错误抽象、乐观路径、知识幻觉、失控重构 |

## 为什么从早期压缩版扩展到十条规则

早期版本把 Karpathy 的观察压缩成少数原则，便于记忆和传播。十条规则版更适合作为 agent 指令文件，因为它把行为要求拆到可执行层面：

- 先读代码，不只是在动手前 "思考"。
- 验证和目标定义分开，分别约束测试行为和任务边界。
- 调试、依赖、沟通被单独列出，避免它们被归入笼统的工程判断。
- 常见失败模式作为最后的自检清单，让 agent 在输出前回看自己的倾向。

## 使用方式

完整规范正文在 [`core.md`](../core.md)。各工具文件由 `scripts/build.sh` 从 `core.md` 生成：

- Claude Code：`targets/claude/CLAUDE.md` 和 `targets/claude/skills/karpathy-skills/SKILL.md`
- Codex：`targets/codex/AGENTS.md`
- Cursor：`targets/cursor/.cursor/rules/karpathy-skills.mdc`
- OpenCode：`targets/opencode/AGENTS.md`
- Antigravity：`targets/antigravity/.agent/skills/karpathy-skills/SKILL.md`
- Hermes Agent：`targets/hermes-agent/HERMES.md`

更新规则正文时，应先更新 `core.md`，再运行 `scripts/build.sh`，最后确认所有 target 都同步到同一套十条规则。

## 局限性

这些规则偏向谨慎，不是所有场景都需要同等强度。生产代码、数据迁移、安全敏感改动应严格执行；一次性脚本、探索性原型可以适度放松。

规则也不能替代领域知识。它们约束的是 LLM 的工程行为：先读、少猜、少改、可验证、会沟通。技术方案本身仍然需要具体项目上下文来判断。

## 参考链接

- [Karpathy 原始推文](https://x.com/karpathy/status/2015883857489522876)
- [Raytar 十条规则版来源](https://x.com/Raytar/status/2070577723089768500)
- [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills)
- [本项目 core.md](../core.md)
