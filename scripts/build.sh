#!/usr/bin/env bash
#
# build.sh — Generate target-specific files from core.md
#
# Usage: ./scripts/build.sh
#

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CORE="$REPO_ROOT/core.md"

if [[ ! -f "$CORE" ]]; then
  echo "Error: core.md not found at $CORE" >&2
  exit 1
fi

# Read core content (skip the title line)
CORE_BODY="$(tail -n +3 "$CORE")"

# ─── Claude Code: CLAUDE.md ────────────────────────────────────────
echo "Building targets/claude/CLAUDE.md ..."
cat > "$REPO_ROOT/targets/claude/CLAUDE.md" <<EOF
# Karpathy Skills

$CORE_BODY
EOF

# ─── Claude Code: SKILL.md ─────────────────────────────────────────
echo "Building targets/claude/skills/karpathy-skills/SKILL.md ..."
cat > "$REPO_ROOT/targets/claude/skills/karpathy-skills/SKILL.md" <<'FRONTMATTER'
---
name: karpathy-skills
description: Behavioral guidelines to reduce common LLM coding mistakes. Use when writing, reviewing, or refactoring code to avoid overcomplication, make surgical changes, surface assumptions, and define verifiable success criteria.
license: MIT
---

FRONTMATTER
cat >> "$REPO_ROOT/targets/claude/skills/karpathy-skills/SKILL.md" <<EOF
# Karpathy Skills

$CORE_BODY
EOF

# ─── Codex: AGENTS.md ──────────────────────────────────────────────
echo "Building targets/codex/AGENTS.md ..."
cat > "$REPO_ROOT/targets/codex/AGENTS.md" <<EOF
# Karpathy Skills

$CORE_BODY
EOF

# ─── Cursor: .cursor/rules/karpathy-skills.mdc ─────────────────────
echo "Building targets/cursor/.cursor/rules/karpathy-skills.mdc ..."
cat > "$REPO_ROOT/targets/cursor/.cursor/rules/karpathy-skills.mdc" <<'FRONTMATTER'
---
description: Behavioral guidelines to reduce common LLM coding mistakes. Use when writing, reviewing, or refactoring code to avoid overcomplication, make surgical changes, surface assumptions, and define verifiable success criteria.
alwaysApply: true
---

FRONTMATTER
cat >> "$REPO_ROOT/targets/cursor/.cursor/rules/karpathy-skills.mdc" <<EOF
# Karpathy Skills

$CORE_BODY
EOF

# ─── OpenCode: AGENTS.md ────────────────────────────────────────────
echo "Building targets/opencode/AGENTS.md ..."
cat > "$REPO_ROOT/targets/opencode/AGENTS.md" <<EOF
# Karpathy Skills

$CORE_BODY
EOF

# ─── Antigravity: .agent/skills/karpathy-skills/SKILL.md ────────────
echo "Building targets/antigravity/.agent/skills/karpathy-skills/SKILL.md ..."
cat > "$REPO_ROOT/targets/antigravity/.agent/skills/karpathy-skills/SKILL.md" <<'FRONTMATTER'
---
name: karpathy-skills
description: >
  Behavioral guidelines to reduce common LLM coding mistakes.
  Use when writing, reviewing, or refactoring code to avoid overcomplication,
  make surgical changes, surface assumptions, and define verifiable success criteria.
---

FRONTMATTER
cat >> "$REPO_ROOT/targets/antigravity/.agent/skills/karpathy-skills/SKILL.md" <<EOF
# Karpathy Skills

$CORE_BODY
EOF

echo "Done. All targets rebuilt from core.md."
