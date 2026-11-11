# What makes a report "Complete"

A Complete report pays about ten times a Not Complete one, so this checklist is worth more than
any other page in the repo.

Source: [Requirements for Complete Vulnerability Reports](https://www.microsoft.com/en-us/msrc/requirements-for-complete-vulnerability-reports).
These requirements apply to every report submitted on or after 2026-10-20 08:00 Pacific.

## Three rules first

1. **Missing any required item makes the whole report Not Complete.**
2. **It is judged as submitted.** Adding material afterwards does not change the assessment.
   Do not submit early and promise a PoC later.
3. **Fill in the portal fields themselves.** A report that just points at an attached write-up may
   be assessed Not Complete. Aim for about 5,000 characters across the narrative sections.

## Required in every report

- [ ] **Type of vulnerability**: a classification (for example use-after-free, request smuggling,
      path traversal).
- [ ] **Affected component**: name plus version (assembly, package, source path).
- [ ] **Affected target environment and platform**: OS and application, with all known vulnerable
      versions, builds and configurations. For Windows include the `BuildLabEx` string.
- [ ] **Steps to reproduce** from a well-known starting state: ordered, executable, including
      setup and any non-default configuration.
- [ ] **Reliable, minimized proof of concept**: runs automatically where possible, needs minimal
      system changes, has no redundant steps, reproduces every time.
- [ ] **Detailed and correct analysis including root cause**: how each part of the PoC triggers
      the bug, and how timing or environment affect it.
- [ ] **Exploitability and attack conditions**: who the attacker is, starting privileges,
      prerequisites, the triggering action. Cite public docs for claims about default behaviour.
- [ ] **Impact**: what the attacker gains, which boundary or data is affected, and whether it is
      confidentiality, integrity or availability. Must follow from the exploitability section.

## Product-area extras

The page does not say which area .NET belongs to. Satisfy both that could apply.

**Endpoint and on-prem products**

- Denial of service or memory corruption: crash dump or TTD trace, call stack, PoC source.
- Information disclosure: explanation of how the data reaches the attacker, call stack, PoC
  source, and a crash dump or TTD trace.
- Anything else: PoC source or script.

**Microsoft-owned open-source software**

- URL to the repository (pin the tag or commit and the file and line).
- PoC against a running instance.

**Web application style findings (ASP.NET Core)**

- At least one form of impact evidence, clearly separating what the PoC proves from what is
  hypothetical. Video is recommended.

## Evidence capture cheatsheet

| Evidence | How |
|---|---|
| Exact runtime | `dotnet --info` and `dotnet --list-runtimes` |
| Managed crash dump | `dotnet-dump collect -p <pid>`, or set `DOTNET_DbgEnableMiniDump=1` and `DOTNET_DbgMiniDumpType=4` before running |
| Call stack | `dotnet-dump analyze <dump>` then `clrstack -all` / `pe` |
| Native crash dump (Windows) | WinDbg `.dump /mpwdF` |
| TTD trace (Windows) | WinDbg Time Travel Debugging on the faulting process |
| Network behaviour | `tcpdump -i lo -w evidence/trace.pcap` or Wireshark |
| Windows build string | `reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v BuildLabEx` |

## Final check before pressing submit

- [ ] Reproduced today on the **latest patch** of a supported version (.NET 10 or 11).
- [ ] Reproduces with **default configuration**, or the report justifies why the configuration is
      common and documented.
- [ ] Not already public: searched the dotnet GitHub issues and announcements, and the CVE lists.
- [ ] Severity argued explicitly as Critical or Important, using Microsoft's own definitions.
- [ ] Impact category chosen from the award table.
- [ ] No fix deadline or disclosure ultimatum anywhere in the text.
- [ ] Every item in "Required in every report" is in a portal field, not only in an attachment.
