#!/usr/bin/env bash
# Shallow-clones the main in-scope source trees into targets/ (gitignored).
# Usage: scripts/fetch-targets.sh [repo ...]   default: runtime aspnetcore
# Pass a release tag with REF=v10.0.0 to pin to a shipped (in-scope) build instead of main.
set -euo pipefail
root="$(git rev-parse --show-toplevel)"
mkdir -p "$root/targets"
repos=("$@"); [ ${#repos[@]} -gt 0 ] || repos=(runtime aspnetcore)
for r in "${repos[@]}"; do
  dest="$root/targets/$r"
  if [ -d "$dest/.git" ]; then echo "exists: $dest"; continue; fi
  if [ -n "${REF:-}" ]; then
    git clone --depth 1 --branch "$REF" "https://github.com/dotnet/$r" "$dest"
  else
    git clone --depth 1 "https://github.com/dotnet/$r" "$dest"
  fi
done
