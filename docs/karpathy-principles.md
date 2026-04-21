# Andrej Karpathy 的 LLM 编程准则：起源与解读

## 背景

2025 年，Andrej Karpathy（前 Tesla AI 总监、OpenAI 联合创始人）在 [X/Twitter](https://x.com/karpathy/status/2015883857489522876) 上发表了一系列对 LLM 编程行为的观察。这些观察迅速引起开发者社区的广泛共鸣，因为它们精准描述了几乎所有人在使用 AI 编程助手时遇到的痛点。

## 原始问题

Karpathy 指出了 LLM 作为编程助手时的几个核心缺陷：

### 问题一：盲目假设

> "The models make wrong assumptions on your behalf and just run along with them without checking. They don't manage their confusion, don't seek clarifications, don't surface inconsistencies, don't present tradeoffs, don't push back when they should."

**翻译**：模型会替你做出错误假设，然后一路跑下去不检查。它们不管理自己的困惑，不寻求澄清，不暴露不一致，不呈现权衡，不在该推回的时候推回。

**现实影响**：
- 你说"加个按钮"，模型假设了按钮的位置、样式、交互逻辑，全部自作主张
- 需求有歧义时，模型默默选一个理解就开始写，写完你才发现跑偏了
- 即使模型不确定，它也不会说"我不确定"，而是伪装成很确定的样子

### 问题二：过度工程化

> "They really like to overcomplicate code and APIs, bloat abstractions, don't clean up dead code... implement a bloated construction over 1000 lines when 100 would do."

**翻译**：它们特别喜欢把代码和 API 搞复杂，臃肿的抽象，不清理死代码……100 行能解决的事情用 1000 行来构建。

**现实影响**：
- 你要一个简单的工具函数，模型给你一个完整的类层次结构
- 要一个 API 端点，模型加上了你没要的中间件、错误处理、日志、缓存
- 代码里充满了"以后可能用到"的扩展点，但实际上永远不会用到

### 问题三：附带修改

> "They still sometimes change/remove comments and code they don't sufficiently understand as side effects, even if orthogonal to the task."

**翻译**：它们仍然会作为副作用修改或删除自己不够理解的注释和代码，即使这些内容与当前任务无关。

**现实影响**：
- 你让模型修一个 bug，它顺手"优化"了旁边三个函数
- 删掉了它觉得没用的注释，但那些注释记录了重要的历史决策
- 改了代码风格让它"更一致"，结果 diff 里一半都是无关改动

## 四大原则

社区（包括 [forrestchang](https://github.com/forrestchang/andrej-karpathy-skills)）将 Karpathy 的观察提炼为四条可操作的原则：

### 1. Think Before Coding（先思考再写码）

**核心思想**：不假设、不隐藏困惑、暴露权衡。

这条原则直接对应"盲目假设"问题。要求 LLM 在动手之前：
- 明确说出自己的假设
- 存在多种理解时，列出来让用户选
- 有更简单的方案时，主动提出
- 不确定时停下来问，而不是猜

**为什么有效**：强制 LLM 从"执行模式"切换到"协商模式"。一个好的人类工程师接到任务后也会先问问题，而不是直接开写。

### 2. Simplicity First（简洁优先）

**核心思想**：解决问题的最少代码，不做投机性开发。

这条原则直接对应"过度工程化"问题。标准很简单：
- 没被要求的功能不加
- 单次使用的代码不需要抽象
- 没被要求的"灵活性"和"可配置性"不做
- 不可能发生的场景不需要错误处理

**检验方法**：一个资深工程师看了会不会说"这也太复杂了"？如果会，就简化。

### 3. Surgical Changes（精准修改）

**核心思想**：只改必须改的，只清理自己制造的垃圾。

这条原则直接对应"附带修改"问题。规则很明确：
- 不"顺便改进"旁边的代码
- 不重构没坏的东西
- 匹配现有风格，即使你觉得不好
- 发现不相关的死代码，提一句就好，别删

**检验方法**：diff 里的每一行改动都应该能追溯到用户的请求。

### 4. Goal-Driven Execution（目标驱动执行）

**核心思想**：定义可验证的成功标准，循环直到验证通过。

这条原则解决的是"做了但没做对"的问题。要求把模糊任务转化为可验证的目标：
- "加验证" → "写无效输入的测试，然后让测试通过"
- "修 bug" → "写复现测试，然后让测试通过"
- "重构 X" → "确保重构前后测试都通过"

**为什么有效**：明确的成功标准让 LLM 可以自主循环迭代，而不是做完一次就停下等你检查。

## 这些原则的局限性

**偏向谨慎**：这四条原则明显偏向"少犯错"而不是"快速产出"。对于探索性开发、原型验证、hackathon 等场景，严格遵守这些原则可能会拖慢速度。

**需要判断力**：不是所有任务都需要同等程度的谨慎。修改生产数据库的迁移脚本需要极度谨慎；写一个用完即弃的数据转换脚本可以放松一些。

**不能替代领域知识**：这些原则规范的是行为模式，不是技术能力。LLM 遵守了所有原则但技术方案选错了，结果一样不好。

## 参考链接

- [Karpathy 原始推文](https://x.com/karpathy/status/2015883857489522876)
- [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) — 最早的 Claude Code 实现
- [本项目 core.md](../core.md) — 本项目对这些原则的规范化表述
