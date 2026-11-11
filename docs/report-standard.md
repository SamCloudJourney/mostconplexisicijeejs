# Report standard: what a validated report looks like

The quality bar for every report leaving this workspace. It is distilled from the structure and
evidence discipline of the owner's report for **CVE-2026-120006** (.NET Aspire, Elevation of
Privilege, rated Important, CVSS 7.5, CWE-201, affected 13.6.4, fixed in 13.6.5 on 2026-11-10),
which MSRC confirmed and fixed.

Only the method is recorded here. The technical write-up of that case is deliberately not in this
public repository: the bounty terms ask for detailed material to be withheld for at least 30 days
after a fix (so not before 2026-12-10) and for bounty@microsoft.com to be contacted first.

Use this page next to [program/report-requirements.md](program/report-requirements.md), which
lists what MSRC formally requires. This page is about what makes the argument convincing.

## The core method: follow the authority

Start from a protected outcome, not from a bug class. State it as one sentence:

> Principal A must never gain the authority reserved for principal B.

Then trace authority from where it is issued to where it is finally used. The dangerous behaviour
often sits in no single function: it appears when several individually legitimate features are
composed. A function-by-function audit misses that; following the credential or capability across
every hop does not.

| Step | Question to answer |
|---|---|
| Identify principals | Who controls the input, and who performs the final operation? |
| Inventory authority | Which credentials or capabilities change what an actor may do? |
| Map boundaries | Where does information move between trust levels? |
| Check the audience | Is the recipient authorised to hold this credential? |
| Check provenance | Where was the capability issued, and for whom? |
| Check state over time | Is an earlier authorisation decision still valid at the point of use? |
| Validate the terminal effect | What observable effect proves the invariant failed? |
| Run negative controls | Which alternative explanations can be experimentally rejected? |
| Reproduce | Does the same input in a fresh environment give the same result? |
| Validate the fix | Would the proposed fix restore the invariant without breaking normal use? |

## What the report must contain

1. **Executive summary.** Start position, end position, and the chain between them, in a few
   sentences. Say what the finding is *not* (for example "not merely a disclosure").
2. **Threat model.** The attacker's exact starting authority, and the shortcuts deliberately
   excluded so that the product, not a pre-existing privilege, is responsible for the result.
3. **Required user interaction**, stated honestly. It drives the complexity rating.
4. **The security invariant**, in one sentence.
5. **Chain architecture.** Each stage, and what crosses the boundary at each one.
6. **Source-level root cause.** The specific components involved and why each matters, including
   ones that look harmless in isolation.
7. **Methodology as falsifiable hypotheses.** Each phase states a hypothesis and the test that
   could have disproved it.
8. **Laboratory configuration.** Exact versions of every component, OS, architecture, identities.
9. **Before and after table.** Starting authority against demonstrated terminal authority.
10. **Negative controls and alternative explanations**, each with the test that rejected it.
11. **Distinction from related or known issues**, so triage does not close it as a duplicate.
12. **Remediation and regression guidance**, including keeping the negative controls as tests.
13. **Evidence levels**, separating what was observed from what is inferred.

## Evidence discipline

**Prove the credential or primitive is real.** Receiving something that looks sensitive proves
nothing. Show a differential:

| Condition | Expected | Shows |
|---|---|---|
| No credential | Rejected | The endpoint is not simply public |
| Tampered credential | Rejected | Arbitrary values are not accepted |
| Captured credential | Accepted | It is a valid, usable credential |

**Do not stop at the first primitive.** Continue until the terminal effect is independently
observable. Reports are assessed on demonstrated terminal impact, not on the initial mechanism.

**Build a harmless terminal-effect oracle.** Use a benign marker, never a destructive payload.
Make it unforgeable by the lower-privileged side: a unique nonce, and a location or property only
the higher-privileged principal could produce. Verify identity, ownership, permissions and nonce,
and verify the marker is *absent* in every negative control.

**Repeat on a fresh environment with identical inputs.** Hash the source packet and state the
hash. Changing the PoC between runs weakens the claim.

**Sanitise the evidence.** Receipts and a verifier script let a reviewer check the result without
the archive containing reusable secrets.

**Grade your own claims.**

| Level | Example | Confidence to claim |
|---|---|---|
| Direct observation | A specific request returned a specific result | High |
| Joined experimental proof | The full chain produced the marker, controls did not | High, in the tested configuration |
| Generalisation | Every installation is exploitable | Not established unless tested |

Overstating is the fastest way to lose a triager's trust.

## Lessons from how that case went

- **Severity is decided by Microsoft's engineering classification.** The chain ended in code
  execution as the host user and was still rated Important, not Critical, because it needed a
  specific user workflow and had high attack complexity. Expect interaction and complexity to cap
  the rating, and argue severity once, with evidence, rather than repeatedly.
- **Timeline to expect.** Submission to confirmed behaviour took about a week; public fix came two
  weeks after submission, on the monthly release.
- **Confidential runners were used.** The proof ran on a *private* GitHub Actions workflow. That
  is the model for any unreported finding here: this repository's runners are public.
- **Composition bugs pay.** The finding came from combining ordinary features across a browser, a
  proxy and a control plane. Aspire and other multi-component developer tooling are good ground
  for the same approach.

## Pre-submission comparison

Before submitting, compare the draft against this list. Every line should be a yes.

- [ ] One-sentence invariant stated.
- [ ] Attacker start position is precise, and shortcuts are explicitly excluded.
- [ ] User interaction is stated plainly.
- [ ] Every stage of the chain has its own evidence.
- [ ] The primitive is proven real with an accept/reject differential.
- [ ] The terminal effect is shown with a harmless, unforgeable oracle.
- [ ] Each alternative explanation has a negative control that rejects it.
- [ ] Reproduced at least twice on fresh environments with hashed, identical inputs.
- [ ] Exact versions of every component are listed.
- [ ] Related known issues are named and distinguished.
- [ ] Claims are graded: observed, proven in configuration, or not established.
- [ ] Remediation and regression tests are proposed.
- [ ] Evidence archive is sanitised and hashed.
