# Target map

Where to look. Unlike the files in `docs/program/`, most of this page is **working guidance from
general knowledge of the .NET codebase and its public CVE history, not program rules.** Verify
specifics against the source and the advisories before relying on them.

## Source trees

Every in-scope source tree is listed in [scope/targets.tsv](../scope/targets.tsv) and pinned to an
exact commit in [scope/targets.lock](../scope/targets.lock). One command downloads all of it into
the gitignored `targets/` directory:

```bash
scripts/fetch-targets.sh            # everything: 21 trees, about 12 GB on disk
scripts/fetch-targets.sh net11      # one group
scripts/fetch-targets.sh --verify   # check downloads against the lock
```

| Group | Contents | Scope confidence |
|---|---|---|
| `targets/net11/` | .NET 11.0.0: the complete product (`dotnet-vmr`), plus `runtime`, `aspnetcore`, `sdk` | Confirmed |
| `targets/net10/` | .NET 10.0.15: same four trees | Confirmed |
| `targets/legacy/` | ASP.NET Core 2.3 (the 2.x line that runs on .NET Framework) | Confirmed |
| `targets/adjacent/` | Aspire 13.6.5, Microsoft.Extensions 11.0.0 | Aspire named; extensions unconfirmed |
| `targets/docs/` | Source of learn.microsoft.com/dotnet and /aspnet/core | Confirmed (insecure samples category) |
| `targets/actions/` | Live GitHub Actions workflows from `main` of the four core repos | Confirmed. Read only |
| `targets/reference/` | dotnet/core: release notes and per-release CVE lists | Reference, not a target |
| `targets/unconfirmed/` | MAUI 11, YARP, dotnet-docker | **Ask MSRC before reporting** |

`dotnet-vmr` is [dotnet/dotnet](https://github.com/dotnet/dotnet), the single repository Microsoft
builds the whole SDK from. Everything that ships is under its `src/`: runtime, aspnetcore, sdk,
roslyn, fsharp, efcore, msbuild, nuget-client, winforms, wpf, windowsdesktop, diagnostics, vstest,
command-line-api, arcade and more. The
separate `runtime`, `aspnetcore` and `sdk` clones are the same code in its familiar upstream
layout.

.NET 8 and .NET 9 are deliberately absent: they left support, and scope, on 2026-11-10.

Trees are shallow (one commit). To read history or diff two releases, deepen as needed, for
example `git fetch --depth 1 origin tag v10.0.14`.

## Think about the trust boundary first

A .NET bug only pays if **the framework** breaks a promise, not the application developer. Before
investing in a lead, answer:

1. Which input is attacker-controlled, in a default or documented deployment?
2. What does the documentation promise about that input (safe for untrusted data, or not)?
3. Does it need a non-default setting or unusual API usage? If so, expect Moderate, which pays $0.

Known "not a vulnerability" positions worth knowing in advance:

- `BinaryFormatter` and other documented-unsafe deserializers on untrusted input.
- Code Access Security and partial trust are not security boundaries in modern .NET.
- Loading an attacker-supplied assembly, or running attacker-supplied code, is code execution by
  design.
- Many "untrusted regex pattern" and "untrusted XSLT / XAML" scenarios are documented as unsafe.

## Areas with a history of paid bug classes

Ordered roughly by award ceiling.

**Network-facing parsers and protocol state machines (RCE, Security Feature Bypass, remote DoS)**

- Kestrel HTTP/1.1 parsing: request smuggling, chunked encoding, header handling. Smuggling in
  Kestrel has been rated as a high-severity security feature bypass before.
- Kestrel HTTP/2 and HTTP/3 (QUIC): stream state, flow control, reset handling, HPACK and QPACK.
- `System.Net.Http` client stack, `System.Net.Security` (TLS, NTLM, Negotiate), WebSockets.
- SignalR hubs and its protocols (JSON and MessagePack).

**Authentication, authorization and cryptographic guarantees (EoP, Security Feature Bypass)**

- ASP.NET Core authentication handlers (cookies, JWT bearer, OpenID Connect), authorization
  middleware, antiforgery.
- Data Protection: key management, payload validation.
- X.509 chain building and validation, `System.Security.Cryptography.Xml` (signed XML),
  `System.Security.Cryptography.Pkcs` and `Cose`.
- Blazor Server circuit handling and the JS interop boundary.

**Format parsers that are documented as safe for untrusted input (DoS, info disclosure, tampering)**

- `System.Text.Json`, `System.Formats.Asn1`, `System.Formats.Cbor`.
- `System.Formats.Tar` and `System.IO.Compression` (zip): path traversal on extraction, link
  handling, decompression bombs.
- `System.Xml` with default settings.
- Model binding and form/multipart readers in ASP.NET Core, including request size limits.

**Memory safety (RCE)**

- `unsafe` code, `Span` and `MemoryMarshal` misuse, and native interop inside the libraries.
- The native runtime (GC, JIT, host) reachable from data rather than from code.

**Local elevation of privilege**

- Installers, the host resolver (`hostfxr`), and SDK/CLI behaviour with predictable or
  world-writable paths and temp files, especially on Linux and macOS.

**Supply chain and automation**

- GitHub Actions workflows in the dotnet repos (explicitly in scope): `pull_request_target`
  misuse, script injection from PR fields, over-broad token permissions. Read only; reproduce in
  your own fork.
- Project templates that generate insecure defaults.

**Documentation (up to $10,000)**

- Samples on learn.microsoft.com/dotnet that teach an insecure pattern without saying the sample
  ignores security. Low competition, and reviewable without any lab.

## Methods

- **Variant analysis.** Read each security advisory in
  [dotnet/announcements](https://github.com/dotnet/announcements/issues?q=label%3ASecurity), find
  the fix commit, then search for the same pattern elsewhere. Most productive starting point.
- **Diff the new release.** .NET 11 shipped on 2026-11-10. New and rewritten code is in scope from
  day one and has had the least scrutiny.
- **Differential testing.** Compare how Kestrel and a common reverse proxy parse the same bytes.
- **Fuzzing.** [SharpFuzz](https://github.com/Metalnem/sharpfuzz) with AFL++ or libFuzzer against
  library parsers. dotnet/runtime has its own fuzzing harnesses under `src/libraries/Fuzzing`
  worth reading to see what is already covered. A fuzzer crash alone is not a report: it still
  needs root cause, exploitability and impact.

## Reference reading

- [dotnet/announcements security advisories](https://github.com/dotnet/announcements/issues?q=label%3ASecurity)
- [aspnet/Announcements](https://github.com/aspnet/Announcements/issues?q=label%3ASecurity)
- [MSRC Security Update Guide](https://msrc.microsoft.com/update-guide)
- [.NET security docs](https://learn.microsoft.com/dotnet/standard/security/)
- [ASP.NET Core security docs](https://learn.microsoft.com/aspnet/core/security/)
