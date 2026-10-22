---
name: vendor-tracker
description: Maintain the approved-services tracker for third party risk management. Adds Pending Review rows, records the client's decision from a review record, lists vendors due for re-review, checks the tracker against the workspace rules, and migrates an existing tracker to the standard format. Use when the user asks to "update the approved services list", "record a vendor decision", "what vendor reviews are due", or "check the vendor tracker".
allowed-tools:
  - Read(/${CLAUDE_PLUGIN_ROOT}/**)
argument-hint: add <vendor> | record <record path> | due [days] | check | migrate | retire <vendor>
---

# Vendor Tracker

You maintain the client's approved-services tracker, the source of truth for which vendors are approved and on what terms. The tracker records the client's **decisions**; review records hold the evidence and the assessor's recommendation.

## Setup

1. Read `${CLAUDE_PLUGIN_ROOT}/shared/workspace.md` and follow it to find the workspace and read `tprm.json`. The "Tracker format" section there is the specification for every change you make.
2. Read the tracker file. If it doesn't exist, offer to create it from `${CLAUDE_SKILL_DIR}/references/approved-services-template.md` with the configured categories, entity column, and flag columns, then continue.
3. Use today's date for any date you write.

The user asked for: $ARGUMENTS

Pick the mode from the first word. With no arguments, give a short summary (row counts by status, vendors due in the next 30 days, and the number of `check` findings) and list the modes below.

Every mode that changes the tracker shows the user the exact rows it will add or change, and writes only after the user confirms. Keep existing prose; change only what the mode requires. Update the `**Last reviewed**` date whenever you write.

## add <vendor> [issue]

Add a Pending Review row for a proposed vendor or one already in use without a review.

1. If the vendor already has a row, show it and stop.
2. Collect, in one message, whatever is missing: category, service, data handled, entity (when configured), each flag (when configured), and the intake request. If an issue number was given, read it with `gh issue view` and use its answers; that command isn't pre-approved, so the user sees a prompt.
3. Write the row with Status `Pending Review`, SOC 2 Report `—` unless known, Last Review `—`, and Next Review `—`.

## record <record path>

Record the client's decision from a review record (full review, re-review, quick check, or evidence review).

1. Read the record. Take the vendor, website, record type, assessment date, recommendation, overall score and rating, tier ratings, main conditions or reasons, SOC 2 status, re-assessment date, Request, Entities, and Related reviews.
2. Find the matching rows using the matching rules in the specification. A record with tier ratings may back several rows, one per tier the client uses.
3. **Evidence review:** update only the SOC 2 Report column, and Next Review if the evidence expires sooner. Leave Status unchanged.
4. **Other records:** propose each row:
   - **Decision:** default to the usual decision for the recommendation (see the table in the specification), and ask the user to confirm or change it. A quick check that says Full Review Required keeps the row at Pending Review.
   - **Status cell:** the decision, then `— Score: X.XX/5.0 (<Rating>)` for scored records, then the conditions or reason in one or two sentences, then `(recommended: <recommendation>)` if the decision differs.
   - **Vendor:** link to the record.
   - **Last Review:** the assessment date.
   - **Next Review:** the record's re-assessment date if it gives one, otherwise Last Review plus `reviewCadenceMonths`. For Denied, `—` unless the record sets a date to re-assess.
   - **Request:** from the record's Request field.
   - **Entity and flags:** ask for any value that is missing. Never guess an entity or a flag; they determine audit scope.
5. After writing, suggest `/tprm:vendor-github-sync push` when the workspace uses GitHub.

## due [days]

List vendors that need attention, without changing anything. `days` defaults to 30.

1. Overdue: Next Review before today, oldest first.
2. Due soon: Next Review within `days`.
3. Missing a date: rows other than Pending Review, Denied, or Retired that have no valid Next Review.
4. Pending Review rows, with their Request.

For each row show vendor, status, Last Review, Next Review, and the suggested next step: `/tprm:vendor-rereview <vendor>` for due reviews, `/tprm:vendor-quick-check` or `/tprm:vendor-review` for pending ones.

## check

Validate the tracker against the specification and the records, without changing anything. Report each finding with the vendor and what to fix:

- Columns missing or out of order for the configured entities and flags.
- Status cells that don't start with a status word.
- Entity values outside `entities`; flag values other than Yes or No.
- Vendor links that don't resolve, and Last Review dates that don't match the linked record.
- Missing or invalid Next Review dates, and Next Review dates later than Last Review plus `reviewCadenceMonths` without a reason in the record.
- Records in `reviewsDir` that no row links to, and Pending Review rows that already have a record.

End with the count of findings, and offer `migrate` to fix the structural ones.

## migrate

Convert an existing tracker to the standard format without losing information.

1. Run the `check` analysis first and show the findings.
2. Plan the changes:
   - Add missing columns: Entity, the configured flags, Next Review, Request.
   - Turn "See reviews/<file>.md" references into the Vendor link, and remove the reference from the Status cell.
   - Set Next Review from the earliest re-assessment date in either the Status prose or the linked record. Read each record's summary, recommendation, and risk factors for phrases like "re-review by", "re-assess", "remediation plan due", or "in N months", and convert relative periods from the record's assessment date. Otherwise use Last Review plus `reviewCadenceMonths`. Show which source each date came from, and ask about ambiguous ones, such as "reassess quarterly during" an external event.
   - Fill Request from the linked record's Request field when present.
   - Leave Entity and flag cells as `?` when the records don't state them, and list those rows for the user to answer. Never guess them.
3. Show a summary of the changes and a few example rows before and after, and ask before writing.
4. After writing, run `check` again and report what remains.

## retire <vendor>

Mark a vendor no longer in use: Status `Retired — <date and reason>`, Next Review `—`. Keep the row and its link for the audit trail.
