# Microsoft .NET Bounty Program: research notes

Researched 2026-11-11 from the official pages listed under [Sources](#sources).
The program page is the authority. Re-read it before every submission: it was revised four times
in the last 16 months (2025-07-31, 2025-12-11, 2026-04-07, 2026-10-20).

## At a glance

| | |
|---|---|
| Program page | https://www.microsoft.com/en-us/msrc/bounty-dot-net-core |
| Award range | $500 to $40,000 USD (higher possible at Microsoft's sole discretion) |
| Minimum severity | **Critical or Important only.** Moderate and Low pay $0 |
| Where to submit | MSRC Researcher Portal: https://msrc.microsoft.com/create-report |
| Never | Open a public GitHub issue for anything with a security implication |
| First response | Within 24 hours (per dotnet SECURITY.md) |
| Assessment | Typically about 2 weeks / 14 business days from case creation |
| Payment | Via Intigriti (bank transfer, PayPal, Payoneer); tax form due within 30 days |

## In scope

- Current, **supported** versions of .NET and ASP.NET Core (including Blazor and Aspire).
- The latest version of ASP.NET Core 2.x, when running on .NET Framework.
- Release candidates for upcoming versions of .NET.
- .NET and ASP.NET Core templates for current supported versions.
- GitHub Actions in the .NET and ASP.NET Core GitHub repositories.
- Documentation on learn.microsoft.com/dotnet (and docs.microsoft.com), and the samples in it,
  for current supported versions.
- Adjacent technologies such as F# (per the July 2025 announcement).
- Preview features listed in
  [bug-bounty-preview-scopes.md](https://github.com/dotnet/core/blob/main/bug-bounty-preview-scopes.md).
  That file is stale: its only entry is HTTP/3 in Kestrel for .NET 6, dated 2021-11-15. Treat
  preview features as out of scope unless MSRC confirms otherwise.

### Supported versions right now

From the .NET support policy page, last updated 2026-11-10:

| Version | Type | Latest patch | End of support |
|---|---|---|---|
| .NET 11 | STS | 11.0.0 (released 2026-11-10) | 2028-11-14 |
| .NET 10 | LTS | 10.0.15 | 2028-11-14 |

See [scope-update-2026-11-10.md](scope-update-2026-11-10.md) for the exact builds and what the
November release changed.

**.NET 8 and .NET 9 went out of support on 2026-11-10.** A bug that only reproduces on 8 or 9 is
now out of scope. Always reproduce on the latest patch of .NET 10 and/or .NET 11. The general
guidelines also exclude "any version other than latest, fully patched version at time of
submission".

.NET 11 is one day old as of this research. New major versions are where fresh code lives.

## Award table

Each cell is **Complete report / Not Complete report**.

| Security impact | Critical | Important |
|---|---|---|
| Remote Code Execution | $40,000 / $4,000 | $30,000 / $3,000 |
| Elevation of Privilege | $40,000 / $4,000 | $30,000 / $3,000 |
| Security Feature Bypass | $30,000 / $3,000 | $10,000 / $1,000 |
| Remote Denial of Service | $20,000 / $2,000 | $10,000 / $1,000 |
| Spoofing or Tampering | $10,000 / $1,000 | $5,000 / $500 |
| Information Disclosure | $10,000 / $1,000 | $5,000 / $500 |
| Insecure documentation or doc samples | $10,000 / $1,000 | $5,000 / $500 |

> **Verify before relying on a cell.** These figures were read from a text extraction of the live
> program page, where the table columns are flattened. The July 2025 announcement blog shows
> different numbers in places (for example much higher "Not Complete" awards, and $10,000 for
> Important Elevation of Privilege). The page's "Updated award amounts" revision on 2025-12-11
> most likely explains the difference, but confirm by eye on the live page.

Rules that apply to the table:

- One submission eligible for several awards gets the single highest one.
- A **Complete** report is worth roughly ten times a Not Complete one. Completeness is judged at
  submission time; information added later does not upgrade it.
  See [report-requirements.md](report-requirements.md).
- Variants of one bug: at most 10 awards.

## Severity (what makes it Critical vs Important)

The .NET page gives no .NET-specific bar. Microsoft's general rating system:

- **Critical**: code execution without user interaction (wormable, or an unavoidable common
  scenario with no warning).
- **Important**: compromise of confidentiality, integrity or availability of user data or
  processing resources, including with prompts.
- **Moderate**: significantly mitigated, for example by authentication requirements or by
  applying only to non-default configurations. **Pays $0.**
- **Low**: comprehensively mitigated. **Pays $0.**

Practical consequence: a bug that needs a non-default configuration, an unusual API usage pattern,
or an authenticated attacker tends to land at Moderate and earn nothing. Target default
configurations and documented, common usage.

## Out of scope for this program

- Vulnerabilities already publicly disclosed, reported to Microsoft, or known to the community.
- **.NET Framework**, and ASP.NET on .NET Framework (WebForms, MVC).
- Out-of-support versions of .NET / .NET Core.
- Daily builds, early betas, anything that is not RTM or RC.
- User-generated content.
- Vulnerabilities requiring extensive or unlikely user actions.
- Vulnerabilities that rely on disabling or not using built-in mitigations.
- Low impact CSRF.
- Server-side information disclosure.
- Platform technology not unique to .NET (IIS, OpenSSL and similar).
- Sub-domain takeover.
- Third-party-based vulnerabilities with no demonstrated qualifying impact.
- Training, documentation, samples and community forum **sites** (the websites themselves; insecure
  doc *content* is a paid category above).

General MSRC exclusions that also apply:

- Scanner or automated-tool output without analysis proving exploitability.
- Anything needing physical attacks or social engineering of Microsoft staff.
- Third-party bugs already covered by another bounty program.
- Issues that only affect unsupported browsers or plugins.
- Issues resolved by a documentation update with no change to product code.
- GitHub, LinkedIn and Activision Blizzard have their own programs.

## Eligibility

- The vulnerability must be previously unreported and unknown to Microsoft.
- First eligible report wins. A duplicate that adds new information may get a differential award.
- Not eligible: residents of sanctioned countries; anyone under 14; current Microsoft employees
  and household; former employees or contractors within six months; people whose employer forbids
  it; public-sector employees without ethics-officer permission.
- Submissions must name the specific product version numbers used for validation.

## Open questions to confirm with MSRC

1. Exact current award figures (see the warning under the award table).
2. Which product-area report requirements .NET falls under ("Endpoint & On-Prem" vs
   "Microsoft-owned open-source software"). Satisfy both to be safe.
3. Whether adjacent repos count (dotnet/efcore, NuGet client, dotnet/sdk, MSBuild, dotnet/maui).
   The page says ".NET and ASP.NET Core"; the blog adds F# and Aspire.
4. Current preview-feature scope, since the listed file is five years stale.

Ask at bounty@microsoft.com.

## Sources

- [Microsoft .NET Bounty Program](https://www.microsoft.com/en-us/msrc/bounty-dot-net-core)
- [Microsoft Bounty Program guidelines, terms and safe harbor](https://www.microsoft.com/en-us/msrc/bounty-guidelines)
- [Requirements for Complete Vulnerability Reports](https://www.microsoft.com/en-us/msrc/requirements-for-complete-vulnerability-reports)
- [Bounty FAQ](https://www.microsoft.com/en-us/msrc/faqs-bounty)
- [.NET Bounty Program now offers up to $40,000 (MSRC blog, 2025-07-31)](https://www.microsoft.com/en-us/msrc/blog/2025/07/net-bounty-program-now-offers-up-to-40000-in-awards)
- [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core)
- [Security Update Severity Rating System](https://www.microsoft.com/en-us/msrc/security-update-severity-rating-system)
- [Security Testing Rules of Engagement](https://www.microsoft.com/en-us/msrc/pentest-rules-of-engagement)
- [dotnet/runtime SECURITY.md](https://github.com/dotnet/runtime/blob/main/SECURITY.md)
- [dotnet/aspnetcore SECURITY.md](https://github.com/dotnet/aspnetcore/blob/main/SECURITY.md)
- [Bug bounty preview scopes](https://github.com/dotnet/core/blob/main/bug-bounty-preview-scopes.md)
