#!/usr/bin/env bash
# Installs a pre-commit hook that blocks committing confidential material.
set -euo pipefail
root="$(git rev-parse --show-toplevel)"
cat > "$root/.git/hooks/pre-commit" <<'HOOK'
#!/usr/bin/env bash
set -euo pipefail
staged=$(git diff --cached --name-only --diff-filter=ACMR | grep -E '^(findings|private|targets)/|(^|/)(GOAL|RESEARCH_LEDGER|AUTHORITY_GRAPH|CANDIDATES|EXPERIMENTS|EVIDENCE_INDEX|NOVELTY_MATRIX|NEXT_ACTIONS)\.md$|\.(dmp|mdmp|pcap|pcapng|PML|har|run)$' || true)
if [ -n "$staged" ]; then
  echo "BLOCKED: these staged paths must not go into the public repo:" >&2
  echo "$staged" >&2
  exit 1
fi
HOOK
chmod +x "$root/.git/hooks/pre-commit"
echo "pre-commit hook installed"
