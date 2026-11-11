#!/usr/bin/env bash
# Builds every lab for both in-scope runtimes and exercises them end to end on this machine.
# Runs the same way on Linux, macOS and Windows (Git Bash). Uses only the benign samples in
# labs/samples. Usage: scripts/labs-smoke.sh [net11.0 net10.0]
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"; cd "$root/labs"
export DOTNET_CLI_TELEMETRY_OPTOUT=1 DOTNET_NOLOGO=1
tfms=("$@"); [ ${#tfms[@]} -gt 0 ] || tfms=(net11.0 net10.0)
exe=""; case "$(uname -s)" in MINGW*|MSYS*|CYGWIN*) exe=".exe";; esac

dotnet --list-sdks
for p in kestrel-target raw-client parser-harness; do dotnet build "$p" -c Release -v quiet; done

fail=0; port=5080
for tfm in "${tfms[@]}"; do
  echo; echo "=== $tfm ==="
  bin() { echo "$1/bin/Release/$tfm/$2$exe"; }
  for s in json:sample.json xml:sample.xml asn1:sample.der zip:sample.zip tar:sample.tar uri:sample.uri; do
    out=$("$(bin parser-harness ParserHarness)" "${s%%:*}" "samples/${s##*:}")
    echo "$out" | grep -q '^outcome   : ok' && echo "ok    parser ${s%%:*}  ($(echo "$out" | sed -n 's/^runtime   : //p'))" \
      || { echo "FAIL  parser ${s%%:*}"; echo "$out"; fail=1; }
  done
  port=$((port + 10))
  LAB_PORT=$port "$(bin kestrel-target KestrelTarget)" > "kestrel-$tfm.log" 2>&1 &
  pid=$!
  resp=""
  for _ in $(seq 1 30); do
    resp=$("$(bin raw-client RawClient)" "$port" --file samples/get-echo.http 2>/dev/null || true)
    [ -n "$resp" ] && break; sleep 1
  done
  kill "$pid" 2>/dev/null || true; wait "$pid" 2>/dev/null || true
  if echo "$resp" | grep -q '"rawTarget":"/echo/hello?x=1"'; then echo "ok    kestrel-target + raw-client round trip"
  else echo "FAIL  kestrel round trip"; echo "$resp" | head -20; cat "kestrel-$tfm.log" | tail -20; fail=1; fi
  rm -f "kestrel-$tfm.log"
done
exit $fail
