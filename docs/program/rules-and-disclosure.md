# Rules, confidentiality and safe harbor

Summary of the obligations in the
[Microsoft Bounty Program guidelines](https://www.microsoft.com/en-us/msrc/bounty-guidelines)
(terms last updated 2025-07-23), the [bounty FAQ](https://www.microsoft.com/en-us/msrc/faqs-bounty)
and the [Rules of Engagement](https://www.microsoft.com/en-us/msrc/pentest-rules-of-engagement).
This is a working summary, not legal advice. Read the originals.

## Confidentiality: the rule this repo is built around

**This repository is public.** Under the bounty terms:

- Submissions must remain confidential and may not be disclosed to third parties.
- After a fix ships, only high-level descriptions and non-reversible demonstrations may be shared.
- Detailed PoC or exploit code must be withheld for at least 30 days after the fix.
- Contact bounty@microsoft.com before any public discussion.
- Breaking these rules can forfeit the bounty, require returning money already paid, and
  disqualify you from future participation.

Pushing notes, a PoC, a crash dump, or even a suggestive file name or commit message about an
unfixed bug to this repo is public disclosure. It also makes the bug "publicly disclosed", which is
itself an out-of-scope category. So:

| Goes in this repo | Never goes in this repo |
|---|---|
| Program research, checklists, templates | Anything under `findings/` (gitignored) |
| Generic tooling and lab skeletons | PoCs, crash dumps, traces, captures, videos |
| Notes on already-public, already-patched CVEs | Hypotheses about a specific unreported weakness |
| | Commit messages or branch names that hint at a live bug |

Guards in place: `.gitignore`, a pre-commit hook (`scripts/install-hooks.sh`) and a CI check
(`scripts/check-public-safety.sh`). They block file paths, not content, so judgement still applies.

Recommended: keep live findings in a separate **private** repository or local encrypted storage.

## Other terms that cost people bounties

- **Do not set deadlines.** Imposing a fix timeline or SLA on Microsoft forfeits eligibility.
- **Follow Coordinated Vulnerability Disclosure.** Reports that do not may be ineligible.
- **Report the version.** Name the exact product version numbers you validated against.
- **Completeness is fixed at submission.** Later additions do not upgrade a Not Complete report.
  A working exploit sent within 90 days may earn an additional award at Microsoft's discretion.
- **Decisions are final and binding.**
- **Tax form** (W-9, W-8BEN or 8233) is due within 30 calendar days of the award notice.

## Rules of engagement

.NET is a product you download and run, so nearly all research happens against your own machine.
That is where it should stay.

Do:

- Run every PoC against builds and services on hardware you own or a tenant you own.
- Stop at proof of concept.

Do not:

- Test against any live Microsoft service, or anyone else's .NET application or server.
- Run denial-of-service tests against anything you do not own. DDoS is prohibited outright.
- Use credentials or secrets that are not yours, including leaked ones.
- Access, keep or share data that is not yours. If it happens by accident: stop, tell MSRC,
  delete it, and say so in the report.
- Phish or socially engineer Microsoft staff.
- Take post-exploitation steps (enumeration, lateral movement, dumping secrets).

GitHub Actions in the dotnet repositories are in scope, but they are live shared infrastructure.
Analyse workflows by reading them and reproduce in your own fork. Do not open pull requests or
trigger runs against the real dotnet repositories to test an attack.

## Safe harbor

Microsoft states it will not pursue civil or criminal action for accidental or good-faith
violations of the policy, treats in-policy research as authorized under the CFAA and DMCA, and
waives conflicting site policies for permitted research.

Limits:

- It cannot bind third parties. Research touching anyone else's systems is not covered.
- Microsoft decides what counts as good faith.
- Their own advice: if in doubt, ask first.
