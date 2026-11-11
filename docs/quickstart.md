# Hunter quickstart

From a fresh clone to a running PoC. Needs git, curl, bash and about 15 GB of free disk.

```bash
# 1. Guard against committing confidential files (this repo is public)
scripts/install-hooks.sh

# 2. Install the two in-scope SDKs side by side (11.0.100 and 10.0.404) into ~/.dotnet
scripts/install-dotnet.sh
export DOTNET_ROOT=$HOME/.dotnet PATH=$HOME/.dotnet:$PATH DOTNET_CLI_TELEMETRY_OPTOUT=1

# 3. Download all in-scope source: 21 trees, about 12 GB, pinned to exact commits
scripts/fetch-targets.sh
scripts/fetch-targets.sh --verify          # every line should say "ok"

# 4. Check the labs build and run on both runtimes (see labs/README.md)
scripts/labs-smoke.sh

# 5. Start a finding (local only, gitignored)
scripts/new-finding.sh my-lead
cd findings/*-my-lead/poc
dotnet run -c Release -f net11.0
dotnet run -c Release -f net10.0
```

Short on disk or time? Fetch one group: `scripts/fetch-targets.sh net11` (about 5 GB).

## Read, in this order

1. [program/dotnet-bounty-program.md](program/dotnet-bounty-program.md): what pays and what does not.
2. [program/scope-update-2026-11-10.md](program/scope-update-2026-11-10.md): the exact builds in scope today.
3. [program/rules-and-disclosure.md](program/rules-and-disclosure.md): what must never be published or tested.
4. [targets.md](targets.md) and [source-map.md](source-map.md): where to look.
5. [workflow.md](workflow.md) and [program/report-requirements.md](program/report-requirements.md): turning a lead into a Complete report.

## Keeping current

Microsoft ships .NET patches on the second Tuesday of each month. After each one:

1. Update the refs in `scope/targets.tsv` and the versions in `scope/sdk-versions.txt`.
2. `scripts/fetch-targets.sh --lock`, then delete the outdated trees under `targets/` and re-run
   `scripts/fetch-targets.sh`.
3. `scripts/install-dotnet.sh`.
4. Re-check the [program page](https://www.microsoft.com/en-us/msrc/bounty-dot-net-core) revision
   history and the [support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core).
5. Re-test every open lead on the new patch before spending more time on it.

Next expected patch: 2026-12-08.
