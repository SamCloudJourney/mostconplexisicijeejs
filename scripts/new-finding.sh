#!/usr/bin/env bash
# Scaffolds a new finding workspace under findings/ (gitignored, local only).
# Usage: scripts/new-finding.sh <short-slug>      e.g. scripts/new-finding.sh kestrel-h2-reset
set -euo pipefail
[ $# -eq 1 ] || { echo "usage: $0 <short-slug>" >&2; exit 2; }
slug="$1"
case "$slug" in *[!a-z0-9-]*|"") echo "slug must be lowercase letters, digits, hyphens" >&2; exit 2;; esac
root="$(git rev-parse --show-toplevel)"
dir="$root/findings/$(date -u +%Y%m%d)-$slug"
[ -e "$dir" ] && { echo "already exists: $dir" >&2; exit 1; }
mkdir -p "$dir/evidence"
cp "$root/templates/finding-notes.md" "$dir/notes.md"
cp "$root/templates/msrc-report.md" "$dir/report.md"
cp -r "$root/templates/lab" "$dir/poc"
echo "created $dir (local only, gitignored)"
