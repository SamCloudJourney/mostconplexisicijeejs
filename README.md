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
| [docs/workflow.md](docs/workflow.md) | Lead to payout, step by step |

## Setup

Requires git and the [.NET SDK](https://dotnet.microsoft.com/download) (10 and 11).

```bash
scripts/install-hooks.sh                 # blocks committing confidential files
scripts/fetch-targets.sh                 # downloads every pinned in-scope source tree into targets/
scripts/new-finding.sh <short-slug>      # scaffolds findings/<date>-<slug>/ with notes, report, PoC
```

## Layout

```
docs/program/   researched program rules
docs/           target map and workflow
templates/      MSRC report draft, finding notes, PoC lab skeleton
scope/          manifest and commit lock for every in-scope source tree
scripts/        scaffolding and safety checks
findings/       gitignored, local only
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
