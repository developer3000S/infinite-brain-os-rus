#!/usr/bin/env bash
# sync-adapters.sh
# Regenerate .claude/, .codex/, and .qwen/ adapter shims from canonical entities/ files.
# Use this if your OS does not support symlinks (Windows native, restricted CI).
# Run from repo root: bash sync-adapters.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

CLAUDE_MAP=(commands agents skills rules)
CODEX_MAP=(commands agents skills)
QWEN_MAP=(commands agents skills rules)

for type in "${CLAUDE_MAP[@]}"; do mkdir -p ".claude/${type}"; done
for type in "${CODEX_MAP[@]}"; do mkdir -p ".codex/${type}"; done
for type in "${QWEN_MAP[@]}"; do mkdir -p ".qwen/${type}"; done

SYNCED=0
for type in "${CLAUDE_MAP[@]}"; do
  if [[ -d "entities/${type}" ]]; then
    for canonical in entities/${type}/*.md; do
      [[ -e "$canonical" ]] || continue
      filename="$(basename "$canonical")"
      target=".claude/${type}/${filename}"
      if [[ -e "$target" ]] && [[ "$(readlink -f "$canonical")" == "$(readlink -f "$target")" ]]; then
        continue
      fi
      cp -f "$canonical" "$target"
      SYNCED=$((SYNCED + 1))
    done
  fi
done
for type in "${CODEX_MAP[@]}"; do
  if [[ -d "entities/${type}" ]]; then
    for canonical in entities/${type}/*.md; do
      [[ -e "$canonical" ]] || continue
      filename="$(basename "$canonical")"
      target=".codex/${type}/${filename}"
      if [[ -e "$target" ]] && [[ "$(readlink -f "$canonical")" == "$(readlink -f "$target")" ]]; then
        continue
      fi
      cp -f "$canonical" "$target"
      SYNCED=$((SYNCED + 1))
    done
  fi
done
for type in "${QWEN_MAP[@]}"; do
  if [[ -d "entities/${type}" ]]; then
    for canonical in entities/${type}/*.md; do
      [[ -e "$canonical" ]] || continue
      filename="$(basename "$canonical")"
      target=".qwen/${type}/${filename}"
      if [[ -e "$target" ]] && [[ "$(readlink -f "$canonical")" == "$(readlink -f "$target")" ]]; then
        continue
      fi
      cp -f "$canonical" "$target"
      SYNCED=$((SYNCED + 1))
    done
  fi
done

echo "Synced ${SYNCED} adapter file(s) from entities/ to .claude/, .codex/, and .qwen/."
echo "Note: copies, not symlinks. Re-run after editing any entity in entities/."
echo "Note: .claude/ is deprecated in favor of .qwen/."
