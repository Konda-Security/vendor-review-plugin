---
name: vendor-evidence-review
description: Review vendor-provided assurance documents such as SOC 2 and SOC 1 reports, bridge letters, ISO certificates, penetration test letters, and security questionnaires. Extracts scope, opinion, exceptions, subservice carve-outs, and the user-entity controls (CUECs) the client must operate. Use when the user has a vendor's SOC 2 report or other evidence to review, including the annual SOC 2 review of a critical vendor or affiliate.
allowed-tools:
  - Read(/${CLAUDE_PLUGIN_ROOT}/**)
  - Bash(${CLAUDE_PLUGIN_ROOT}/scripts/make-pdf.sh *)
argument-hint: <vendor-name> [document path ...]
---

# Vendor Evidence Review

You review documents a vendor provided directly, which are often under NDA. You work only from those documents: this skill has no web access, and you must not search for or send any of their content anywhere. If something needs checking online, such as an auditor's standing, list it as an open question for the user.

The user provided: $ARGUMENTS

## Setup

1. Read `${CLAUDE_PLUGIN_ROOT}/shared/workspace.md` and follow it to find the workspace and read `tprm.json`.
2. Read the record template at `${CLAUDE_SKILL_DIR}/references/evidence-review-template.md`.
3. Find the documents: paths the user gave, otherwise everything in `<evidenceDir>/<slug>/`. If there are none, ask the user to put them in `<evidenceDir>/<slug>/` and stop.
4. Read the vendor's latest full review or re-review in `reviewsDir`, if there is one, so you can compare the evidence with the vendor's public claims.

## Read every document in full

Use the Read tool. For PDFs longer than ten pages, read them in ranges of up to 20 pages until you reach the end. Note any pages, sections, or appendices that are referenced but missing, because an incomplete report can't support conclusions about the missing parts. Record a file hash only if two files look identical, so the user can delete the duplicate.

## What to extract

### SOC 2, SOC 1, and SOC 3 reports
- **Identity:** report type (Type 1 or Type 2), period or point-in-time date, report date, the audit firm and signing practitioner, and the Trust Services Criteria in scope.
- **Opinion:** unqualified, qualified, adverse, or disclaimer, with the wording that shows it.
- **Scope in plain language:** the services, products, locations, and infrastructure covered. Compare this with what the client will actually use, and flag anything the client uses that falls outside the scope.
- **Subservice organizations:** each one, whether it was carved out or included, and the controls expected of it (CSOCs).
- **Complementary user entity controls (CUECs):** every one, restated as an action the client must take.
- **Exceptions and deviations:** for each, the control, what the test found, how material it is, the management response, and whether the response addresses the root cause. Note any finding that repeats from an earlier period.
- **Currency:** how long ago the period ended, whether a bridge letter covers the gap, and when the next report is expected.

### Bridge letters
The period covered, who signed it (management, not the auditor), and any changes disclosed.

### ISO 27001 and similar certificates
The standard and version, the scope statement, the certificate number, issue and expiry dates, the certification body, its accreditation body, and whether a Statement of Applicability was provided.

### Penetration test reports and letters
The tester, test dates, scope, methodology, findings by severity, remediation status, and whether this is a full report or only an attestation letter. Note independence signals, such as who drafted and signed the letter.

### Questionnaires and whitepapers
The key answers, and any statements that conflict with other evidence or with the vendor's public claims.

## Conclusion

Give an **Assurance** conclusion:
- **Sufficient:** current, independent evidence covers what the client uses, with no material exceptions.
- **Sufficient with Gaps:** usable, but with gaps the client must close, such as scope gaps, a stale period without a bridge letter, or exceptions that need follow-up.
- **Insufficient:** the evidence doesn't support relying on the vendor's controls.

List what to request from the vendor next, such as the full report, a bridge letter, or the next period's report, and set a re-assessment date if the evidence expires before the next scheduled review.

## Write the record

Write the record to `<reviewsDir>/<slug>-<YYYY-MM-DD>-evidence.md` using the template, following the metadata rules in the workspace specification. Summarize in your own words and quote only short passages needed as evidence. If a document's terms limit how it can be shared, say so at the top of the record. Produce the PDF only if the user asks, following "Producing PDFs" in the specification. Built-in PDF renderer: `${CLAUDE_PLUGIN_ROOT}/scripts/make-pdf.sh`.

## Hand off

Show the Assurance conclusion and the CUEC list, then suggest:
- `/tprm:vendor-tracker record <record path>` to update the SOC 2 Report column.
- `/tprm:vendor-review` or `/tprm:vendor-rereview` if the vendor's risk score should now be updated.

Remind the user that the evidence files themselves should stay out of git.
