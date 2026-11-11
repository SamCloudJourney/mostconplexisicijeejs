#!/usr/bin/env bash
# Fails if anything confidential is tracked by git. Run locally (pre-commit) and in CI.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
bad=$(git ls-files | grep -E '^(findings|private|targets)/|(^|/)(GOAL|RESEARCH_LEDGER|AUTHORITY_GRAPH|CANDIDATES|EXPERIMENTS|EVIDENCE_INDEX|NOVELTY_MATRIX|NEXT_ACTIONS)\.md$|\.(dmp|mdmp|pcap|pcapng|PML|har|run)$' || true)
if [ -n "$bad" ]; then
  echo "ERROR: confidential or bulky paths are tracked in a PUBLIC repo:" >&2
  echo "$bad" >&2
  exit 1
fi
echo "public-safety check passed"
