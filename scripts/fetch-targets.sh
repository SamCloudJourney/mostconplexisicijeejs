#!/usr/bin/env bash
# Downloads every source tree in scope/targets.tsv into targets/<group>/<name> (gitignored).
#
#   scripts/fetch-targets.sh                 fetch everything
#   scripts/fetch-targets.sh net11 docs      fetch only these groups
#   scripts/fetch-targets.sh --lock          re-resolve refs and rewrite scope/targets.lock (no download)
#   scripts/fetch-targets.sh --verify        check every downloaded tree against scope/targets.lock
#
# Tag refs are pinned by commit in scope/targets.lock, so every hunter gets identical bytes.
# Branch refs (main, release/2.3) move; the lock records what they pointed at when last locked.
set -uo pipefail
root="$(git rev-parse --show-toplevel)"
manifest="$root/scope/targets.tsv"
lock="$root/scope/targets.lock"
mode_arg=""; groups=()
for a in "$@"; do case "$a" in --lock|--verify) mode_arg="$a";; *) groups+=("$a");; esac; done

rows() { grep -vE '^\s*(#|$)' "$manifest"; }
want() { [ ${#groups[@]} -eq 0 ] && return 0; local g; for g in "${groups[@]}"; do [ "$g" = "$1" ] && return 0; done; return 1; }
resolve() { # repo ref -> commit sha (peels annotated tags)
  local out; out=$(git ls-remote "https://github.com/$1" "refs/tags/$2^{}" "refs/tags/$2" "refs/heads/$2" 2>/dev/null) || return 1
  { echo "$out" | grep '\^{}$' || echo "$out"; } | head -1 | cut -f1
}
locked() { [ -f "$lock" ] && awk -F'\t' -v k="$1/$2" '$1==k{print $4}' "$lock"; }

if [ "$mode_arg" = "--lock" ]; then
  tmp=$(mktemp); printf '# target\trepo\tref\tcommit\n' > "$tmp"; rc=0
  while IFS=$'\t' read -r group name repo ref _; do
    sha=$(resolve "$repo" "$ref"); [ -n "$sha" ] || { echo "UNRESOLVED $repo $ref" >&2; rc=1; continue; }
    printf '%s/%s\t%s\t%s\t%s\n' "$group" "$name" "$repo" "$ref" "$sha" >> "$tmp"
  done < <(rows)
  [ $rc -eq 0 ] && mv "$tmp" "$lock" && echo "wrote $lock"
  exit $rc
fi

fail=0; index="$root/targets/INDEX.md"; mkdir -p "$root/targets"
[ "$mode_arg" = "--verify" ] || printf '# Downloaded targets\n\n| Path | Repo | Ref | Commit | Scope |\n|---|---|---|---|---|\n' > "$index.tmp"
while IFS=$'\t' read -r group name repo ref mode scope note; do
  want "$group" || continue
  dest="$root/targets/$group/$name"; want_sha=$(locked "$group" "$name")
  if [ "$mode_arg" != "--verify" ] && [ ! -d "$dest/.git" ]; then
    echo ">> $group/$name  ($repo @ $ref, $mode)"
    rm -rf "$dest"; mkdir -p "$(dirname "$dest")"; ok=1
    for attempt in 1 2 3; do
      if [ "$mode" = full ]; then
        git clone -q --depth 1 --branch "$ref" -c advice.detachedHead=false "https://github.com/$repo" "$dest" && ok=0
      else
        git clone -q --depth 1 --branch "$ref" --filter=blob:none --sparse "https://github.com/$repo" "$dest" \
          && git -C "$dest" sparse-checkout set $(echo "${mode#sparse:}" | tr ',' ' ') && ok=0
      fi
      [ $ok -eq 0 ] && break; rm -rf "$dest"; sleep $((attempt * 5))
    done
    [ $ok -eq 0 ] || { echo "FAILED  $group/$name" >&2; fail=1; continue; }
  fi
  if [ ! -d "$dest/.git" ]; then echo "MISSING $group/$name"; fail=1; continue; fi
  got=$(git -C "$dest" rev-parse HEAD)
  if [ -z "$want_sha" ]; then status="unlocked"
  elif [ "$got" = "$want_sha" ]; then status="ok"
  elif [[ "$ref" == v* || "$ref" =~ ^[0-9] ]]; then status="MISMATCH"; fail=1
  else status="moved"   # branch ref advanced since the lock was written
  fi
  printf '%-9s %-28s %s\n' "$status" "$group/$name" "$got"
  [ "$mode_arg" = "--verify" ] || printf '| `targets/%s/%s` | %s | `%s` | `%s` | %s |\n' "$group" "$name" "$repo" "$ref" "${got:0:12}" "$scope" >> "$index.tmp"
done < <(rows)
[ "$mode_arg" = "--verify" ] || mv "$index.tmp" "$index"
exit $fail
