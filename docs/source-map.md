# Source map

Where each attack surface lives in the downloaded source. Every path below was checked against
the pinned .NET 11.0.0 trees on 2026-11-11. Paths are relative to `targets/net11/`; the same
layout applies under `targets/net10/` unless a directory is new in 11.

Download first: `scripts/fetch-targets.sh`. See [targets.md](targets.md) for why each area matters.

## ASP.NET Core: `aspnetcore/src/`

| Surface | Path |
|---|---|
| Kestrel HTTP/1.1 parser and connection handling | `Servers/Kestrel/Core/src/Internal/Http` |
| Kestrel HTTP/2 | `Servers/Kestrel/Core/src/Internal/Http2` |
| Kestrel HTTP/3 | `Servers/Kestrel/Core/src/Internal/Http3` |
| Shared server parsing helpers | `Shared/ServerInfrastructure` |
| HTTP.sys and IIS integration | `Servers/HttpSys`, `Servers/IIS` |
| Form, multipart and query readers | `Http/WebUtilities/src` |
| Request features, form limits | `Http/Http/src/Features` |
| Routing | `Http/Routing` |
| Authentication handlers (cookies, JWT, OIDC, OAuth) | `Security/Authentication` |
| Authorization | `Security/Authorization` |
| Antiforgery | `Antiforgery` |
| Data Protection | `DataProtection` |
| Identity (including scaffolded UI) | `Identity` |
| SignalR | `SignalR` |
| Blazor Server circuits | `Components/Server` |
| Blazor JS interop client | `Components/Web.JS` |
| MVC model binding | `Mvc/Mvc.Core/src/ModelBinding` |
| Middleware (CORS, forwarded headers, output caching, compression, ...) | `Middleware` |
| OpenAPI, gRPC JSON transcoding | `OpenApi`, `Grpc` |
| Project templates | `ProjectTemplates` |

## Runtime libraries: `runtime/src/libraries/`

| Surface | Path |
|---|---|
| HTTP client | `System.Net.Http` |
| TLS, NTLM, Negotiate | `System.Net.Security` |
| QUIC | `System.Net.Quic` |
| WebSockets, SMTP | `System.Net.WebSockets`, `System.Net.Mail` |
| URI parsing | `System.Private.Uri` |
| JSON | `System.Text.Json` |
| ASN.1, CBOR | `System.Formats.Asn1`, `System.Formats.Cbor` |
| Tar, zip | `System.Formats.Tar`, `System.IO.Compression`, `System.IO.Compression.ZipFile` |
| XML | `System.Private.Xml` |
| Crypto, X.509 | `System.Security.Cryptography` |
| Signed XML, CMS/PKCS, COSE | `System.Security.Cryptography.Xml`, `.Pkcs`, `.Cose` |
| Regex | `System.Text.RegularExpressions` |
| Binary payload readers | `System.Formats.Nrbf`, `System.Resources.Extensions`, `System.Runtime.Serialization.Formatters` |
| Core library | `System.Private.CoreLib` |
| Microsoft's own fuzz harnesses (what is already covered) | `Fuzzing` |

## Native runtime: `runtime/src/`

| Surface | Path |
|---|---|
| VM, JIT, GC | `coreclr/vm`, `coreclr/jit`, `coreclr/gc` |
| Host (`dotnet`, hostfxr, hostpolicy) | `native/corehost` |
| Native shims for crypto, compression, networking | `native/libs` |
| Installers | `installer` |

## SDK and CLI: `sdk/`

| Surface | Path |
|---|---|
| `dotnet` CLI commands | `src/Cli` |
| Templates shipped with the SDK | `template_feed` |
| MSBuild tasks | `src/Tasks` |
| Container publishing | `src/Containers` |
| `dotnet watch` and other built-in tools | `src/BuiltInTools` |

## Everything else that ships: `dotnet-vmr/src/`

`roslyn`, `fsharp`, `efcore`, `msbuild`, `nuget-client`, `winforms`, `wpf`, `windowsdesktop`,
`diagnostics`, `vstest`, `command-line-api`, `arcade`, `sourcelink`, plus copies of `runtime`,
`aspnetcore` and `sdk`. `source-manifest.json` in that directory records the exact upstream commit
of every component.

## Outside the version folders

| What | Path under `targets/` |
|---|---|
| Aspire dashboard, app host, CLI | `adjacent/aspire/src/Aspire.Dashboard`, `Aspire.Hosting`, `Aspire.Cli` |
| ASP.NET Core 2.3 Kestrel | `legacy/aspnetcore-2.3/src/Servers/Kestrel` |
| Live GitHub Actions workflows (86 files, read only) | `actions/<repo>/.github/workflows` |
| .NET security docs | `docs/dotnet-docs/docs/standard/security` |
| ASP.NET Core security docs | `docs/aspnetcore-docs/aspnetcore/security` |
| CVE lists per major version | `reference/core/release-notes/11.0/cve.md`, `10.0/cve.md` |
| .NET 11 per-area release notes | `reference/core/release-notes/11.0/11.0.0/` (`aspnetcore.md`, `libraries.md`, `runtime.md`, ...) |
| **New public API in .NET 11** | `reference/core/release-notes/11.0/11.0.0/api-diff/` |

The `api-diff` folder lists every API added in .NET 11. New API means new code that has had the
least review: a good first read.

## Searching

```bash
grep -rn "stackalloc" targets/net11/runtime/src/libraries/System.Formats.Tar --include=*.cs
grep -rln "pull_request_target" targets/actions/*/.github/workflows
scripts/patch-diff.sh net10/aspnetcore v10.0.14 --stat -- src     # what the last patch touched
```
