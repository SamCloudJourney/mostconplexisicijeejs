# CLAUDE.md: agent guide

This repo is the workspace for security research under the **Microsoft .NET Bounty Program**
(MSRC). Start with [docs/program/dotnet-bounty-program.md](docs/program/dotnet-bounty-program.md).

## Hard rules

1. **This repo is PUBLIC. Never commit, push, or mention in a commit message, branch name, PR or
   issue anything about an unreported or unfixed vulnerability.** No PoCs, dumps, captures,
   hypotheses about a specific live weakness, or MSRC case details. That material lives only under
   `findings/` (gitignored). Disclosure breaches the bounty terms and forfeits the award.
2. **Test only against software running on the local machine.** Never against a live Microsoft
   service, the real dotnet GitHub repositories' CI, or any third-party host.
3. **Stay in scope.** Supported .NET and ASP.NET Core versions only (.NET 11.0.0 and 10.0.15 as of 2026-11-10; 8 and 9 are out),
   latest patch, RTM or RC builds. Not .NET Framework, not daily builds.
4. **Never report through public GitHub issues.** Reports go to the MSRC Researcher Portal, and
   the owner submits them personally.
5. Do not present program facts from memory. The program page changes; re-check it.

## Layout

| Path | Purpose |
|---|---|
| `docs/program/` | Researched program rules: scope, awards, terms, report requirements |
| `docs/targets.md` | Where to look (working guidance, not program rules) |
| `docs/source-map.md` | Verified paths of each attack surface in the downloaded trees |
| `docs/quickstart.md` | Fresh clone to running PoC; monthly refresh steps |
| `docs/workflow.md` | Lead to payout, step by step |
| `scope/` | `targets.tsv` manifest and `targets.lock` commit pins for all in-scope source; `sdk-versions.txt` |
| `labs/` | Generic local labs; CI runs them on Windows, Linux, macOS. **CI logs are public: never run a finding PoC there** |
| `templates/` | Report draft, finding notes, PoC lab skeleton |
| `scripts/` | `new-finding.sh`, `fetch-targets.sh`, `install-dotnet.sh`, `patch-diff.sh`, `labs-smoke.sh`, `install-hooks.sh`, `check-public-safety.sh` |
| `findings/` | **Gitignored.** One directory per finding |
| `targets/` | **Gitignored.** Checked-out dotnet source trees |

## Before every commit

```bash
bash scripts/check-public-safety.sh
git status --short        # confirm nothing from findings/ or targets/ is staged
```
