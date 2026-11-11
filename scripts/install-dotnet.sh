#!/usr/bin/env bash
# Installs the exact in-scope .NET SDKs side by side into ~/.dotnet using Microsoft's official
# dotnet-install script. Versions come from scope/sdk-versions.txt.
set -euo pipefail
root="$(git rev-parse --show-toplevel)"
dir="${DOTNET_INSTALL_DIR:-$HOME/.dotnet}"
tmp="$(mktemp)"; trap 'rm -f "$tmp"' EXIT
curl -fsSL https://dot.net/v1/dotnet-install.sh -o "$tmp"
grep -vE '^\s*(#|$)' "$root/scope/sdk-versions.txt" | while read -r v _; do
  bash "$tmp" --version "$v" --install-dir "$dir" --no-path
done
echo
echo "Installed into $dir. Add to your shell profile:"
echo "  export DOTNET_ROOT=$dir PATH=$dir:\$PATH DOTNET_CLI_TELEMETRY_OPTOUT=1"
"$dir/dotnet" --list-sdks
