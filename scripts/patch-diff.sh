#!/usr/bin/env bash
# Shows what a release changed in one downloaded tree. Fetches the older tag on demand.
# Usage: scripts/patch-diff.sh <group/name> <older-tag> [git diff args...]
#   scripts/patch-diff.sh net10/runtime v10.0.14 --stat
#   scripts/patch-diff.sh net10/aspnetcore v10.0.14 -- src/Servers
#   scripts/patch-diff.sh net11/runtime v11.0.0-rc.3.26522.148 --stat -- src/libraries
set -euo pipefail
[ $# -ge 2 ] || { sed -n '2,7p' "$0" >&2; exit 2; }
root="$(git rev-parse --show-toplevel)"; tree="$root/targets/$1"; old="$2"; shift 2
[ -d "$tree/.git" ] || { echo "not downloaded: targets/${tree#$root/targets/} (run scripts/fetch-targets.sh)" >&2; exit 1; }
git -C "$tree" rev-parse -q --verify "refs/tags/$old" >/dev/null \
  || git -C "$tree" fetch -q --depth 1 origin "refs/tags/$old:refs/tags/$old"
git -C "$tree" --no-pager diff "$old" HEAD "$@"
