# Karpathy Skills

> Behavioral guidelines to reduce common LLM coding mistakes — one source, multiple AI tools.

Inspired by [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls. Originally based on [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills).

English | [简体中文](./README.zh-CN.md)

## The Problem

From Andrej Karpathy:

> "The models make wrong assumptions on your behalf and just run along with them without checking. They don't manage their confusion, don't seek clarifications, don't surface inconsistencies, don't present tradeoffs, don't push back when they should."

> "They really like to overcomplicate code and APIs, bloat abstractions, don't clean up dead code... implement a bloated construction over 1000 lines when 100 would do."

## The Four Principles

| Principle | Addresses |
|-----------|-----------|
| **Think Before Coding** | Wrong assumptions, hidden confusion, missing tradeoffs |
| **Simplicity First** | Overcomplication, bloated abstractions |
| **Surgical Changes** | Orthogonal edits, touching code you shouldn't |
| **Goal-Driven Execution** | Weak success criteria, unverified outcomes |

See [`core.md`](./core.md) for the full canonical source.

## Supported Tools

| Tool | Instruction File | How to Use |
|------|-----------------|------------|
| **Claude Code** | `CLAUDE.md` + Skills | Copy `targets/claude/` to your project root |
| **Codex** | `AGENTS.md` | Copy `targets/codex/AGENTS.md` to your project root |
| **Cursor** | `.cursor/rules/*.mdc` | Copy `targets/cursor/.cursor/` to your project root |
| **OpenCode** | `AGENTS.md` | Copy `targets/opencode/AGENTS.md` to your project root |
| **Antigravity** | `.agent/skills/*/SKILL.md` | Copy `targets/antigravity/.agent/` to your project root |

OpenClaw target is deferred — its instruction format could not be verified at time of writing.

## Quick Start

### Option 1: Copy the file you need

Pick your tool from the table above and copy the corresponding file into your project.

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
```

### Option 2: Rebuild from source

Edit `core.md` to customize, then regenerate all targets:

```bash
./scripts/build.sh
```

## Project Structure

```
├── core.md                          # Canonical principles (single source of truth)
├── targets/
│   ├── claude/
│   │   ├── CLAUDE.md                # Claude Code instructions
│   │   └── skills/karpathy-skills/
│   │       └── SKILL.md             # Claude Code skill format
│   ├── codex/
│   │   └── AGENTS.md                # Codex instructions
│   ├── cursor/
│   │   └── .cursor/rules/
│   │       └── karpathy-skills.mdc  # Cursor rules
│   ├── opencode/
│   │   └── AGENTS.md                # OpenCode instructions
│   └── antigravity/
│       └── .agent/skills/
│           └── karpathy-skills/
│               └── SKILL.md         # Antigravity skill
├── .claude-plugin/                  # Claude Code marketplace config
├── scripts/
│   └── build.sh                     # Regenerate targets from core.md
├── LICENSE
└── README.md
```

## How It Works

1. **`core.md`** is the single source of truth for all principles.
2. **`scripts/build.sh`** reads `core.md` and generates tool-specific files with the appropriate frontmatter and formatting.
3. **`targets/`** contains the generated output for each supported tool.

Edit `core.md` → run `build.sh` → all targets update.

## Contributing

1. Fork this repo.
2. Edit `core.md` if changing principles, or add a new target in `scripts/build.sh`.
3. Run `./scripts/build.sh` to regenerate.
4. Submit a PR.

## Disclaimer

This is a community-built project inspired by Andrej Karpathy's engineering philosophy. It is not affiliated with or endorsed by Andrej Karpathy.

## License

[MIT](./LICENSE)
