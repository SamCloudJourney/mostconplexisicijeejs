# Labs

Standing local environments for studying how .NET behaves. Each one builds for both in-scope
runtimes (`net11.0` and `net10.0`) and only ever talks to this machine.

| Lab | What it is for |
|---|---|
| [kestrel-target](kestrel-target/) | ASP.NET Core app on loopback with default Kestrel settings. `/echo` reports exactly what the server believes it received (raw target, headers, body length and hash); `/form` and `/json` exercise the form and JSON readers. HTTP/1.1 on `LAB_PORT` (5080), cleartext HTTP/2 on the next port |
| [raw-client](raw-client/) | Sends exact bytes to a local port and prints the raw response. Needed because HTTP libraries normalise requests. Refuses any non-loopback destination |
| [parser-harness](parser-harness/) | Feeds one file to one framework parser (`json`, `xml`, `asn1`, `x509`, `zip`, `tar`, `uri`) and reports outcome, time and allocation. For triaging inputs and comparing .NET 10 with 11 |
| [samples](samples/) | Benign inputs used by the smoke test |

The per-finding PoC skeleton is separate: `templates/lab`, copied by `scripts/new-finding.sh`.

## Run

```bash
scripts/labs-smoke.sh                       # build everything, test on both runtimes

cd labs
dotnet run --project kestrel-target -f net11.0 &
dotnet run --project raw-client -f net11.0 -- 5080 --file samples/get-echo.http
dotnet run --project raw-client -f net11.0 -- 5080 --text "GET / HTTP/1.1\r\nHost: lab\r\n\r\n"
dotnet run --project parser-harness -f net10.0 -- json samples/sample.json
```

Run the same input under `-f net10.0` and `-f net11.0` to spot behaviour that differs between
versions.

## Windows, Linux and macOS runners

`.github/workflows/labs.yml` runs the smoke test on `windows-latest`, `ubuntu-latest` and
`macos-latest` with the SDK versions in `scope/sdk-versions.txt`. It also prints the Windows
`BuildLabEx` string that MSRC reports require. Trigger it from the Actions tab ("Run workflow")
or by changing anything under `labs/`.

> **The runner logs are public, because this repository is public.** Use the workflow to confirm
> the generic labs and SDKs work on each OS. Never run a finding's PoC in it and never commit
> finding-specific inputs to `labs/samples`. For confidential testing on Windows, use your own
> machine or copy the workflow into a private repository.

## Rules

- Loopback only. Nothing here should ever be pointed at a host you do not own.
- Keep Kestrel at its defaults unless you are deliberately studying a setting, and write down any
  change: non-default configuration usually means Moderate severity, which pays nothing.
- A harness result is a lead, not a finding. It still needs root cause, exploitability and impact.
