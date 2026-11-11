# MSRC report draft

<!-- CONFIDENTIAL. Lives under findings/ only. Never commit a filled-in copy to the public repo.
     Every section below is required for a "Complete" assessment. Paste each into the matching
     portal field. Aim for about 5,000 characters across the narrative sections. -->

## Title

<!-- Product, component, vulnerability type, impact. -->

## Program and classification

- Bounty program: Microsoft .NET Bounty Program
- Security impact (pick one from the award table):
- Claimed severity (Critical / Important) and the reason, using Microsoft's definitions:

## Type of vulnerability

## Affected component

- Product:
- Assembly / package and version:
- Source location (repo, release tag, file, line):

## Affected target environment and platform

- .NET version(s) confirmed vulnerable (must include the latest patch):
- Versions confirmed not vulnerable, if any:
- OS and architecture (Windows: include BuildLabEx):
- Configuration (state clearly if everything is default):
- `dotnet --info` output:

```
```

## Steps to reproduce

<!-- From a well-known starting state (clean OS, fresh SDK install). Ordered and executable. -->

1.
2.
3.

Expected result:

Actual result:

## Proof of concept

<!-- Full source needed to build and run. Minimal, automatic, reliable. -->

## Analysis and root cause

<!-- How each part of the PoC triggers the bug. The faulty logic, with file and line.
     How timing or environment affect it. -->

## Exploitability and attack conditions

- Attacker (remote unauthenticated / authenticated / local):
- Starting privileges:
- Prerequisites:
- Triggering action:
- User interaction required:
- Why this applies to default or documented deployments (cite the docs):

## Impact

<!-- What the attacker gains, which boundary or data, and whether confidentiality, integrity or
     availability. Separate what the PoC proves from what is hypothetical. -->

## Evidence attached

- [ ] PoC source
- [ ] Crash dump or TTD trace (DoS, memory corruption, info disclosure)
- [ ] Call stack
- [ ] Packet capture (network bugs)
- [ ] Video or screenshots (web-style impact)

## Suggested fix (optional)
