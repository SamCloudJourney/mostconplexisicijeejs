# Scope update: 2026-11-10

Checked 2026-11-11 against the live program page, the .NET support policy and the dotnet/core
release notes.

## What changed, and what did not

**The program page text did not change.** Its revision history still ends at 2026-10-20; there is
no November 2026 entry. The wording of the scope is the same.

**The effective scope changed a lot**, because the page defines scope as "current, supported
versions" and points at the support policy, which changed on 2026-11-10:

| | Before 2026-11-10 | From 2026-11-10 |
|---|---|---|
| .NET 11 | RC only | **In scope.** 11.0.0 released (STS, supported to 2028-11-14) |
| .NET 10 | In scope | **In scope.** Patched to 10.0.15 (LTS, supported to 2028-11-14) |
| .NET 9 | In scope | **Out of scope.** End of support, final patch 9.0.23 |
| .NET 8 | In scope | **Out of scope.** End of support, final patch 8.0.34 |
| .NET 11 RC1 to RC3 | In scope as release candidates | Superseded by 11.0.0. Test on RTM |

## Exact builds to test against

| Line | Runtime | SDK | Visual Studio |
|---|---|---|---|
| .NET 11 | 11.0.0 | 11.0.100 | 18.12.0 |
| .NET 10 | 10.0.15 | 10.0.404 (also 10.0.115) | 18.11.4 |

Shipped alongside .NET 11: C# 15, F# 11, Entity Framework Core 11. The newest Aspire tag is
v13.6.5.

A report must reproduce on these builds or newer. The general guidelines exclude "any version
other than latest, fully patched version at time of submission". A bug that only reproduces on
8.x, 9.x, 10.0.14 or earlier, or an 11.0 RC is not eligible.

## The November 2026 security release

10.0.15 fixed 17 CVEs and 11.0.0 lists 22. These are now **public and known**, so they are not
reportable, but they are the best map of where the product team just found weaknesses. Use them
for variant analysis: read each advisory, find the fix between the previous tag and the current
one, and look for the same pattern elsewhere.

Fixed in both 10.0.15 and 11.0.0:
CVE-2026-114146, CVE-2026-109475, CVE-2026-114147, CVE-2026-105544, CVE-2026-114149,
CVE-2026-114151, CVE-2026-114152, CVE-2026-109476, CVE-2026-118745, CVE-2026-114155,
CVE-2026-70175, CVE-2026-118747, CVE-2026-114157, CVE-2026-114158, CVE-2026-114159.

Listed for 10.0.15 only: CVE-2026-114154, CVE-2026-118741.

Listed for 11.0.0 only: CVE-2026-114150, CVE-2026-109481, CVE-2026-114156, CVE-2026-118746,
CVE-2026-118748, CVE-2026-118749, CVE-2026-120796.

CVE-2026-118741 is worth reading closely. It is an ASP.NET Core Elevation of Privilege that
"affects ASP.NET Core Identity scaffolding and templates", and the notes say updating the runtime
alone does not repair generated code. It shows that **template output** is treated as a real,
Important-or-higher attack surface.

Full details: `targets/reference/core/release-notes/10.0/10.0.15/10.0.15.md` and
`targets/reference/core/release-notes/11.0/11.0.0/11.0.0.md` after running the fetch script.

To see what a patch changed, deepen one tree and diff the tags:

```bash
cd targets/net10/runtime
git fetch --depth 1 origin tag v10.0.14
git diff v10.0.14 v10.0.15 --stat
```

## Still unresolved

- [bug-bounty-preview-scopes.md](https://github.com/dotnet/core/blob/main/bug-bounty-preview-scopes.md)
  is unchanged since 2021-11-15 and still names .NET 6. Treat preview features as out of scope
  until MSRC says otherwise.
- The program page links no list of repositories. Which repos count beyond runtime and aspnetcore
  is inferred; the `scope` column in [scope/targets.tsv](../../scope/targets.tsv) records how sure
  we are about each.

## Sources

- [Microsoft .NET Bounty Program](https://www.microsoft.com/en-us/msrc/bounty-dot-net-core)
- [.NET support policy](https://dotnet.microsoft.com/en-us/platform/support/policy/dotnet-core)
- [dotnet/core releases.md](https://github.com/dotnet/core/blob/main/releases.md)
- [.NET 11.0.0 release notes](https://github.com/dotnet/core/blob/main/release-notes/11.0/11.0.0/11.0.0.md)
- [.NET 10.0.15 release notes](https://github.com/dotnet/core/blob/main/release-notes/10.0/10.0.15/10.0.15.md)
- [Announcing .NET 11](https://devblogs.microsoft.com/dotnet/announcing-dotnet-11/)
