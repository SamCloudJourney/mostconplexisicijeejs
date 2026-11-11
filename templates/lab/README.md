# PoC lab skeleton

Copied into each finding by `scripts/new-finding.sh`. Builds for both in-scope runtimes.

```bash
dotnet --list-runtimes               # record this output in notes.md
dotnet run -c Release -f net11.0     # .NET 11
dotnet run -c Release -f net10.0     # .NET 10
```

For ASP.NET Core or Kestrel targets, change the first line of `Poc.csproj` to
`<Project Sdk="Microsoft.NET.Sdk.Web">`.

Only ever run PoCs against software on your own machine. Never against a host you do not own.
