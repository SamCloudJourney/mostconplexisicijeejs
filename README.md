# .NET bug bounty workspace

Workspace for security research under the
[Microsoft .NET Bounty Program](https://www.microsoft.com/en-us/msrc/bounty-dot-net-core) (MSRC).

> **This repository is public.** It holds program research, checklists, templates and tooling
> only. Details of unreported or unfixed vulnerabilities are never stored here: the bounty terms
> require confidentiality, and disclosure forfeits the award. Findings live in the gitignored
> `findings/` directory on the researcher's own machine.

## Start here

| Read | For |
|---|---|
| [docs/program/dotnet-bounty-program.md](docs/program/dotnet-bounty-program.md) | Scope, award table, exclusions, eligibility |
| [docs/program/scope-update-2026-11-10.md](docs/program/scope-update-2026-11-10.md) | What changed when .NET 11 shipped; exact builds to test |
| [docs/program/rules-and-disclosure.md](docs/program/rules-and-disclosure.md) | Confidentiality, rules of engagement, safe harbor |
| [docs/program/report-requirements.md](docs/program/report-requirements.md) | What makes a report "Complete" (worth about 10x) |
| [docs/targets.md](docs/targets.md) | Where to look and how |
| [docs/source-map.md](docs/source-map.md) | Exact paths of each attack surface in the downloaded source |
| [prompts/hunter.md](prompts/hunter.md) | The hunter operating prompt for agents |
| [docs/report-standard.md](docs/report-standard.md) | The quality bar: method and evidence discipline of a validated report |
| [labs/README.md](labs/README.md) | Local labs: Kestrel target, raw byte client, parser harness |
| [docs/workflow.md](docs/workflow.md) | Lead to payout, step by step |

## Setup

Full walkthrough: [docs/quickstart.md](docs/quickstart.md).

```bash
scripts/install-hooks.sh                 # blocks committing confidential files
scripts/install-dotnet.sh                # installs the in-scope SDKs (11.0.100, 10.0.404)
scripts/fetch-targets.sh                 # downloads all 22 pinned source trees, about 15 GB
scripts/labs-smoke.sh                    # builds and tests the labs on both runtimes
scripts/init-research.sh                 # creates the hunter's ledger files in private/research/
scripts/new-finding.sh <short-slug>      # scaffolds findings/<date>-<slug>/ with notes, report, PoC
scripts/patch-diff.sh net10/runtime v10.0.14 --stat    # what a patch changed
```

## Layout

```
docs/program/   researched program rules
docs/           target map and workflow
labs/           standing local labs (Kestrel target, raw client, parser harness)
templates/      MSRC report draft, finding notes, PoC lab skeleton
scope/          manifest, commit lock and SDK versions for everything in scope
scripts/        scaffolding and safety checks
prompts/        hunter operating prompt
findings/       gitignored, local only
private/        gitignored, local only (research ledger)
targets/        gitignored, checked-out dotnet source
```

## The five facts that matter most

1. Only **Critical and Important** severity pays. Moderate and Low pay $0.
2. Only **supported versions** count: .NET 11.0.0 and .NET 10.0.15 as of 2026-11-10.
   .NET 8 and 9 are out.
3. A **Complete** report pays about ten times a Not Complete one, judged at submission.
4. **.NET Framework is out of scope.**
5. Report only through the [MSRC Researcher Portal](https://msrc.microsoft.com/create-report),
   never a public GitHub issue.
