# Workflow: from lead to payout

## 1. Pick a lead

Use [targets.md](targets.md). Write the lead down in a finding workspace straight away:

```bash
scripts/new-finding.sh <short-slug>     # creates findings/<date>-<slug>/, local only
```

Keep the slug vague. It never leaves your machine, but habits carry over.

## 2. Triage before investing time

Answer the kill questions in `notes.md`. If any answer is "no", drop the lead.

| Question | Why |
|---|---|
| Does it reproduce on the latest patch of .NET 10 or 11? | Older versions are out of scope |
| Is the affected code in an in-scope product? | .NET Framework, IIS, OpenSSL are not |
| Does it work in a default or documented configuration? | Otherwise Moderate, which pays $0 |
| Is the input really attacker-controlled across a trust boundary? | Otherwise not a vulnerability |
| Is it new? Searched issues, announcements, CVEs? | Known issues are out of scope |
| Can I argue Critical or Important with Microsoft's definitions? | Lower pays $0 |

## 3. Build the proof of concept

Work in `findings/<...>/poc/`. Minimal, automatic, reliable. Record `dotnet --info` output.
Only ever target software running on your own machine.

## 4. Root-cause it

Find the exact file, line and commit in the pinned release tag. A report without root cause is
Not Complete.

## 5. Collect evidence

Follow the cheatsheet in [program/report-requirements.md](program/report-requirements.md). Store
everything under `findings/<...>/evidence/`.

## 6. Write the report

Fill in `findings/<...>/report.md` (from `templates/msrc-report.md`), then run the final checklist
in report-requirements.md. Completeness is judged once, at submission.

## 7. Submit

MSRC Researcher Portal: https://msrc.microsoft.com/create-report. Paste the content into the
portal fields; do not rely on attachments alone. Record the case number in `notes.md`.

## 8. After submitting

- Expect acknowledgement within 24 hours and assessment in roughly two weeks.
- Answer MSRC questions quickly. Never set a deadline for the fix.
- Send the tax form within 30 days of an award notice.
- Stay silent publicly. After the fix ships, wait at least 30 days and contact
  bounty@microsoft.com before publishing anything detailed.
- Only then may a write-up be added to this public repo.
