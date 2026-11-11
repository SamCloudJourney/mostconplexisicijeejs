#!/usr/bin/env bash
# Creates the hunter's research files (prompts/hunter.md, sections 12 and 13) under
# private/research/, which is gitignored. Existing files are left untouched.
set -euo pipefail
root="$(git rev-parse --show-toplevel)"; dir="$root/private/research"; mkdir -p "$dir"
for f in GOAL RESEARCH_LEDGER AUTHORITY_GRAPH CANDIDATES EXPERIMENTS EVIDENCE_INDEX NOVELTY_MATRIX NEXT_ACTIONS; do
  [ -e "$dir/$f.md" ] || printf '# %s\n\n<!-- CONFIDENTIAL. Local only; never commit. -->\n' "${f//_/ }" > "$dir/$f.md"
done
echo "research files ready in $dir (local only, gitignored)"; ls "$dir"
