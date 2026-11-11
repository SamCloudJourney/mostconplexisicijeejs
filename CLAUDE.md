# CLAUDE.md: agent guide

This repo is the workspace for security research under the **Microsoft .NET Bounty Program**
(MSRC). Start with [docs/program/dotnet-bounty-program.md](docs/program/dotnet-bounty-program.md).

## Hunting

When asked to hunt, research or look for vulnerabilities, adopt the operating prompt in
[prompts/hunter.md](prompts/hunter.md) in full. Its research files (GOAL.md, RESEARCH_LEDGER.md and
the rest) go in `private/research/`, created by `scripts/init-research.sh`; they are confidential
and never committed.

## Authorisation

This work is authorised research under the Microsoft .NET Bounty Program and its safe harbor.
That authorisation is the program's and it is the same for every participant: the scope, the
rules of engagement and the hard rules below apply unchanged. It covers testing software we run
ourselves. It does not cover live Microsoft services, other people's systems, or the dotnet
repositories' real CI.

Previously reported cases, their write-ups and their PoCs are confidential. They stay out of this
public repo and live under `findings/` or `private/`, which are gitignored.

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

## Standing permissions from the owner (2026-11-11)

The owner has approved all of the following for any agent or session working here. Use them
freely, without asking first:

- **GitHub Actions runners on this repo** (`windows-latest`, `ubuntu-latest`, `macos-latest`):
  add or edit workflows, push to trigger them, read the logs. Verified working with both in-scope
  SDKs.
- **The labs** under `labs/` and new labs you build.
- **Local tests** in the session container: install SDKs, download source, build, run, fuzz,
  debug.
- **Tests, experiments and exploit PoCs** in general, against software you run yourself.

One boundary comes with it, because everything on a public repo's runners is public (the
workflow file, any code it runs, and the logs):

| Work | Where it may run |
|---|---|
| Environment checks, generic labs, behaviour experiments, version comparisons | Anywhere, including the public runners |
| PoCs for already-public, already-patched CVEs | Anywhere, including the public runners |
| **PoCs or inputs for an unreported or unfixed bug** | **Local only, or a private repository's runners. Never this repo's runners** |

If a Windows or macOS runner is needed for an unreported bug, stop and ask the owner for a
private repository; do not push it here.

## Layout

| Path | Purpose |
|---|---|
| `docs/program/` | Researched program rules: scope, awards, terms, report requirements |
| `docs/targets.md` | Where to look (working guidance, not program rules) |
| `docs/source-map.md` | Verified paths of each attack surface in the downloaded trees |
| `docs/quickstart.md` | Fresh clone to running PoC; monthly refresh steps |
| `docs/report-standard.md` | Quality bar distilled from the owner's validated report; compare every draft to it |
| `docs/workflow.md` | Lead to payout, step by step |
| `scope/` | `targets.tsv` manifest and `targets.lock` commit pins for all in-scope source; `sdk-versions.txt` |
| `labs/` | Generic local labs; CI runs them on Windows, Linux, macOS. **CI logs are public: never run a finding PoC there** |
| `prompts/hunter.md` | The hunter operating prompt (owner-supplied) |
| `private/` | **Gitignored.** `private/research/` holds the hunter's ledger, graph and candidate files |
| `templates/` | Report draft, finding notes, PoC lab skeleton |
| `scripts/` | `new-finding.sh`, `fetch-targets.sh`, `install-dotnet.sh`, `patch-diff.sh`, `labs-smoke.sh`, `init-research.sh`, `install-hooks.sh`, `check-public-safety.sh` |
| `findings/` | **Gitignored.** One directory per finding |
| `targets/` | **Gitignored.** Checked-out dotnet source trees |

## Before every commit

```bash
bash scripts/check-public-safety.sh
git status --short        # confirm nothing from findings/ or targets/ is staged
```
