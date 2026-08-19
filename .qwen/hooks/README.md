# Hooks

This folder holds the Qwen Code runtime hook wrappers for this repo. The hooks are
registered in `.qwen/settings.json` (when Qwen Code supports hooks) and run automatically
at defined session events.

## Design: thin wrappers, shared logic

The wrappers in this folder stay thin. The check logic lives in `_system/checks/` so the
same scripts serve multiple callers: these hooks, `_system/validate.sh` (parity across
runtimes), and direct invocation by an agent or operator. This is the harness-portability
split: runtime-specific glue here, portable checks in `_system/checks/`.

## Warn-only posture

Every hook in this layer is warn-only. Nothing blocks a write, a session, or a stop:

- All hooks always exit 0; their output is informational.
- For PostToolUse hooks, any violations feed the findings back to the model as feedback
  without undoing the write. That feedback loop is the warn mechanism, not a block.

Promotion of any check to blocking is a later operator decision recorded in
`_system/enforcement-tiers.md`, which also declares the enforcement tier of every
numbered `_system` rule.

## The hooks

### session-start.sh (if supported by Qwen Code)

Runs `_system/checks/session-ledger-status.sh` (active-session count, stale sessions
older than 3 days) and prints a one-paragraph reminder of the forced session discipline.

### post-write-lint.sh (if supported by Qwen Code)

Extracts file path from hook event JSON and if the path is a repo markdown file runs
`_system/checks/node-lint.sh` on it: frontmatter presence, the eight required node keys,
the em and en dash ban, and placeholder text, with the same path exemptions as
`validate.sh`.

### stop-check.sh (if supported by Qwen Code)

Runs `_system/checks/uncommitted-work-check.sh` (working-tree summary) and
`_system/checks/adapter-sync-check.sh` (entities/ versus `.qwen/` and `.codex/` drift,
plus the QWEN.md and AGENTS.md co-edit warning) and prints their output as end-of-session
reminders.

## Registration

If Qwen Code supports hooks, `.qwen/settings.json` will register the wrappers.

## Adding a hook

1. Put the check logic in `_system/checks/` as a self-contained script and document it in
   that folder's README.
2. Add a thin wrapper here that delegates to it. Make both executable (`chmod +x`).
3. Register the wrapper in `.qwen/settings.json` under the correct event.
4. Declare the check in `_system/enforcement-tiers.md` (tier, rule coverage, warn-only
   posture).
5. Test by simulating the event.

## Relationship to rules

Hooks enforce the mechanical floor of the rules in `entities/rules/` (served to Qwen
Code via `.qwen/rules/`) and the numbered contracts in `_system/`. The rule file
documents intent and rationale; the check script is the mechanism;
`_system/enforcement-tiers.md` is the registry that says which rules are mechanically
covered and which remain prose judgment.